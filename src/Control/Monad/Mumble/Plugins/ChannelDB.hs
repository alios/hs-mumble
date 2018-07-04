{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}


module Control.Monad.Mumble.Plugins.ChannelDB
  ( PluginChannelDB, _PluginChannelDB
  ) where

import           Conduit

import           Control.Concurrent.STM
import           Control.Lens.Operators
import           Control.Lens.TH
import           Control.Monad.Logger
import           Control.Monad.Mumble.Class
import           Control.Monad.Mumble.Plugins
import           Data.Mumble.ChannelState
import           Data.Mumble.Packet
import           Data.MumbleProto.ChannelState
import qualified Data.Text                     as T


data PluginChannelDB

instance MumblePlugin PluginChannelDB where
  data MumblePluginConfig PluginChannelDB = PluginChannelDB [ChannelState]

  type MumblePluginState PluginChannelDB = TMVar ChannelDB
  type MumblePluginExport PluginChannelDB = ChannelDB

  getPluginName = const "PluginChannelDB"
  getPluginExport i = liftIO . atomically . readTMVar $ i ^. pluginInstanceState
  getPluginInitalState (PluginChannelDB cs) =
    either (throwM . ChannelDBFail) (liftIO . newTMVarIO) .
    updateChannelDBMany mempty $ cs

  runPlugin (cfg, v) = do
    src <- pluginServerMessages PacketChannelState
    $(logInfo) "startup completed"
    let pr = awaitForever $ \a -> do
          db <- liftIO . atomically . takeTMVar $ v
          case updateChannelDB db a of
            Left err -> do
              $(logWarn) (mconcat ["unable to update channeldb: ", T.pack err])
              liftIO .atomically .putTMVar v $ db
            Right db' -> do
              $(logDebug) "updated channel db"
              liftIO .atomically .putTMVar v $ db'
    runConduit $ src .| pr

makePrisms 'PluginChannelDB
