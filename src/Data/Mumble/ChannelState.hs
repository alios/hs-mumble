{-# LANGUAGE DeriveGeneric    #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes       #-}
{-# LANGUAGE TemplateHaskell  #-}
{-# LANGUAGE TypeFamilies     #-}

module Data.Mumble.ChannelState
  ( ChannelId, HasChannelId(..), _ChannelId
  , ChannelRecord, HasChannelRecord, _ChannelRecord
  , ChannelDB, updateChannelDB, updateChannelDBMany, deleteChannel
  ) where

import           Control.Lens.At
import           Control.Lens.Operators
import           Control.Lens.TH
import           Crypto.Hash
import           Data.Map.Lazy                 (Map)
import qualified Data.Map.Lazy                 as Map
import           Data.Mumble.Helpers
import           Data.Mumble.Types
import           Data.MumbleProto.ChannelState
import           Data.Sequence                 (Seq)
import           Data.Set                      (Set)
import qualified Data.Set                      as Set
import           Data.Text                     (Text)
import qualified Data.Text                     as T
import           Data.Typeable                 (Typeable)
import           GHC.Generics                  (Generic)
import qualified Text.ProtocolBuffers.Basic    as PB

data ChannelRecord = ChannelRecord
  { _cChannelId       :: !ChannelId
  , _cParent          :: !(Maybe ChannelId)
  , _cName            :: !Text
  , _cLinks           :: !(Set ChannelId)
  , _cDescription     :: !Text
  , _cDescriptionHash :: !(Maybe (Digest SHA1))
  , _cIsTemporary     :: !Bool
  , _cPosition        :: !Int
  , _cMaxUsers        :: !Int
  } deriving (Typeable, Generic, Eq, Show)

makePrisms ''ChannelRecord
makeClassy ''ChannelRecord

deleteChannel :: ChannelId -> ChannelDB ->  ChannelDB
deleteChannel = Map.delete

emptyChannelRecord :: ChannelId -> ChannelRecord
emptyChannelRecord cid =
  ChannelRecord cid Nothing mempty mempty mempty Nothing False 0 0

instance HasChannelId ChannelRecord where
  channelId = cChannelId


updateRecord :: HasChannelRecord r => ChannelState -> r -> r
updateRecord s r = r
  & cParent .~ ((_ChannelId #) <$> s ^. parent)
  & setMaybe cName (T.pack . PB.uToString <$> s ^. name)
  & setMaybe cDescription (T.pack . PB.uToString <$> s ^. description)
  & cDescriptionHash .~ getDigest description_hash s
  & setMaybe cIsTemporary (s ^. temporary)
  & setMaybe cPosition (fromInteger . toInteger <$> s ^. position)
  & setMaybe cMaxUsers (fromInteger . toInteger <$> s ^. max_users)
  & updateLinks s



updateLinks :: HasChannelRecord r => ChannelState -> r -> r
updateLinks s r =
  let me a = if a == mempty then Nothing else Just $ (_ChannelId #) <$> a
  in updateLinks' (me $ s ^. links) (me $ s ^. links_add) (me $ s ^. links_remove) r

updateLinks' :: HasChannelRecord r =>
  Maybe (Seq ChannelId) -> Maybe (Seq ChannelId) ->
  Maybe (Seq ChannelId) -> r -> r
updateLinks' Nothing Nothing Nothing r = r
updateLinks' (Just ls) al rl r      =
  updateLinks' Nothing al rl (r & cLinks .~ seqset ls)
updateLinks' Nothing (Just al) rl r =
  updateLinks'
  Nothing Nothing rl (r & cLinks .~ mappend (seqset al) (r ^. cLinks))
updateLinks' Nothing Nothing (Just rl) r  =
  let nls :: Set ChannelId
      nls = Set.difference (r ^. cLinks) (seqset rl)
  in r & cLinks .~ nls




type ChannelDB = Map ChannelId ChannelRecord

type ChannelDBChildIdx = Map ChannelId (Set ChannelId)
--type ChannelDBLinkedByIdx = Map ChannelId (Set ChannelId)



getChildren :: HasChannelId i => ChannelDB -> i -> Maybe (Set ChannelId)
getChildren db i =
  channelDBParentDB db ^. at (i ^. channelId)

getChildrenDeep :: HasChannelId i => ChannelDB -> i -> Maybe (Set ChannelId)
getChildrenDeep db i = do
  c <- getChildren db i
  cs <- sequence $ getChildrenDeep db <$> Set.toList c
  return $ mappend c (mconcat cs)




validRecordDB :: ChannelDB -> ChannelRecord -> Maybe String
validRecordDB db cr =
  let lu err i =
        maybe (Left $ "unable to lookup " ++ err) Right $
        db ^. at i
      ps =
        maybe mempty pure $ (\i -> lu ("parent " ++ show i) i) <$>
        cr ^. cParent
      ls =
        foldl (\b a -> lu ("linked channel " ++ show a) a : b) [] $
        cr ^. cLinks
      inCs k = case Set.member k <$> getChildrenDeep db cr of
        Just True  -> Left "channels parent must not be in its subtree"
        Just False -> Right (emptyChannelRecord k)
        Nothing    -> Right (emptyChannelRecord k)
      vp = maybe [] (pure . inCs) $ cr ^. cParent
      pnoti pid = if pid /= cr ^. channelId then Right (emptyChannelRecord pid)
                      else Left "channelDB: channel must not be its own parent"
      ns = maybe [] (pure . pnoti) $ cr ^. cParent
  in either Just (const Nothing) $ sequence (mconcat [ps, ls, ns, vp])


channelDBParentDB :: ChannelDB -> ChannelDBChildIdx
channelDBParentDB = Map.foldlWithKey _update mempty
  where _update pdb _ cr =
          case cr ^. cParent of
            Nothing -> pdb
            Just pid ->
              let crs = Set.singleton $ cr ^. channelId
              in case pdb ^. at pid of
                   Just cs -> pdb & at pid .~ pure (mappend cs crs )
                   Nothing -> pdb & at pid .~ pure crs


updateChannelDB :: ChannelDB -> ChannelState -> Either String ChannelDB
updateChannelDB db s =
  case (_ChannelId #) <$> s ^. channel_id of
    Nothing -> Right db
    Just cid ->
      let c' = case db ^. at cid of
                 Nothing -> updateRecord s (emptyChannelRecord cid)
                 Just c  -> updateRecord s c
      in case validRecordDB db c' of
           Nothing  -> Right $ db & at cid .~  pure c'
           Just err -> Left err

updateChannelDBMany :: ChannelDB -> [ChannelState] ->
  Either String (Map ChannelId ChannelRecord)
updateChannelDBMany db [] = Right db
updateChannelDBMany db (a:as) = do
  db' <- updateChannelDB db a
  updateChannelDBMany db' as
