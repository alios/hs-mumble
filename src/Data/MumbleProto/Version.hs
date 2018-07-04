{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.Version (Version(..), version, release, os, os_version) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data Version = Version{_version :: !(P'.Maybe P'.Word32), _release :: !(P'.Maybe P'.Utf8), _os :: !(P'.Maybe P'.Utf8),
                       _os_version :: !(P'.Maybe P'.Utf8)}
               deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''Version

instance P'.Mergeable Version where
  mergeAppend (Version x'1 x'2 x'3 x'4) (Version y'1 y'2 y'3 y'4)
   = Version (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)

instance P'.Default Version where
  defaultValue = Version P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue

instance P'.Wire Version where
  wireSize ft' self'@(Version x'1 x'2 x'3 x'4)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeOpt 1 13 x'1 + P'.wireSizeOpt 1 9 x'2 + P'.wireSizeOpt 1 9 x'3 + P'.wireSizeOpt 1 9 x'4)
  wirePutWithSize ft' self'@(Version x'1 x'2 x'3 x'4)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutOptWithSize 8 13 x'1, P'.wirePutOptWithSize 18 9 x'2, P'.wirePutOptWithSize 26 9 x'3,
             P'.wirePutOptWithSize 34 9 x'4]
        put'FieldsSized
         = let size' = Prelude'.fst (P'.runPutM put'Fields)
               put'Size
                = do
                    P'.putSize size'
                    Prelude'.return (P'.size'WireSize size')
            in P'.sequencePutWithSize [put'Size, put'Fields]
  wireGet ft'
   = case ft' of
       10 -> P'.getBareMessageWith update'Self
       11 -> P'.getMessageWith update'Self
       _ -> P'.wireGetErr ft'
    where
        update'Self wire'Tag old'Self
         = case wire'Tag of
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_version = Prelude'.Just new'Field}) (P'.wireGet 13)
             18 -> Prelude'.fmap (\ !new'Field -> old'Self{_release = Prelude'.Just new'Field}) (P'.wireGet 9)
             26 -> Prelude'.fmap (\ !new'Field -> old'Self{_os = Prelude'.Just new'Field}) (P'.wireGet 9)
             34 -> Prelude'.fmap (\ !new'Field -> old'Self{_os_version = Prelude'.Just new'Field}) (P'.wireGet 9)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> Version) Version where
  getVal m' f' = f' m'

instance P'.GPB Version

instance P'.ReflectDescriptor Version where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [8, 18, 26, 34])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.Version\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"Version\"}, descFilePath = [\"Data\",\"MumbleProto\",\"Version.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Version.version\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Version\"], baseName' = FName \"version\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Version.release\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Version\"], baseName' = FName \"release\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 18}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Version.os\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Version\"], baseName' = FName \"os\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 26}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Version.os_version\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Version\"], baseName' = FName \"os_version\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 34}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType Version where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg Version where
  textPut msg
   = do
       P'.tellT "version" (_version msg)
       P'.tellT "release" (_release msg)
       P'.tellT "os" (_os msg)
       P'.tellT "os_version" (_os_version msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_version, parse'_release, parse'_os, parse'_os_version]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_version
         = P'.try
            (do
               v <- P'.getT "version"
               Prelude'.return (\ o -> o{_version = v}))
        parse'_release
         = P'.try
            (do
               v <- P'.getT "release"
               Prelude'.return (\ o -> o{_release = v}))
        parse'_os
         = P'.try
            (do
               v <- P'.getT "os"
               Prelude'.return (\ o -> o{_os = v}))
        parse'_os_version
         = P'.try
            (do
               v <- P'.getT "os_version"
               Prelude'.return (\ o -> o{_os_version = v}))