{-# LANGUAGE RankNTypes #-}


module Data.Mumble.Helpers where

import           Control.Concurrent.STM
import           Control.Concurrent.STM.TBMQueue
import           Control.Lens.Getter
import           Control.Lens.Setter
import           Control.Monad.Trans.Resource
import           Crypto.Hash
import qualified Data.ByteString.Lazy            as BL
import           Data.Conduit.TMChan
import qualified Data.Set                        as Set


getDigest :: HashAlgorithm a =>
  Getter s (Maybe BL.ByteString) -> s -> Maybe (Digest a)
getDigest l s = BL.toStrict <$> s ^. l >>= digestFromByteString


maybeE :: String -> (a -> b) -> Maybe a -> Either String b
maybeE err f = maybe (Left err) Right . fmap f

mapEL :: (a -> c) -> Either a b -> Either c b
mapEL f (Left l)   = Left (f l)
mapEL  _ (Right r) = Right r

maybeToRight :: l -> Maybe r -> Either l r
maybeToRight _ (Just a) = Right a
maybeToRight e _        = Left e


setMaybe :: Setter' a b -> Maybe b -> a -> a
setMaybe l = maybe id (\n -> l .~ n)

seqset :: (Ord a, Foldable t) => t a -> Set.Set a
seqset = foldl (flip Set.insert) mempty


allocateTMChanDup :: MonadResource m => TMChan a -> m (TMChan a)
allocateTMChanDup a =
  snd <$> allocate (atomically . dupTMChan $ a) (atomically . closeTMChan)

allocateBroadcastTMChan :: MonadResource m => m (TMChan a)
allocateBroadcastTMChan =
  snd <$> allocate newBroadcastTMChanIO (atomically . closeTMChan)

allocateTBMQueue :: MonadResource m => Int -> m (TBMQueue a)
allocateTBMQueue i = snd <$> allocate (newTBMQueueIO i) (atomically . closeTBMQueue)
