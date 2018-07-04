{-# LANGUAGE FlexibleContexts       #-}
{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE OverloadedStrings      #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeFamilies           #-}


module Control.Monad.Mumble.Plugins
  ( MumblePlugin(..)
  , MumblePluginInstance, _MumblePluginInstance, HasMumblePluginInstance(..)
  ) where

import           Control.Concurrent.Async
import           Control.Lens.TH
import           Control.Monad.IO.Class
import           Control.Monad.Mumble.Class


class MumblePlugin p where
  data MumblePluginConfig p :: *
  type MumblePluginState p :: *
  type MumblePluginExport p :: *

  getPluginName :: MumblePluginConfig p -> String
  runPlugin :: MonadMumblePlugin m =>
    (MumblePluginConfig p, MumblePluginState p) -> m ()
  getPluginInitalState :: MonadMumble m =>
    MumblePluginConfig p -> m (MumblePluginState p)
  getPluginExport :: MonadIO m =>
    MumblePluginInstance p -> m (MumblePluginExport p)


data MumblePluginInstance p = MumblePluginInstance
  { _pluginInstanceConfig :: MumblePluginConfig p
  , _pluginInstanceState  :: MumblePluginState p
  , _pluginAsync          :: Async ()
  }

makePrisms ''MumblePluginInstance
makeClassy ''MumblePluginInstance
