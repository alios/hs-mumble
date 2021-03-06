{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes        #-}
{-# LANGUAGE TemplateHaskell   #-}

module Data.Mumble.UserState
  ( UserDB
  , SessionId, _SessionId, HasSessionId(..)
  , UserId, _UserId, HasUserId(..)
  , UserRecord, HasUserRecord(..)
  , updateUserDB, updateUserDBMany, deleteUser
  )where

import           Control.Lens.At
import           Control.Lens.Getter
import           Control.Lens.Operators
import           Control.Lens.TH
import           Crypto.Hash
import           Data.ByteString            (ByteString)
import qualified Data.ByteString.Lazy       as BL
import           Data.Map                   (Map)
import qualified Data.Map                   as Map
import           Data.Mumble.ChannelState
import           Data.Mumble.Helpers
import           Data.Mumble.Types
import           Data.MumbleProto.UserState
import           Data.Text                  (Text)
import qualified Data.Text                  as T
import           Data.Typeable              (Typeable)
import           GHC.Generics               (Generic)
import qualified Text.ProtocolBuffers.Basic as PB

data UserRecord = UserRecord
  { _uSessionId      :: ! SessionId
  , _uUserId         :: ! (Maybe UserId)
  , _uChannelId      :: ! ChannelId
  , _uName           :: ! Text
  , _uMute           :: ! Bool
  , _uDeaf           :: ! Bool
  , _uSelfMute       :: ! Bool
  , _uSelfDeaf       :: ! Bool
  , _uPrioSpeaker    :: ! Bool
  , _uRecording      :: ! Bool
  , _uTexture        :: ! ByteString
  , _uTextureHash    :: ! (Maybe (Digest SHA1))
  , _uComment        :: ! Text
  , _uCommentHash    :: ! (Maybe (Digest SHA1))
  , _uPluginIdentity :: ! Text
  , _uPluginContext  :: ! ByteString
  , _uHash           :: ! Text
  }  deriving (Typeable, Generic, Eq, Show)

makeClassy ''UserRecord

instance HasChannelId UserRecord where
  channelId = uChannelId

instance HasSessionId UserRecord where
  sessionId = uSessionId

emptyUserRecord :: SessionId -> ChannelId -> UserRecord
emptyUserRecord sid cid = UserRecord sid Nothing cid mempty
  False False False False False False mempty Nothing mempty Nothing mempty mempty mempty


type UserDB = Map SessionId UserRecord

deleteUser :: SessionId -> UserDB ->  UserDB
deleteUser = Map.delete



updateRecord :: HasUserRecord r => UserState -> r -> r
updateRecord s r = r
  & setMaybe uSessionId ((_SessionId #) <$> s ^. session)
  & uUserId .~ ((_UserId #) <$> s ^. user_id)
  & setMaybe uChannelId ((_ChannelId #) <$> s ^. session)
  & setMaybe uName (T.pack . PB.uToString <$> s ^. name)
  & setMaybe uMute (s ^. mute)
  & setMaybe uSelfMute (s ^. self_mute)
  & setMaybe uDeaf (s ^. deaf)
  & setMaybe uSelfDeaf (s ^. self_deaf)
  & setMaybe uPrioSpeaker (s ^. priority_speaker)
  & setMaybe uRecording (s ^. recording)
  & setMaybe uTexture (BL.toStrict <$> s ^. texture)
  & uTextureHash .~ getDigest texture_hash s
  & setMaybe uComment (T.pack . PB.uToString <$> s ^. comment)
  & uCommentHash .~ getDigest comment_hash s
  & setMaybe uPluginIdentity (T.pack . PB.uToString <$> s ^. plugin_identity)
  & setMaybe uPluginContext (BL.toStrict <$> s ^. plugin_context)


validRecordDB :: ChannelDB -> UserRecord -> Maybe String
validRecordDB db ur =
  let cid = ur ^. channelId
  in case db ^. at cid of
       Nothing ->
         if (cid ^. _ChannelId)  /= (ur ^. sessionId . _SessionId)
         then Just $ mconcat
              [ "unable to lookup ", show cid
              , " for channel of ", show $ ur ^. sessionId
              ]
         else Nothing
       Just _ -> Nothing


updateUserDB :: ChannelDB -> UserDB -> UserState -> Either String UserDB
updateUserDB dbc db s = do
  sid <- maybeE "UserState without session id" (_SessionId #) $ s ^. session
  let opInsert = do
        cid <- maybeE "UserState without channel id" (_ChannelId #) $ s ^. channel_id
        pure $ updateRecord s (emptyUserRecord sid cid)
      opUpdate = pure . updateRecord s
  u' <- maybe opInsert opUpdate $ db ^. at sid
  case validRecordDB dbc u' of
    Nothing  -> Right $ db & at sid .~  pure u'
    Just err -> Left err


updateUserDBMany :: ChannelDB -> UserDB -> [UserState] ->
  Either String UserDB
updateUserDBMany _ db [] = Right db
updateUserDBMany cdb db (a:as) = do
  db' <- updateUserDB cdb db a
  updateUserDBMany cdb db' as
