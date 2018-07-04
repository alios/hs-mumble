{-# LANGUAGE DeriveGeneric   #-}
{-# LANGUAGE GADTs           #-}
{-# LANGUAGE RankNTypes      #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies    #-}

module Data.Mumble.Packet
  ( MumblePacket(..), PacketType, PacketTypeProxy(..), packetType, proxyPacketType
  , APacket (..), _APacket, aPacketC, packetTypeAny
  , RawPacket, rawFromPacket, packetFromRawE, _RawPacket
  , raw2apacket
  , rawPacketDecoderC
  , VersionField(..), _VersionField
  ) where

import           Conduit
import           Control.Lens.Fold
import           Control.Lens.Getter
import           Control.Lens.Iso
import           Control.Lens.Prism
import           Control.Lens.Review
import           Control.Lens.TH
import           Data.Binary                          as Bin
import qualified Data.Binary.Get                      as Get
import qualified Data.Binary.Put                      as Put
import           Data.Bits
import           Data.ByteString                      (ByteString)
import qualified Data.ByteString.Lazy                 as BL
import           Data.Maybe
import           Data.MumbleProto.ACL
import           Data.MumbleProto.Authenticate
import           Data.MumbleProto.BanList
import           Data.MumbleProto.ChannelRemove
import           Data.MumbleProto.ChannelState
import           Data.MumbleProto.CodecVersion
import           Data.MumbleProto.ContextAction
import           Data.MumbleProto.ContextActionModify
import           Data.MumbleProto.CryptSetup
import           Data.MumbleProto.PermissionDenied
import           Data.MumbleProto.PermissionQuery
import           Data.MumbleProto.Ping
import           Data.MumbleProto.QueryUsers
import           Data.MumbleProto.Reject              as Reject
import           Data.MumbleProto.RequestBlob
import           Data.MumbleProto.ServerConfig
import           Data.MumbleProto.ServerSync
import           Data.MumbleProto.SuggestConfig
import           Data.MumbleProto.TextMessage
import           Data.MumbleProto.UDPTunnel
import           Data.MumbleProto.UserList
import           Data.MumbleProto.UserRemove
import           Data.MumbleProto.UserState
import           Data.MumbleProto.UserStats
import           Data.MumbleProto.Version
import           Data.MumbleProto.VoiceTarget
import           Data.Proxy
import           Data.Typeable                        (Typeable, cast)
import           GHC.Enum
import           GHC.Generics                         (Generic)
import           Text.ProtocolBuffers.Reflections
import           Text.ProtocolBuffers.WireMessage

class (Wire a, ReflectDescriptor a, Typeable a, Show a) => MumblePacket a where
  data PacketTypeProxy a :: *
  packetTypeProxy :: Proxy a -> PacketType


newtype PacketType = PacketType Word16
  deriving (Typeable, Generic, Eq, Ord, Show)

data APacket where
  APacket :: MumblePacket a => PacketTypeProxy a -> a -> APacket

instance Show APacket where
  show (APacket _ p) = show p


packetTypeToProxy :: MumblePacket a => PacketTypeProxy a -> Proxy a
packetTypeToProxy = const Proxy

proxyPacketType :: MumblePacket a => PacketTypeProxy a -> PacketType
proxyPacketType = packetTypeProxy . packetTypeToProxy

packetTypeAny :: Getter APacket PacketType
packetTypeAny = to $ \(APacket p _) -> proxyPacketType p

packetType :: MumblePacket a => Getter a PacketType
packetType = to $ \a -> packetTypeProxy (packetToProxy a)
  where
    packetToProxy :: a -> Proxy a
    packetToProxy = const Proxy


_PacketType :: (Num a, Integral a) => Prism' a PacketType
_PacketType = prism' f t
  where f (PacketType i) = fromInteger . toInteger $ i
        t i =
          let i' = PacketType . fromInteger . toInteger $ i
          in if i' >= minBound && i' <= maxBound then pure i' else Nothing

instance Enum PacketType where
  toEnum i = fromMaybe
    (toEnumError "PacketType" i (minBound :: PacketType, maxBound)) .
    preview _PacketType $ i
  fromEnum = review _PacketType


instance Bounded PacketType where
  minBound = PacketType 0
  maxBound = PacketType 25

instance Binary PacketType where
  get = do
    i <- Get.getWord16be
    maybe (fail $ mconcat [ "invalid PacketType: ", show i]) pure $
      preview _PacketType i
  put (PacketType i) = put i



instance MumblePacket Version where
  data PacketTypeProxy Version = PacketVersion
  packetTypeProxy = const (PacketType 0)

instance MumblePacket UDPTunnel where
  data PacketTypeProxy UDPTunnel = PacketUDPTunnel
  packetTypeProxy = const (PacketType 1)

instance MumblePacket Authenticate where
  data PacketTypeProxy Authenticate = PacketAuthenticate
  packetTypeProxy = const (PacketType 2)

instance MumblePacket Ping where
  data PacketTypeProxy Ping = PacketPing
  packetTypeProxy = const (PacketType 3)

instance MumblePacket Reject where
  data PacketTypeProxy Reject = PacketReject
  packetTypeProxy = const (PacketType 4)

instance MumblePacket ServerSync where
  data PacketTypeProxy ServerSync = PacketServerSync
  packetTypeProxy = const (PacketType 5)

instance MumblePacket ChannelRemove where
  data PacketTypeProxy ChannelRemove = PacketChannelRemove
  packetTypeProxy = const (PacketType 6)

instance MumblePacket ChannelState where
  data PacketTypeProxy ChannelState = PacketChannelState
  packetTypeProxy = const (PacketType 7)

instance MumblePacket UserRemove where
  data PacketTypeProxy UserRemove = PacketUserRemove
  packetTypeProxy = const (PacketType 8)

instance MumblePacket UserState where
  data PacketTypeProxy UserState = PacketUserState
  packetTypeProxy = const (PacketType 9)

instance MumblePacket BanList where
  data PacketTypeProxy BanList = PacketBanList
  packetTypeProxy = const (PacketType 10)

instance MumblePacket TextMessage where
  data PacketTypeProxy TextMessage = PacketTextMessage
  packetTypeProxy = const (PacketType 11)

instance MumblePacket PermissionDenied where
  data PacketTypeProxy PermissionDenied = PacketPermissionDenied
  packetTypeProxy = const (PacketType 12)

instance MumblePacket ACL where
  data PacketTypeProxy ACL = PacketACL
  packetTypeProxy = const (PacketType 13)

instance MumblePacket QueryUsers where
  data PacketTypeProxy QueryUsers = PacketQueryUsers
  packetTypeProxy = const (PacketType 14)

instance MumblePacket CryptSetup where
  data PacketTypeProxy CryptSetup = PacketCryptSetup
  packetTypeProxy = const (PacketType 15)

instance MumblePacket ContextActionModify where
  data PacketTypeProxy ContextActionModify = PacketContextActionModify
  packetTypeProxy = const (PacketType 16)

instance MumblePacket ContextAction where
  data PacketTypeProxy ContextAction = PacketContextAction
  packetTypeProxy = const (PacketType 17)

instance MumblePacket UserList where
  data PacketTypeProxy UserList = PacketUserList
  packetTypeProxy = const (PacketType 18)

instance MumblePacket VoiceTarget where
  data PacketTypeProxy VoiceTarget = PacketVoiceTarget
  packetTypeProxy = const (PacketType 19)

instance MumblePacket PermissionQuery where
  data PacketTypeProxy PermissionQuery = PacketPermissionQuery
  packetTypeProxy = const (PacketType 20)

instance MumblePacket CodecVersion where
  data PacketTypeProxy CodecVersion = PacketCodecVersion
  packetTypeProxy = const (PacketType 21)

instance MumblePacket UserStats where
  data PacketTypeProxy UserStats = PacketUserStats
  packetTypeProxy = const (PacketType 22)

instance MumblePacket RequestBlob where
  data PacketTypeProxy RequestBlob = PacketRequestBlob
  packetTypeProxy = const (PacketType 23)

instance MumblePacket ServerConfig where
  data PacketTypeProxy ServerConfig = PacketServerConfig
  packetTypeProxy = const (PacketType 24)

instance MumblePacket SuggestConfig where
  data PacketTypeProxy SuggestConfig = PacketSuggestConfig
  packetTypeProxy = const (PacketType 25)

newtype RawPacket =
  RawPacket (PacketType, BL.ByteString)
  deriving (Typeable, Generic, Eq, Show)

makePrisms ''RawPacket




rawFromPacket :: MumblePacket a => a -> RawPacket
rawFromPacket a = RawPacket (a ^. packetType, messagePut a)


packetFromRawE :: MumblePacket a =>
  PacketTypeProxy a -> RawPacket -> Either String a
packetFromRawE = const packetFromRawE'

packetFromRawE' :: MumblePacket a => RawPacket -> Either String a
packetFromRawE' (RawPacket (t, bs))  =
  case messageGet bs of
    Left err -> Left err
    Right (a, _) ->
      let t' = a ^. packetType
      in if t /= t'
         then Left . mconcat $
              ["expected packet type ", show t, ", got: " , show t']
         else Right a

instance Binary RawPacket where
  put (RawPacket (t, bs)) =
    let l :: Word32
        l = fromInteger . toInteger . BL.length $ bs
    in do
      put t
      Put.putWord32be l
      putLazyByteString bs
  get = do
    t <- get
    l <- Get.getWord32be
    p <- Get.getLazyByteString . fromInteger . toInteger $ l
    return $ RawPacket (t, p)


rawPacketDecoderC :: Monad m => ConduitT ByteString RawPacket m ()
rawPacketDecoderC = decoderC (Get.runGetIncremental get)

decoderC :: Monad m => Get.Decoder o -> ConduitT ByteString o m ()
decoderC d = decoderC' d d

decoderC' :: Monad m => Get.Decoder o -> Get.Decoder o -> ConduitT ByteString o m ()
decoderC' d (Get.Partial f) = awaitForever $ \bs ->
  decoderC' d $ f (pure bs)
decoderC' d (Get.Done bs _ a) = do
  yield a
  leftover bs
  decoderC' d d
decoderC' _ (Get.Fail _ o err) = fail . mconcat $
  [ "decoder failed at ", show o, ": ", err ]


_APacket :: MumblePacket a => PacketTypeProxy a -> Prism' APacket a
_APacket a = prism' f t
  where f = APacket a
        t (APacket _ p) = cast p

aPacketC :: Monad m => ConduitT RawPacket APacket m ()
aPacketC = awaitForever $ \rp ->
  case raw2apacket rp of
    Left err -> fail err
    Right a  -> yield a


raw2apacket :: RawPacket -> Either String APacket
raw2apacket rp@(RawPacket (pt, _)) =
  let ap :: MumblePacket a => PacketTypeProxy a -> Either String APacket
      ap = typedApacket rp
  in case pt of
    (PacketType 0) -> ap PacketVersion
    (PacketType 1) -> ap PacketUDPTunnel
    (PacketType 2) -> ap PacketAuthenticate
    (PacketType 3) -> ap PacketPing
    (PacketType 4) -> ap PacketReject
    (PacketType 5) -> ap PacketServerSync
    (PacketType 6) -> ap PacketChannelRemove
    (PacketType 7) -> ap PacketChannelState
    (PacketType 8) -> ap PacketUserRemove
    (PacketType 9) -> ap PacketUserState
    (PacketType 10) -> ap PacketBanList
    (PacketType 11) -> ap PacketTextMessage
    (PacketType 12) -> ap PacketPermissionDenied
    (PacketType 13) -> ap PacketACL
    (PacketType 14) -> ap PacketQueryUsers
    (PacketType 15) -> ap PacketCryptSetup
    (PacketType 16) -> ap PacketContextActionModify
    (PacketType 17) -> ap PacketContextAction
    (PacketType 18) -> ap PacketUserList
    (PacketType 19) -> ap PacketVoiceTarget
    (PacketType 20) -> ap PacketPermissionQuery
    (PacketType 21) -> ap PacketCodecVersion
    (PacketType 22) -> ap PacketUserStats
    (PacketType 23) -> ap PacketRequestBlob
    (PacketType 24) -> ap PacketServerConfig
    (PacketType 25) -> ap PacketSuggestConfig
    _pt              ->
      Left $ "raw2apacket: missing impementation for " ++ show _pt


typedApacket :: MumblePacket a =>
  RawPacket -> PacketTypeProxy a -> Either String APacket
typedApacket rp a = review (_APacket a) <$> packetFromRawE a rp


newtype VersionField = VersionField (Word16, Word8, Word8)
  deriving (Typeable, Generic, Eq, Show)

_VersionField :: Iso' Word32 VersionField
_VersionField = iso t f
  where
    ft :: (Num a, Integral b) => b -> a
    ft = fromInteger . toInteger
    f (VersionField (a', b', c')) =
       let a,b,c :: Word32
           a = ft a' `shift` 16
           b = ft b' `shift` 8
           c = ft c'
       in a .|. b .|. c
    t i =
      let a = (i `shift` (-16)) .&. 0xffff
          b = (i `shift` (-8)) .&. 0xff
          c = i .&. 0xff
      in VersionField (ft a, ft b , ft c)
