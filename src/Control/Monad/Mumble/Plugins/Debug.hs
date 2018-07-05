{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}

module Control.Monad.Mumble.Plugins.Debug
  ( PluginPrintAnyPackage, _PluginPrintAnyPackage
  , PluginPrintTextMessages, _PluginPrintTextMessages
  ) where


import           Conduit
import           Control.Lens.Operators
import           Control.Lens.TH
import           Control.Monad.Logger
import           Control.Monad.Mumble.Class
import           Control.Monad.Mumble.Plugins
import qualified Data.Conduit.Combinators     as CC
import           Data.Mumble.Helpers
import           Data.Mumble.Packet
import           Data.MumbleProto.TextMessage as TextMessage
import qualified Data.Set                     as Set
import qualified Data.Text                    as T
import qualified Text.ProtocolBuffers.Basic   as PB

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
    src <- pluginServerMessages PacketTextMessage
    $(logInfo) "startup completed"
    runConduit $ src .| CC.mapM_ pr
      where pr :: MonadLogger m => TextMessage -> m ()
            pr a =
              let m = T.pack . PB.uToString $ a ^. message
                  act = maybe "" (\s -> T.pack $ mconcat [ "from actor ", show s, " " ]) $
                        a ^. actor
                  sl = case Set.toList . seqset $ a ^. session of
                         []  -> ""
                         [s] -> mconcat [ " in session ", T.pack . show $ s, " "]
                         ss -> mconcat [ " in sessions ", T.pack . show $ ss, " "]
                  ci = case Set.toList . seqset $ a ^. TextMessage.channel_id of
                         []  -> ""
                         [s] -> mconcat [ " in channel id ", T.pack . show $ s, " "]
                         ss -> mconcat [ " in channel ids ", T.pack . show $ ss, " "]
                  ti = case Set.toList . seqset $ a ^. tree_id of
                         []  -> ""
                         [s] -> mconcat [ " in tree id ", T.pack . show $ s, " "]
                         ss -> mconcat [ " in tree ids ", T.pack . show $ ss, " "]
              in $(logInfo) (mconcat ["got message ", act, sl, ci, ti, ": ", m])

makePrisms 'PluginPrintTextMessages
