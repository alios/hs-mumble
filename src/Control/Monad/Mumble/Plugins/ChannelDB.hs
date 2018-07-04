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
import           Data.MumbleProto.ChannelRemove as CR
import           Data.MumbleProto.ChannelState  as CS

import qualified Data.Text                      as T


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

  runPlugin (_, v) = do
    src <- pluginServerMessagesE PacketChannelState PacketChannelRemove
    $(logInfo) "startup completed"
    let pr = awaitForever $ \p -> do
          db <- liftIO . atomically . takeTMVar $ v
          case p of
            -- upsert
            Left a -> case updateChannelDB db a of
              Left err -> do
                $(logWarn) (mconcat ["unable to update channeldb: ", T.pack err])
                liftIO . atomically . putTMVar v $ db
              Right db' -> do
                $(logDebug) "updated channel db"
                liftIO . atomically . putTMVar v $ db'

            -- remove
            Right a -> do
              let cid = _ChannelId # (a ^. CR.channel_id)
              $(logDebug) (mconcat ["removing channel ", T.pack . show $ cid])
              let db' = deleteChannel cid db
              liftIO . atomically . putTMVar v $ db'

    runConduit $ src .| pr

makePrisms 'PluginChannelDB
