{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}


module Control.Monad.Mumble.Plugins.UserDB
  ( PluginUserDB, _PluginUserDB
  ) where

import           Conduit

import           Control.Concurrent.STM
import           Control.Lens.Operators
import           Control.Lens.TH
import           Control.Monad.Logger
import           Control.Monad.Mumble.Class
import           Control.Monad.Mumble.Plugins
import           Control.Monad.Mumble.Plugins.ChannelDB
import           Data.Mumble.Packet
import           Data.Mumble.UserState
import           Data.MumbleProto.UserState
import qualified Data.Text                              as T

data PluginUserDB

instance MumblePlugin PluginUserDB where
  data MumblePluginConfig PluginUserDB = PluginUserDB [UserState]
    (MumblePluginInstance PluginChannelDB)

  type MumblePluginState PluginUserDB = TMVar UserDB
  type MumblePluginExport PluginUserDB = UserDB

  getPluginName = const "PluginUserDB"
  getPluginExport i = liftIO . atomically . readTMVar $ i ^. pluginInstanceState
  getPluginInitalState (PluginUserDB us pcdb) = do
    cdb <- getPluginExport pcdb
    either (throwM . UserDBFail) (liftIO . newTMVarIO) .
      updateUserDBMany cdb mempty $ us

  runPlugin (PluginUserDB _ pcdb, v) = do
    src <- pluginServerMessages PacketUserState
    $(logInfo) "startup completed"
    let pr = awaitForever $ \a -> do
          db <- liftIO . atomically . takeTMVar $ v
          cdb <- getPluginExport pcdb
          case updateUserDB cdb db a of
            Left err -> do
              $(logWarn) (mconcat ["unable to update userdb: ", T.pack err])
              liftIO .atomically .putTMVar v $ db
            Right db' -> do
              $(logDebug) "updated user db"
              liftIO .atomically .putTMVar v $ db'
    runConduit $ src .| pr

makePrisms 'PluginUserDB
