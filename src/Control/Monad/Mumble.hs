{-# LANGUAGE ConstraintKinds            #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE RankNTypes                 #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE TypeSynonymInstances       #-}

module Control.Monad.Mumble
  ( MumbleT, runMumbleT
  , MumbleState
  , module Control.Monad.Mumble.Class
  , withMumbleAuthenticate, withMumble
  , startClient
  ) where


import           Conduit
import           Control.Concurrent.Async
import           Control.Concurrent.STM
import           Control.Concurrent.STM.TBMQueue
import           Control.Lens.Operators
import           Control.Lens.Review
import           Control.Lens.TH
import           Control.Monad
import           Control.Monad.Logger
import           Control.Monad.Mumble.Class
import           Control.Monad.Mumble.Plugins
import           Control.Monad.Mumble.Plugins.ChannelDB
import           Control.Monad.Mumble.Plugins.Debug
import           Control.Monad.Mumble.Plugins.Ping
import           Control.Monad.Mumble.Plugins.UserDB
import           Control.Monad.Reader
import           Control.Monad.Trans.Resource
import           Crypto.Cipher.AES
import           Crypto.Cipher.Types
import           Crypto.Error
import           Data.Binary
import qualified Data.Binary.Put                        as Put
import qualified Data.ByteString.Lazy                   as BL
import qualified Data.Conduit.Combinators               as CC
import qualified Data.Conduit.List                      as CL
import           Data.Conduit.Network
import           Data.Conduit.Network.TLS
import           Data.Conduit.TMChan
import           Data.Mumble.Helpers
import           Data.Mumble.Packet
import           Data.Mumble.Types
import           Data.MumbleProto.Authenticate
import           Data.MumbleProto.ChannelState
import           Data.MumbleProto.CodecVersion
import           Data.MumbleProto.CryptSetup
import           Data.MumbleProto.PermissionQuery
import           Data.MumbleProto.ServerSync            as SS
import           Data.MumbleProto.UserState
import           Data.MumbleProto.Version
import qualified Data.Text                              as T
import           Data.Time.Clock
import           Data.Typeable                          (Typeable)
import qualified Data.Version                           as HsMumble
import           GHC.Generics                           (Generic)
import qualified Paths_hs_mumble                        as HsMumble
import qualified System.Info                            as System
import qualified Text.ProtocolBuffers.Basic             as PB


data AuthInfo = AuthInfo
  { _serverConnectT           :: UTCTime
  , _serverVersion            :: Version
  , _serverCodecVersion       :: CodecVersion
  , _serverSync               :: ServerSync
  , _cipherServer             :: AEAD AES128
  , _cipherClient             :: AEAD AES128
  , _initialChannels          :: [ChannelState]
  , _initialPermissionQueries :: [PermissionQuery]
  , _initialUsers             :: [UserState]
  , _serverMessages           :: TMChan APacket
  , _sendToServer             :: TBMQueue RawPacket
  }
makeClassy ''AuthInfo
makePrisms ''AuthInfo

data MumbleSession = MumbleSession
  { _sessionAuthInfo  :: AuthInfo
  , _sessionPingTCP   :: TMVar (MumblePluginInstance PluginPingTCP)
  , _sessionChannelDB :: TMVar (MumblePluginInstance PluginChannelDB)
  , _sessionUserDB    :: TMVar (MumblePluginInstance PluginUserDB)
  } deriving (Typeable, Generic)
makeClassy ''MumbleSession
makePrisms ''MumbleSession


instance HasAuthInfo MumbleSession where
  authInfo = sessionAuthInfo



data MumbleState m where
  MumbleState ::
    TMVar (SealedConduitT () RawPacket m ()) ->
    ConduitT RawPacket Void m () ->
    TMVar MumbleSession ->
    MumbleState m

_recvSocket ::
  MumbleState m -> TMVar (SealedConduitT () RawPacket m ())
_recvSocket (MumbleState rs _ _) = rs
_sendSocket :: MumbleState m -> ConduitT RawPacket Void m ()
_sendSocket (MumbleState _ ss _) = ss
_mumbleSession :: MumbleState m -> TMVar MumbleSession
_mumbleSession (MumbleState _ _ s) = s



newtype MumbleT m a = MumbleT
  { _runMumbleT :: LoggingT (ResourceT (ReaderT (MumbleState m) m)) a }
  deriving ( Functor, Applicative, Monad
           , MonadIO, MonadThrow
           , MonadLogger, MonadLoggerIO
           , MonadResource
           , MonadReader (MumbleState m)
           )


instance MonadUnliftIO m => MonadUnliftIO (MumbleT m) where
  withRunInIO = ww
    where
      ww :: MonadUnliftIO m =>
            ((forall a. MumbleT m a -> IO a) -> IO b) -> MumbleT m b
      ww inner = MumbleT $ withRunInIO $ \run -> inner (run . _runMumbleT)


newtype MumblePluginT m a = MumblePluginT
  { _runMumblePluginT ::  ReaderT MumbleSession (LoggingT (ResourceT m)) a }
  deriving ( Functor, Applicative, Monad
           , MonadIO, MonadThrow
           , MonadLogger, MonadLoggerIO
           , MonadResource
           , MonadReader MumbleSession
           )

runMumbleT :: MonadUnliftIO m => MumbleState m -> MumbleT m a -> m a
runMumbleT s m = runReaderT (runResourceT . runStdoutLoggingT . _runMumbleT $ m) s

runMumblePluginT :: MonadUnliftIO m =>
  (Loc -> LogSource -> LogLevel -> LogStr -> IO ()) ->
  MumbleSession -> MumblePluginT m a -> m a
runMumblePluginT l s m =
  runResourceT (runLoggingT (runReaderT (_runMumblePluginT m ) s) l)


instance MonadTrans MumbleT where
  lift = MumbleT . lift . lift . lift

instance MonadTrans MumblePluginT where
  lift = MumblePluginT . lift . lift . lift

instance (MonadThrow m, MonadUnliftIO m, MonadIO m) => MonadMumble (MumbleT m) where
  type MonadMumblePluginT (MumbleT m) = MumblePluginT m

  mumbleReceive = do
    mumbleWithSink await >>= maybe (throwM NoMoreData) pure
  mumbleSend a = do
    st <- asks _sendSocket
    lift . runConduit $ yield a .| st
  mumbleReceiveMany a = do
    r <- mumbleWithSink (mumbleManyOfC (proxyPacketType a) .| CL.consume)
    case sequence $ packetFromRawE a <$> r of
      Left err -> throwM . DecodePacketFailed $ err
      Right rr -> pure rr

startPlugin ::
  (MonadThrow m, MumblePlugin p, MonadUnliftIO m) => MumblePluginConfig p -> MumbleT m (MumblePluginInstance p)
startPlugin cfg =
  let n = getPluginName cfg
  in do
    logInfoN (mconcat ["starting pluging ", T.pack n])
    st <- getPluginInitalState cfg
    s <- asks _mumbleSession >>= liftIO . atomically . readTMVar
    l <- logSetSrc (T.pack n) <$> askLoggerIO
    a <- liftIO . async . runMumblePluginT l s $ runPlugin (cfg, st)
    liftIO $ link a
    void $ register (cancel a)
    return $ _MumblePluginInstance # (cfg, st, a)

logSetSrc :: LogSource -> (Loc -> LogSource -> LogLevel -> LogStr -> IO ()) -> Loc -> LogSource -> LogLevel -> LogStr -> IO ()
logSetSrc b f a = const (f a b)

instance (MonadIO m, MonadThrow m) => MonadMumblePlugin (MumblePluginT m) where
  pluginAnyServerMessage = do
    st <- asks (^. serverMessages)
    sourceTMChan <$> allocateTMChanDup st
  pluginGetChannelDB = do
    vdb <- asks (^. sessionChannelDB)
    db <- liftIO . atomically . readTMVar $ vdb
    getPluginExport db
  pluginElapsedTime =
    diffUTCTime <$> liftIO getCurrentTime <*> asks (^. serverConnectT)
  pluginSend p = do
    s <- asks (^. sendToServer)
    liftIO . atomically . writeTBMQueue s $ p
  pluginSelfSession = do
    a <- asks (^. (serverSync . SS.session))
    maybe (throwM $ InvalidState "could not find session id in auth data")
      (pure . (_SessionId #)) a


mumbleManyOfC :: (Monad m) =>
  PacketType -> ConduitT RawPacket RawPacket m ()
mumbleManyOfC a = do
  rp' <- peekC
  case rp' of
    Nothing -> return ()
    Just rp ->
      let (p, _) = rp ^. _RawPacket
      in when (p == a) $ do
          void await
          yield rp
          mumbleManyOfC a

mumbleWithSink :: MonadIO m =>
  ConduitT RawPacket Void m a -> MumbleT m a
mumbleWithSink snk = do
    st <- asks _recvSocket
    s <- liftIO . atomically . takeTMVar $ st
    (s', r) <- lift $ s $$++ snk
    liftIO . atomically . putTMVar st $ s'
    pure r

-- | start an mumble connection using 'withMumble' and then
--   initialize / authenticate the session
withMumbleAuthenticate :: (MonadThrow m, MonadUnliftIO m) =>
  TLSClientConfig -> Authenticate -> (AuthInfo -> MumbleT m a) -> m a
withMumbleAuthenticate  tlsCfg auth m = withMumble tlsCfg $
  mumbleAuth auth >>= m


-- | start an uninitalized mumble connection
withMumble :: MonadUnliftIO m => TLSClientConfig -> MumbleT m a -> m a
withMumble tlsCfg m = runTLSClient tlsCfg $ \ad -> do
  trecv <- liftIO $ newTMVarIO (sealConduitT $ appRawPacketSource ad)
  v <- liftIO newEmptyTMVarIO
  let s = MumbleState trecv (appRawPacketSink ad) v
  runMumbleT s m


appRawPacketSource :: (MonadIO m) => AppData -> ConduitT i RawPacket m ()
appRawPacketSource ad = appSource ad .| rawPacketDecoderC

appRawPacketSink :: (MonadIO m) => AppData -> ConduitT RawPacket Void m ()
appRawPacketSink ad = CC.map (Put.runPut . put) .| CC.map BL.toStrict .| appSink ad

mumbleAuth :: (MumblePacket a, MonadUnliftIO m, MonadThrow m) =>
  a -> MumbleT m AuthInfo
mumbleAuth auth = do
    t <- liftIO getCurrentTime
    mumbleSendPacket hsMumbleVersion

    -- Version
    v <- mumbleReceivePacket PacketVersion

    mumbleSendPacket auth

    cs <- mumbleReceiveEither PacketReject PacketCryptSetup >>=
           either (throwM . AuthenticationFailed) pure
    $(logDebug) "got CryptSetup from server:"
    $(logDebugSH) cs
    (cn, sn)  <- fromCryptSetup cs

    cv <- mumbleReceivePacket PacketCodecVersion
    $(logDebug) "got CodecVersion from server:"
    $(logDebugSH) cv

    chss <- mumbleReceiveMany PacketChannelState
    $(logDebug) (mconcat ["got ", T.pack . show . length $ chss
                         , " ChannelStates from server."])

    pqs <- mumbleReceiveMany PacketPermissionQuery
    $(logDebug) (mconcat ["got ", T.pack . show . length $ pqs
                         , " PermissionQueries from server."])

    uss <- mumbleReceiveMany PacketUserState
    $(logDebug) (mconcat ["got ", T.pack . show . length $ uss
                         , " UserStates from server."])

    sy <- mumbleReceivePacket PacketServerSync
    $(logDebug) "got ServerSync from server:"

    c <- allocateBroadcastTMChan
    sq <- allocateSendQueue
    return $ _AuthInfo # (t, v, cv, sy, cn, sn, chss, pqs, uss, c, sq)




startClient :: (MonadThrow m, MonadUnliftIO m) =>
  TLSClientConfig -> String -> Maybe String -> m ()
startClient tlsCfg u p = do
  let auth = Authenticate
        (pure $ PB.uFromString u)
        (PB.uFromString <$> p)
        mempty mempty (pure True)
  withMumbleAuthenticate tlsCfg auth $ \ai -> do
    logInfoN
      (T.pack $ mconcat
        [ "authenticated as ", show u
        , " with ", show $ tlsClientHost tlsCfg
        , " on port ", show $ tlsClientPort tlsCfg
        ])


    vPingTCP <- liftIO newEmptyTMVarIO
    vChannelDB <- liftIO newEmptyTMVarIO
    vUserDB <- liftIO newEmptyTMVarIO
    let s = MumbleSession ai vPingTCP vChannelDB vUserDB
    v <- asks _mumbleSession
    liftIO . atomically . putTMVar v $ s


    pPingTCP <- startPlugin (_PluginPingTCP # (15, 15))
    pChannelDB <- startPlugin (_PluginChannelDB # (ai ^. initialChannels ))
    pUserDB <- startPlugin (_PluginUserDB # (ai ^. initialUsers, pChannelDB ))

    liftIO . atomically $ do
      putTMVar vPingTCP pPingTCP
      putTMVar vChannelDB pChannelDB
      putTMVar vUserDB pUserDB

--    void $ startPlugin (_PluginPrintAnyPackage # ())
--    void $ startPlugin (_PluginPrintTextMessages # ())
--    void $ startPlugin (_PluginEchoBot # ())

    forever $ do
      a <- mumbleReceiveAny
      liftIO . atomically . writeTMChan (s ^. serverMessages) $ a





fromCryptSetup' ::
  CryptSetup -> Either String (AEAD AES128, AEAD AES128)
fromCryptSetup' cs =
  let k = maybe mempty BL.toStrict $ cs ^. key
  in do
    cn <- maybeToRight "unable to read client nonce" $
            cs ^. client_nonce
    sn <- maybeToRight "unable to read server nonce" $
            cs ^. server_nonce
    (s, c) <- mapEL show . eitherCryptoError $ do
      ciph' <- cipherInit k
      s' <- aeadInit AEAD_OCB ciph' (BL.toStrict sn)
      c' <- aeadInit AEAD_OCB ciph' (BL.toStrict cn)
      pure (s', c')

    pure (s, c)

fromCryptSetup ::
  Monad m => CryptSetup -> m (AEAD AES128, AEAD AES128)
fromCryptSetup = either fail pure . fromCryptSetup'


hsMumbleVersion :: Version
hsMumbleVersion = Version {
  _version = Just . review _VersionField $ VersionField (1,2,4),
  _release =
      Just . PB.uFromString . HsMumble.showVersion $ HsMumble.version,
  _os = Just . PB.uFromString $ System.os,
  _os_version = Just . PB.uFromString $ System.arch
  }
