{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}

module Control.Monad.Mumble.Plugins.Debug
  ( PluginPrintAnyPackage, _PluginPrintAnyPackage
  , PluginPrintTextMessages, _PluginPrintTextMessages
  , PluginEchoBot, _PluginEchoBot
  ) where


import           Conduit
import           Control.Lens.TH
import           Control.Monad.Logger
import           Control.Monad.Mumble.Class
import           Control.Monad.Mumble.Plugins
import qualified Data.Conduit.Combinators     as CC
import           Data.Mumble.Packet
import qualified Data.Text                    as T

data PluginPrintAnyPackage

instance MumblePlugin PluginPrintAnyPackage where
  data MumblePluginConfig PluginPrintAnyPackage = PluginPrintAnyPackage

  type MumblePluginState PluginPrintAnyPackage = ()
  type MumblePluginExport PluginPrintAnyPackage = ()

  getPluginName = const "PluginPrintAnyPackage"
  getPluginInitalState = const (pure ())
  getPluginExport = const (pure ())
  runPlugin _ = do
    src <- pluginAnyServerMessage
    $(logInfo) "startup completed"
    runConduit $ src .| CC.mapM_ $(logDebugSH)

makePrisms 'PluginPrintAnyPackage


data PluginPrintTextMessages


instance MumblePlugin PluginPrintTextMessages where
  data MumblePluginConfig PluginPrintTextMessages = PluginPrintTextMessages

  type MumblePluginState PluginPrintTextMessages = ()
  type MumblePluginExport PluginPrintTextMessages = ()

  getPluginName = const "PluginPrintTextMessages"
  getPluginInitalState = const (pure ())
  getPluginExport = const (pure ())
  runPlugin _ = do
    src <- pluginServerTextMessages
    $(logInfo) "startup completed"
    runConduit $ src .| CC.mapM_ pr
      where pr a = $(logInfo) (mconcat ["got text message ", T.pack . show $ a])

makePrisms 'PluginPrintTextMessages


data PluginEchoBot

instance MumblePlugin PluginEchoBot where
  data MumblePluginConfig PluginEchoBot = PluginEchoBot

  type MumblePluginState PluginEchoBot = ()
  type MumblePluginExport PluginEchoBot = ()

  getPluginName = const "PluginEchoBot"
  getPluginInitalState = const (pure ())
  getPluginExport = const (pure ())
  runPlugin _ = do
    src <- pluginServerMessages PacketTextMessage
    $(logInfo) "startup completed"



makePrisms 'PluginEchoBot
