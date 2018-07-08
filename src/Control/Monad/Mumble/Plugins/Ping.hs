{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}


module Control.Monad.Mumble.Plugins.Ping
  ( PluginPingTCP, _PluginPingTCP, PingExport(..)
  ) where

import           Conduit
import           Control.Concurrent
import           Control.Concurrent.STM
import           Control.Lens.Operators
import           Control.Lens.TH
import           Control.Monad
import           Control.Monad.Logger
import           Control.Monad.Mumble.Class
import           Control.Monad.Mumble.Plugins
import           Data.Mumble.Accumulators
import           Data.Mumble.Packet
import           Data.MumbleProto.Ping
import qualified Data.Text                    as T
import           Data.Typeable                (Typeable)
import           Data.Vector                  (Vector)
import qualified Data.Vector                  as V
import           Data.Word
import           GHC.Generics                 (Generic)
import qualified Text.ProtocolBuffers.Basic   as PB

data PingData = PingData
  { _tcpPingTs   :: TMVar (Vector Float)
  , _tcpMean     :: TMVar Float
  , _tcpVariance :: TMVar Float
  , _tcpPingsN   :: TMVar Word32
  , _udpPingTs   :: TMVar (Vector Float)
  , _udpMean     :: TMVar Float
  , _udpVariance :: TMVar Float
  , _udpPingsN   :: TMVar Word32
  }
makeLenses ''PingData

data PingExport = PingExport
  { pingMean     :: Float
  , pingVariance :: Float
  } deriving (Eq, Show, Typeable, Generic)

data PluginPingTCP

addTCPPingT :: MonadIO m => Int -> PingData -> Float -> m ()
addTCPPingT i st t =
  let ps = st ^. tcpPingTs
  in liftIO . atomically $ do
    ts <- takeTMVar ps
    let ts' = V.take i $ V.cons t ts
        (m, v) = accMeanVariance ts'
    void $ swapTMVar (st ^. tcpMean) m
    void $ swapTMVar (st ^. tcpVariance) v
    putTMVar ps ts'

addUDPPingT :: MonadIO m => Int -> PingData -> Float -> m ()
addUDPPingT i st t =
  let ps = st ^. udpPingTs
  in liftIO . atomically $ do
    ts <- takeTMVar ps
    let ts' = V.take i $ V.cons t ts
        (m, v) = accMeanVariance ts'
    putTMVar (st ^. udpMean) m
    putTMVar (st ^. udpVariance) v
    putTMVar ps ts'


instance MumblePlugin PluginPingTCP where
  data MumblePluginConfig PluginPingTCP = PluginPingTCP
    { pingTCPdelay :: Int
    , pingTCPHistory :: Int
    , pingTCPdata :: Maybe PingData
    }

  type MumblePluginState PluginPingTCP = PingData
  type MumblePluginExport PluginPingTCP = PingExport

  getPluginName = const "PluginPingTCP"
  getPluginInitalState cfg =
    let pd0 = liftIO . atomically $ PingData
              <$> newTMVar mempty <*> newTMVar 0 <*> newTMVar 0 <*> newTMVar 0
              <*> newTMVar mempty <*> newTMVar 0 <*> newTMVar 0 <*> newTMVar 0
    in maybe pd0 pure . pingTCPdata $ cfg
  getPluginExport st =
    let pd = st ^. pluginInstanceState
    in liftIO . atomically $
      PingExport <$> readTMVar (pd ^. tcpMean) <*> readTMVar (pd ^. tcpVariance)


  runPlugin (cfg, pd) = do
    src <- pluginServerMessages PacketPing
    $(logInfo) "startup completed"
    forever $ do
      liftIO . threadDelay $ pingTCPdelay cfg * 1000000
      $(logDebug) "sending ping to server"
      p <- getPing
      pluginSendPacket p
      p' <- runConduit $ src .| await
      case p' of
        Nothing -> throwM NoMoreData
        Just p'' -> do
          pt0 <- maybe (throwM NoMoreData) pure $ p'' ^. timestamp
          pt1' <- pluginElapsedTime
          let
            pt1 = round $ pt1' * 1000
            rt = pt1 - pt0
          $(logDebug) (mconcat ["got valid pong back from server in "
                               , T.pack . show $ rt
                               , "ms."])
          addTCPPingT (pingTCPHistory cfg) pd (fromRational . toRational $ rt)
      where
        getPing :: (MonadMumblePlugin m) => m Ping
        getPing = do
          dt <- pluginElapsedTime
          let dtw :: PB.Word64
              dtw = round $ dt * 1000

          (tm, tv) <- liftIO . atomically $
            (,) <$> readTMVar (pd ^. tcpMean) <*> readTMVar (pd ^. tcpVariance)
          (um, uv) <- liftIO . atomically $
            (,) <$> readTMVar (pd ^. udpMean) <*> readTMVar (pd ^. udpVariance)

          tn <- liftIO . atomically $ do
            let v = pd ^. tcpPingsN
            tn' <- takeTMVar v
            putTMVar v (succ tn')
            return tn'
          un <- liftIO . atomically . readTMVar $ pd ^. udpPingsN

          -- TODO: ping values
          return $ Ping {
            _timestamp = pure dtw,
            _good = Just 0, -- TODO
            _late = Just 0, -- TODO
            _lost = Just 0, -- TODO
            _resync = Just 0, -- TODO
            _udp_packets = Just un,
            _tcp_packets = Just tn,
            _udp_ping_avg = Just um,
            _udp_ping_var = Just uv,
            _tcp_ping_avg = Just tm,
            _tcp_ping_var = Just tv
            }


makePrisms 'PluginPingTCP


data PluginPingUDP

instance MumblePlugin PluginPingUDP where
  data MumblePluginConfig PluginPingUDP = PluginPingUDP
    { pingUDPdelay :: Int
    , pingUDPHistory :: Int
    , pingUDPdata :: Maybe PingData
    }

  type MumblePluginState PluginPingUDP = PingData
  type MumblePluginExport PluginPingUDP = (Bool, PingExport)

  getPluginName = const "PluginPingUDP"
  getPluginInitalState cfg =
    let pd0 = liftIO . atomically $ PingData
              <$> newTMVar mempty <*> newTMVar 0 <*> newTMVar 0 <*> newTMVar 0
              <*> newTMVar mempty <*> newTMVar 0 <*> newTMVar 0 <*> newTMVar 0
    in maybe pd0 pure . pingUDPdata $ cfg


makePrisms 'PluginPingUDP
