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
import           Data.MumbleProto.UserRemove            as UR (session)
import           Data.MumbleProto.UserState             as US
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
    src <- pluginServerMessagesE PacketUserState PacketUserRemove
    $(logInfo) "startup completed"
    let pr = awaitForever $ \p -> do
          db <- liftIO . atomically . takeTMVar $ v
          cdb <- getPluginExport pcdb
          case p of
            -- upsert
            Left a -> case updateUserDB cdb db a of
              Left err -> do
                $(logWarn) (mconcat ["unable to update userdb: ", T.pack err])
                liftIO .atomically .putTMVar v $ db
              Right db' -> do
                let sid = a ^. US.session
                liftIO . atomically . putTMVar v $ db'
                $(logInfo) (mconcat ["updated user ", T.pack . show $ sid])

            -- remove
            Right a -> do
              let sid = _SessionId # (a ^. UR.session)
              let db' = deleteUser sid db
              liftIO . atomically . putTMVar v $ db'
              $(logInfo) (mconcat ["removed user ", T.pack . show $ sid])
    runConduit $ src .| pr

makePrisms 'PluginUserDB
