{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE DeriveGeneric   #-}
{-# LANGUAGE TemplateHaskell #-}

module Data.Mumble.Types
  ( ChannelId, HasChannelId(..), _ChannelId
  , SessionId, _SessionId, HasSessionId(..)
  , UserId, _UserId, HasUserId(..)
  , ActorId
  ) where

import           Control.Lens.TH
import           Data.Typeable   (Typeable)
import           Data.Word
import           GHC.Generics    (Generic)

newtype ChannelId = ChannelId Word32
  deriving (Typeable, Generic, Eq, Ord, Show)

makePrisms ''ChannelId
makeClassy ''ChannelId

newtype SessionId = SessionId Word32
  deriving (Typeable, Generic, Eq, Ord, Show)

makePrisms ''SessionId
makeClassy ''SessionId


newtype UserId = UserId Word32
  deriving (Typeable, Generic, Eq, Ord, Show)

makePrisms ''UserId
makeClassy ''UserId

type ActorId = SessionId
