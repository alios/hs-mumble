{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE KindSignatures             #-}
{-# LANGUAGE StandaloneDeriving         #-}
{-# LANGUAGE TypeFamilies               #-}

module Data.Mumble.PacketVoice where

import           Control.Lens.Lens
import           Control.Lens.Operators
import           Data.Binary
import           Data.Binary.Put        as Put
import           Data.Bits
import           Data.ByteString
import           Data.Mumble.Types
import           Data.Time.Clock
import           Data.Typeable          (Typeable)
import           Data.Word

{-
Encoded  	         Decoded
0xxxxxxx           	 7-bit positive number
10xxxxxx + 1 byte 	 14-bit positive number
110xxxxx + 2 bytes 	 21-bit positive number
1110xxxx + 3 bytes 	 28-bit positive number
111100__ + int (32-bit)  32-bit positive number
111101__ + long (64-bit) 64-bit number
111110__ + varint 	 Negative recursive varint
111111xx 	         Byte-inverted negative two bit number (~xx)
-}


newtype VarInt = VarInt Integer
  deriving (Eq, Ord, Show, Typeable, Num)


putVarInt :: VarInt -> Put
putVarInt (VarInt i)
  | i >= 0 && i < 0x80 = putWord8 . fromInteger $ i
  | i >= 0 && i < 0x4000 =
      putWord16be $ 0x8000 .|. fromInteger i
  | i >= 0 && i < 0x200000 =
      let iw :: Word32
          iw = fromInteger i
          msb = fromInteger . toInteger $ shiftR iw 16 .&. 0x3f
          bs = fromInteger . toInteger $ iw .&. 0xffff
      in do
        putWord8 (0xc0 .|. msb)
        putWord16be bs
  | i >= 0 && i < 0x10000000 = undefined -- 28bit
  | i >= 0 && i < 0x100000000 = undefined -- 32bit
  | i >= 0 = undefined -- 64bit
  | i < 0 = do
      putWord8 0xf8
      putVarInt (VarInt $ abs i)


type family AudioPayload (t :: PacketVoiceType) :: *

type PositionInfo = (Float, Float, Float)
type SequenceNumber = VarInt

data PacketVoiceType
  = CeltAlpha
  | Ping
  | Speex
  | CeltBeta
  | Opus
  deriving (Eq, Show, Typeable)

type instance AudioPayload 'CeltAlpha = SpeexCeltFrame
type instance AudioPayload 'CeltBeta = SpeexCeltFrame
type instance AudioPayload 'Speex = SpeexCeltFrame
type instance AudioPayload 'Opus = OpusFrame

data AudioPacket (t :: PacketVoiceType) where
  AudioDataPacketIn ::
    SequenceNumber -> SessionId -> AudioPayload t -> Maybe PositionInfo ->
    AudioPacket t
  AudioDataPacketOut ::
    SequenceNumber -> AudioPayload t -> Maybe PositionInfo ->
    AudioPacket t
  deriving (Typeable)


audioPacketSequenceNumber :: Lens' (AudioPacket t) SequenceNumber
audioPacketSequenceNumber = lens g s
  where
    g (AudioDataPacketIn i _ _ _) = i
    g (AudioDataPacketOut i _ _)  = i
    s (AudioDataPacketIn _ si bs p) i = AudioDataPacketIn i si bs p
    s (AudioDataPacketOut _ bs p) i   = AudioDataPacketOut i bs p

deriving instance (Eq (AudioPacket 'Speex))
deriving instance (Eq (AudioPacket 'CeltAlpha))
deriving instance (Eq (AudioPacket 'CeltBeta))
deriving instance (Eq (AudioPacket 'Opus))

instance Ord (AudioPacket 'Speex) where
  compare = compareAudioPacket

instance Ord (AudioPacket 'CeltAlpha) where
  compare = compareAudioPacket

instance Ord (AudioPacket 'CeltBeta) where
  compare = compareAudioPacket

instance Ord (AudioPacket 'Opus) where
  compare = compareAudioPacket

compareAudioPacket :: AudioPacket a -> AudioPacket a -> Ordering
compareAudioPacket AudioDataPacketIn{} AudioDataPacketOut{} = LT
compareAudioPacket AudioDataPacketOut{} AudioDataPacketIn{} = GT
compareAudioPacket a b = compare
    (a ^. audioPacketSequenceNumber) (b ^. audioPacketSequenceNumber)


data PacketVoiceTarget
  = NormalTalking
  | WhisperTarget Word8
  | ServerLoopBack
  deriving (Eq, Show, Typeable)

data PacketVoice (t :: PacketVoiceType) where
  PacketVoicePing :: NominalDiffTime -> PacketVoice 'Ping
  PacketVoiceCeltAlpha ::
    PacketVoiceTarget -> AudioPacket 'CeltAlpha -> PacketVoice 'CeltAlpha
  PacketVoiceCeltBeta  :: PacketVoiceTarget -> PacketVoice 'CeltBeta
  PacketVoiceSpeex  :: PacketVoiceTarget -> PacketVoice 'Speex
  PacketVoiceOpus :: PacketVoiceTarget -> PacketVoice 'Opus
  deriving (Typeable)


deriving instance Eq (PacketVoice t)


data SpeexCeltFrame
  = SpeexCeltFrame !ByteString
  | SpeexCeltLastFrame !ByteString
  | SpeexCeltEOT
  deriving (Eq, Show, Typeable)

data OpusFrame
  = OpusFrame !ByteString
  | OpusEOT
  deriving (Eq, Show, Typeable)


newtype APacketVoice =
  APacketVoice (PacketVoiceType, PacketVoiceTarget, ByteString)
  deriving (Eq, Show)
