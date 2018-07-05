{-# LANGUAGE DeriveGeneric #-}

module Data.Mumble.TextMessages where

import           Control.Lens.Fold
import           Control.Lens.Lens
import           Control.Lens.Operators
import           Data.Mumble.Types
import           Data.MumbleProto.TextMessage
import           Data.Text                    (Text)
import qualified Data.Text                    as T
import           Data.Time.Clock
import           Data.Typeable                (Typeable)
import           GHC.Generics                 (Generic)
import qualified Text.ProtocolBuffers.Basic   as PB

data MumbleTextMessage
  = TreeMessage UTCTime (Maybe ActorId) ChannelId Text
  | ChannelMessage UTCTime (Maybe ActorId) ChannelId Text
  | PrivateMessage UTCTime (Maybe ActorId) SessionId Text
  deriving (Typeable, Generic, Show, Eq)

mumbleTextMessageTS :: Lens' MumbleTextMessage UTCTime
mumbleTextMessageTS = lens g s
  where g (TreeMessage t _ _ _)    = t
        g (ChannelMessage t _ _ _) = t
        g (PrivateMessage t _ _ _) = t
        s (TreeMessage _ a i f) t    = TreeMessage t a i f
        s (ChannelMessage _ a i f) t = ChannelMessage t a i f
        s (PrivateMessage _ a i f) t = PrivateMessage t a i f

mumbleTextMessageActor :: Lens' MumbleTextMessage (Maybe ActorId)
mumbleTextMessageActor = lens g s
  where g (TreeMessage _ a _ _)    = a
        g (ChannelMessage _ a _ _) = a
        g (PrivateMessage _ a _ _) = a
        s (TreeMessage t _ i f) a    = TreeMessage t a i f
        s (ChannelMessage t _ i f) a = ChannelMessage t a i f
        s (PrivateMessage t _ i f) a = PrivateMessage t a i f

mumbleTextMessage :: Lens' MumbleTextMessage Text
mumbleTextMessage = lens g s
  where g (TreeMessage _ _ _ f)    = f
        g (ChannelMessage _ _ _ f) = f
        g (PrivateMessage _ _ _ f) = f
        s (TreeMessage t a i _) f    = TreeMessage t a i f
        s (ChannelMessage t a i _) f = ChannelMessage t a i f
        s (PrivateMessage t a i _) f = PrivateMessage t a i f



toMumbleTextMessage :: UTCTime -> TextMessage -> Either String MumbleTextMessage
toMumbleTextMessage t m =
  let a = (_SessionId #) <$> m ^. actor
      tr = (_ChannelId #) <$> firstOf traverse (m ^. tree_id)
      c = (_ChannelId #) <$> firstOf traverse (m ^. channel_id)
      s = (_SessionId #) <$> firstOf traverse (m ^. session)
      msg = T.pack . PB.uToString $ m ^. message
  in case (tr,c,s) of
       (Just tr', _, _) -> Right $ TreeMessage t a tr' msg
       (_, Just c',_)   -> Right $ ChannelMessage t a c' msg
       (_, _, Just s')  -> Right $ PrivateMessage t a s' msg
       _ -> Left "found neither tree, channel or session in message"


fromMumbleTextMessage :: MumbleTextMessage -> TextMessage
fromMumbleTextMessage (TreeMessage _ a i f) =
  TextMessage ((^. _SessionId) <$> a) mempty mempty (pure (i ^. _ChannelId)) (PB.uFromString . T.unpack $ f)
fromMumbleTextMessage (ChannelMessage _ a i f) =
  TextMessage ((^. _SessionId) <$> a) mempty (pure (i ^. _ChannelId)) mempty (PB.uFromString . T.unpack $ f)
fromMumbleTextMessage (PrivateMessage _ a i f) =
  TextMessage ((^. _SessionId) <$> a) (pure (i ^. _SessionId)) mempty mempty (PB.uFromString . T.unpack $ f)
