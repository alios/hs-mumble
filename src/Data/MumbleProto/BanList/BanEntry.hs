{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.BanList.BanEntry (BanEntry(..), address, mask, name, hash, reason, start, duration) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data BanEntry = BanEntry{_address :: !(P'.ByteString), _mask :: !(P'.Word32), _name :: !(P'.Maybe P'.Utf8),
                         _hash :: !(P'.Maybe P'.Utf8), _reason :: !(P'.Maybe P'.Utf8), _start :: !(P'.Maybe P'.Utf8),
                         _duration :: !(P'.Maybe P'.Word32)}
                deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''BanEntry

instance P'.Mergeable BanEntry where
  mergeAppend (BanEntry x'1 x'2 x'3 x'4 x'5 x'6 x'7) (BanEntry y'1 y'2 y'3 y'4 y'5 y'6 y'7)
   = BanEntry (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)
      (P'.mergeAppend x'5 y'5)
      (P'.mergeAppend x'6 y'6)
      (P'.mergeAppend x'7 y'7)

instance P'.Default BanEntry where
  defaultValue
   = BanEntry P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue

instance P'.Wire BanEntry where
  wireSize ft' self'@(BanEntry x'1 x'2 x'3 x'4 x'5 x'6 x'7)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size
         = (P'.wireSizeReq 1 12 x'1 + P'.wireSizeReq 1 13 x'2 + P'.wireSizeOpt 1 9 x'3 + P'.wireSizeOpt 1 9 x'4 +
             P'.wireSizeOpt 1 9 x'5
             + P'.wireSizeOpt 1 9 x'6
             + P'.wireSizeOpt 1 13 x'7)
  wirePutWithSize ft' self'@(BanEntry x'1 x'2 x'3 x'4 x'5 x'6 x'7)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutReqWithSize 10 12 x'1, P'.wirePutReqWithSize 16 13 x'2, P'.wirePutOptWithSize 26 9 x'3,
             P'.wirePutOptWithSize 34 9 x'4, P'.wirePutOptWithSize 42 9 x'5, P'.wirePutOptWithSize 50 9 x'6,
             P'.wirePutOptWithSize 56 13 x'7]
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
             10 -> Prelude'.fmap (\ !new'Field -> old'Self{_address = new'Field}) (P'.wireGet 12)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_mask = new'Field}) (P'.wireGet 13)
             26 -> Prelude'.fmap (\ !new'Field -> old'Self{_name = Prelude'.Just new'Field}) (P'.wireGet 9)
             34 -> Prelude'.fmap (\ !new'Field -> old'Self{_hash = Prelude'.Just new'Field}) (P'.wireGet 9)
             42 -> Prelude'.fmap (\ !new'Field -> old'Self{_reason = Prelude'.Just new'Field}) (P'.wireGet 9)
             50 -> Prelude'.fmap (\ !new'Field -> old'Self{_start = Prelude'.Just new'Field}) (P'.wireGet 9)
             56 -> Prelude'.fmap (\ !new'Field -> old'Self{_duration = Prelude'.Just new'Field}) (P'.wireGet 13)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> BanEntry) BanEntry where
  getVal m' f' = f' m'

instance P'.GPB BanEntry

instance P'.ReflectDescriptor BanEntry where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList [10, 16]) (P'.fromDistinctAscList [10, 16, 26, 34, 42, 50, 56])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.BanList.BanEntry\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\",MName \"BanList\"], baseName = MName \"BanEntry\"}, descFilePath = [\"Data\",\"MumbleProto\",\"BanList\",\"BanEntry.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.BanList.BanEntry.address\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"BanList\",MName \"BanEntry\"], baseName' = FName \"address\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 10}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 12}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.BanList.BanEntry.mask\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"BanList\",MName \"BanEntry\"], baseName' = FName \"mask\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.BanList.BanEntry.name\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"BanList\",MName \"BanEntry\"], baseName' = FName \"name\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 26}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.BanList.BanEntry.hash\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"BanList\",MName \"BanEntry\"], baseName' = FName \"hash\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 34}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.BanList.BanEntry.reason\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"BanList\",MName \"BanEntry\"], baseName' = FName \"reason\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 5}, wireTag = WireTag {getWireTag = 42}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.BanList.BanEntry.start\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"BanList\",MName \"BanEntry\"], baseName' = FName \"start\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 6}, wireTag = WireTag {getWireTag = 50}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.BanList.BanEntry.duration\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"BanList\",MName \"BanEntry\"], baseName' = FName \"duration\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 7}, wireTag = WireTag {getWireTag = 56}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType BanEntry where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg BanEntry where
  textPut msg
   = do
       P'.tellT "address" (_address msg)
       P'.tellT "mask" (_mask msg)
       P'.tellT "name" (_name msg)
       P'.tellT "hash" (_hash msg)
       P'.tellT "reason" (_reason msg)
       P'.tellT "start" (_start msg)
       P'.tellT "duration" (_duration msg)
  textGet
   = do
       mods <- P'.sepEndBy
                (P'.choice [parse'_address, parse'_mask, parse'_name, parse'_hash, parse'_reason, parse'_start, parse'_duration])
                P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_address
         = P'.try
            (do
               v <- P'.getT "address"
               Prelude'.return (\ o -> o{_address = v}))
        parse'_mask
         = P'.try
            (do
               v <- P'.getT "mask"
               Prelude'.return (\ o -> o{_mask = v}))
        parse'_name
         = P'.try
            (do
               v <- P'.getT "name"
               Prelude'.return (\ o -> o{_name = v}))
        parse'_hash
         = P'.try
            (do
               v <- P'.getT "hash"
               Prelude'.return (\ o -> o{_hash = v}))
        parse'_reason
         = P'.try
            (do
               v <- P'.getT "reason"
               Prelude'.return (\ o -> o{_reason = v}))
        parse'_start
         = P'.try
            (do
               v <- P'.getT "start"
               Prelude'.return (\ o -> o{_start = v}))
        parse'_duration
         = P'.try
            (do
               v <- P'.getT "duration"
               Prelude'.return (\ o -> o{_duration = v}))