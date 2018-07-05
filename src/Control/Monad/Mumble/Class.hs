{-# LANGUAGE ConstrainedClassMethods #-}
{-# LANGUAGE FlexibleContexts        #-}
{-# LANGUAGE OverloadedStrings       #-}
{-# LANGUAGE TypeFamilies            #-}

module Control.Monad.Mumble.Class
  ( MonadMumble(..), MumbleException(..)
  , mumbleReceivePacket, mumbleSendPacket, mumbleReceiveAny
  , mumbleReceiveEither
  , MonadMumblePlugin(..)
  , pluginServerMessages, pluginServerMessagesE, pluginServerTextMessages
  , pluginSendPacket
  , allocateSendQueue
  ) where


import           Conduit
import           Control.Concurrent.Async
import           Control.Concurrent.STM.TBMQueue
import           Control.Exception
import           Control.Lens.Fold
import           Control.Lens.Operators
import           Control.Monad
import           Control.Monad.Logger
import           Control.Monad.Trans.Resource
import qualified Data.Conduit.Combinators        as CC
import           Data.Conduit.TQueue
import           Data.Mumble.ChannelState
import           Data.Mumble.Helpers
import           Data.Mumble.Packet
import           Data.Mumble.TextMessages
import           Data.Mumble.Types
import           Data.MumbleProto.Ping
import           Data.MumbleProto.Reject
import           Data.MumbleProto.TextMessage
import           Data.Time.Clock
import           Data.Typeable                   (Typeable)

data MumbleException
  = NoMoreData
  | InvalidState String
  | DecodePacketFailed String
  | UnexpectedRawPacket PacketType PacketType RawPacket
  | UnexpectedPacket PacketType PacketType
  | AuthenticationFailed Reject
  | ChannelDBFail String
  | UserDBFail String
  | PongFailure Ping Ping
  | TextMessageFailure TextMessage String
  deriving Typeable

instance Show MumbleException where
    show NoMoreData               = "no more packets from mumble socket"
    show (InvalidState s)         = "application in invalid state: " ++ s
    show (DecodePacketFailed s)   = " unable to parse raw packet: " ++ s
    show (UnexpectedRawPacket a b rp) =
      let c = fst $ rp ^. _RawPacket
      in mconcat ["expectede packet ", show a, " or ", show b, ", but got ", show c]
    show (UnexpectedPacket a b) =
      mconcat ["expected packet ", show a, " but got ", show b]
    show (AuthenticationFailed r) =
      mconcat ["authentication failed: ", maybe "" show $ r ^. reason]
    show (ChannelDBFail err) =
      mconcat ["error updating channel db: ", err]
    show (UserDBFail err) =
      mconcat ["error updating user db: ", err]
    show (PongFailure a b) =
      mconcat ["expected pong: " , show a, ", got: ", show b]
    show (TextMessageFailure m e) =
      mconcat ["unexpected TextMessage: '" , show e, "': ", show m]
instance Exception MumbleException

class (MonadIO m, MonadThrow m, MonadLogger m) => MonadMumblePlugin m where
  pluginAnyServerMessage :: m (ConduitT () APacket m ())
  pluginGetChannelDB :: m ChannelDB
  pluginSend :: RawPacket -> m ()
  pluginElapsedTime :: m NominalDiffTime
  pluginSelfSession :: m SessionId

class (MonadMumblePlugin (MonadMumblePluginT m), MonadThrow m, MonadResource m, MonadLoggerIO m, MonadUnliftIO m) => MonadMumble m where
  type MonadMumblePluginT m :: * -> *

  mumbleReceive :: m RawPacket
  mumbleReceiveMany :: MumblePacket a => PacketTypeProxy a -> m [a]
  mumbleSend :: RawPacket -> m ()


filterMessages :: (MonadThrow m, MumblePacket a) =>
  PacketTypeProxy a -> ConduitT APacket a m ()
filterMessages p =
  let t = proxyPacketType p
  in awaitForever $ \a ->
    let t' = a ^. packetTypeAny
    in if t /= t' then return ()
      else case preview (_APacket p) a of
             Just p' -> yield p'
             Nothing -> throwM $ UnexpectedPacket t t'

filterMessagesE :: (MonadThrow m, MumblePacket a, MumblePacket b) =>
  PacketTypeProxy a -> PacketTypeProxy b -> ConduitT APacket (Either a b) m ()
filterMessagesE a b =
  let ta = proxyPacketType a
      tb = proxyPacketType b
  in awaitForever $ \p ->
    let t' = p ^. packetTypeAny
    in if t' == ta
       then case preview (_APacket a) p of
              Just p' -> yield (Left p')
              Nothing -> throwM $ UnexpectedPacket ta t'
       else when (t' == tb) $
            case preview (_APacket b) p of
              Just p' -> yield (Right p')
              Nothing -> throwM $ UnexpectedPacket tb t'


decodeTextMessage ::
  (MonadIO m, MonadThrow m) => TextMessage -> m MumbleTextMessage
decodeTextMessage m = do
  t <- liftIO getCurrentTime
  either (throwM . TextMessageFailure m) pure . toMumbleTextMessage t $ m


pluginServerMessages :: (MumblePacket a, MonadMumblePlugin m) =>
  PacketTypeProxy a -> m (ConduitT () a m ())
pluginServerMessages p = do
  ap' <- pluginAnyServerMessage
  return (ap' .| filterMessages p)

pluginServerTextMessages :: (MonadMumblePlugin m) =>
  m (ConduitT () MumbleTextMessage m ())
pluginServerTextMessages = do
  c <- pluginServerMessages PacketTextMessage
  return $ c .| CC.mapM decodeTextMessage


pluginServerMessagesE :: (MumblePacket a, MumblePacket b, MonadMumblePlugin m) =>
  PacketTypeProxy a -> PacketTypeProxy b -> m (ConduitT () (Either a b) m ())
pluginServerMessagesE a b = do
  ap' <- pluginAnyServerMessage
  return (ap' .| filterMessagesE a b)


mumbleReceivePacket :: (MumblePacket a, MonadMumble m) => PacketTypeProxy a -> m a
mumbleReceivePacket a =
  packetFromRawE a <$> mumbleReceive >>=
    either (throwM . DecodePacketFailed) pure



mumbleSendPacket :: (MumblePacket a, MonadMumble m) => a -> m ()
mumbleSendPacket = mumbleSend . rawFromPacket

pluginSendPacket :: (MumblePacket a, MonadMumblePlugin m) => a -> m ()
pluginSendPacket = pluginSend . rawFromPacket

mumbleReceiveAny :: (MonadMumble m) => m APacket
mumbleReceiveAny = do
  f <- raw2apacket <$> mumbleReceive
  either (throwM . DecodePacketFailed) pure f


mumbleReceiveEither :: (MumblePacket a, MumblePacket b, MonadMumble m) =>
  PacketTypeProxy a -> PacketTypeProxy b -> m (Either a b)
mumbleReceiveEither a b =
  let a' = proxyPacketType a
      b' = proxyPacketType b
  in do
    rp <- mumbleReceive
    let (c,_) = rp ^. _RawPacket
        onE = either (throwM . DecodePacketFailed) pure
        ea = Left <$> onE (packetFromRawE a rp)
        eb = Right <$> onE (packetFromRawE b rp)
    if c == a' then ea else if c == b' then eb else
      throwM (UnexpectedRawPacket a' b' rp)

allocateSendQueue :: (MonadMumble m) => m (TBMQueue RawPacket)
allocateSendQueue = do
  a <- allocateTBMQueue 8
  p <- withRunInIO $ \run -> async . run . runConduit . sendQPacketC $ a
  liftIO $ link p
  void $ register (cancel p)
  return a
  where sendQPacketC a = sourceTBMQueue a .| CC.mapM_ mumbleSend
