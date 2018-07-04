{-# LANGUAGE BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.PermissionDenied.DenyType (DenyType(..)) where
import Prelude ((+), (/), (.))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'

data DenyType = Text
              | Permission
              | SuperUser
              | ChannelName
              | TextTooLong
              | H9K
              | TemporaryChannel
              | MissingCertificate
              | UserName
              | ChannelFull
              | NestingLimit
              | ChannelCountLimit
                deriving (Prelude'.Read, Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data,
                          Prelude'.Generic)

instance P'.Mergeable DenyType

instance Prelude'.Bounded DenyType where
  minBound = Text
  maxBound = ChannelCountLimit

instance P'.Default DenyType where
  defaultValue = Text

toMaybe'Enum :: Prelude'.Int -> P'.Maybe DenyType
toMaybe'Enum 0 = Prelude'.Just Text
toMaybe'Enum 1 = Prelude'.Just Permission
toMaybe'Enum 2 = Prelude'.Just SuperUser
toMaybe'Enum 3 = Prelude'.Just ChannelName
toMaybe'Enum 4 = Prelude'.Just TextTooLong
toMaybe'Enum 5 = Prelude'.Just H9K
toMaybe'Enum 6 = Prelude'.Just TemporaryChannel
toMaybe'Enum 7 = Prelude'.Just MissingCertificate
toMaybe'Enum 8 = Prelude'.Just UserName
toMaybe'Enum 9 = Prelude'.Just ChannelFull
toMaybe'Enum 10 = Prelude'.Just NestingLimit
toMaybe'Enum 11 = Prelude'.Just ChannelCountLimit
toMaybe'Enum _ = Prelude'.Nothing

instance Prelude'.Enum DenyType where
  fromEnum Text = 0
  fromEnum Permission = 1
  fromEnum SuperUser = 2
  fromEnum ChannelName = 3
  fromEnum TextTooLong = 4
  fromEnum H9K = 5
  fromEnum TemporaryChannel = 6
  fromEnum MissingCertificate = 7
  fromEnum UserName = 8
  fromEnum ChannelFull = 9
  fromEnum NestingLimit = 10
  fromEnum ChannelCountLimit = 11
  toEnum
   = P'.fromMaybe (Prelude'.error "hprotoc generated code: toEnum failure for type Data.MumbleProto.PermissionDenied.DenyType") .
      toMaybe'Enum
  succ Text = Permission
  succ Permission = SuperUser
  succ SuperUser = ChannelName
  succ ChannelName = TextTooLong
  succ TextTooLong = H9K
  succ H9K = TemporaryChannel
  succ TemporaryChannel = MissingCertificate
  succ MissingCertificate = UserName
  succ UserName = ChannelFull
  succ ChannelFull = NestingLimit
  succ NestingLimit = ChannelCountLimit
  succ _ = Prelude'.error "hprotoc generated code: succ failure for type Data.MumbleProto.PermissionDenied.DenyType"
  pred Permission = Text
  pred SuperUser = Permission
  pred ChannelName = SuperUser
  pred TextTooLong = ChannelName
  pred H9K = TextTooLong
  pred TemporaryChannel = H9K
  pred MissingCertificate = TemporaryChannel
  pred UserName = MissingCertificate
  pred ChannelFull = UserName
  pred NestingLimit = ChannelFull
  pred ChannelCountLimit = NestingLimit
  pred _ = Prelude'.error "hprotoc generated code: pred failure for type Data.MumbleProto.PermissionDenied.DenyType"

instance P'.Wire DenyType where
  wireSize ft' enum = P'.wireSize ft' (Prelude'.fromEnum enum)
  wirePut ft' enum = P'.wirePut ft' (Prelude'.fromEnum enum)
  wireGet 14 = P'.wireGetEnum toMaybe'Enum
  wireGet ft' = P'.wireGetErr ft'
  wireGetPacked 14 = P'.wireGetPackedEnum toMaybe'Enum
  wireGetPacked ft' = P'.wireGetErr ft'

instance P'.GPB DenyType

instance P'.MessageAPI msg' (msg' -> DenyType) DenyType where
  getVal m' f' = f' m'

instance P'.ReflectEnum DenyType where
  reflectEnum
   = [(0, "Text", Text), (1, "Permission", Permission), (2, "SuperUser", SuperUser), (3, "ChannelName", ChannelName),
      (4, "TextTooLong", TextTooLong), (5, "H9K", H9K), (6, "TemporaryChannel", TemporaryChannel),
      (7, "MissingCertificate", MissingCertificate), (8, "UserName", UserName), (9, "ChannelFull", ChannelFull),
      (10, "NestingLimit", NestingLimit), (11, "ChannelCountLimit", ChannelCountLimit)]
  reflectEnumInfo _
   = P'.EnumInfo
      (P'.makePNF (P'.pack ".MumbleProto.PermissionDenied.DenyType") ["Data"] ["MumbleProto", "PermissionDenied"] "DenyType")
      ["Data", "MumbleProto", "PermissionDenied", "DenyType.hs"]
      [(0, "Text"), (1, "Permission"), (2, "SuperUser"), (3, "ChannelName"), (4, "TextTooLong"), (5, "H9K"),
       (6, "TemporaryChannel"), (7, "MissingCertificate"), (8, "UserName"), (9, "ChannelFull"), (10, "NestingLimit"),
       (11, "ChannelCountLimit")]

instance P'.TextType DenyType where
  tellT = P'.tellShow
  getT = P'.getRead