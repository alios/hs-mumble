{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.PermissionDenied (PermissionDenied(..), permission, channel_id, session, reason, type', name) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH
import qualified Data.MumbleProto.PermissionDenied.DenyType as MumbleProto.PermissionDenied (DenyType)

data PermissionDenied = PermissionDenied{_permission :: !(P'.Maybe P'.Word32), _channel_id :: !(P'.Maybe P'.Word32),
                                         _session :: !(P'.Maybe P'.Word32), _reason :: !(P'.Maybe P'.Utf8),
                                         _type' :: !(P'.Maybe MumbleProto.PermissionDenied.DenyType), _name :: !(P'.Maybe P'.Utf8)}
                        deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''PermissionDenied

instance P'.Mergeable PermissionDenied where
  mergeAppend (PermissionDenied x'1 x'2 x'3 x'4 x'5 x'6) (PermissionDenied y'1 y'2 y'3 y'4 y'5 y'6)
   = PermissionDenied (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)
      (P'.mergeAppend x'5 y'5)
      (P'.mergeAppend x'6 y'6)

instance P'.Default PermissionDenied where
  defaultValue = PermissionDenied P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue

instance P'.Wire PermissionDenied where
  wireSize ft' self'@(PermissionDenied x'1 x'2 x'3 x'4 x'5 x'6)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size
         = (P'.wireSizeOpt 1 13 x'1 + P'.wireSizeOpt 1 13 x'2 + P'.wireSizeOpt 1 13 x'3 + P'.wireSizeOpt 1 9 x'4 +
             P'.wireSizeOpt 1 14 x'5
             + P'.wireSizeOpt 1 9 x'6)
  wirePutWithSize ft' self'@(PermissionDenied x'1 x'2 x'3 x'4 x'5 x'6)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutOptWithSize 8 13 x'1, P'.wirePutOptWithSize 16 13 x'2, P'.wirePutOptWithSize 24 13 x'3,
             P'.wirePutOptWithSize 34 9 x'4, P'.wirePutOptWithSize 40 14 x'5, P'.wirePutOptWithSize 50 9 x'6]
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
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_permission = Prelude'.Just new'Field}) (P'.wireGet 13)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_channel_id = Prelude'.Just new'Field}) (P'.wireGet 13)
             24 -> Prelude'.fmap (\ !new'Field -> old'Self{_session = Prelude'.Just new'Field}) (P'.wireGet 13)
             34 -> Prelude'.fmap (\ !new'Field -> old'Self{_reason = Prelude'.Just new'Field}) (P'.wireGet 9)
             40 -> Prelude'.fmap (\ !new'Field -> old'Self{_type' = Prelude'.Just new'Field}) (P'.wireGet 14)
             50 -> Prelude'.fmap (\ !new'Field -> old'Self{_name = Prelude'.Just new'Field}) (P'.wireGet 9)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> PermissionDenied) PermissionDenied where
  getVal m' f' = f' m'

instance P'.GPB PermissionDenied

instance P'.ReflectDescriptor PermissionDenied where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [8, 16, 24, 34, 40, 50])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.PermissionDenied\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"PermissionDenied\"}, descFilePath = [\"Data\",\"MumbleProto\",\"PermissionDenied.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.PermissionDenied.permission\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"PermissionDenied\"], baseName' = FName \"permission\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.PermissionDenied.channel_id\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"PermissionDenied\"], baseName' = FName \"channel_id\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.PermissionDenied.session\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"PermissionDenied\"], baseName' = FName \"session\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 24}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.PermissionDenied.reason\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"PermissionDenied\"], baseName' = FName \"reason\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 34}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.PermissionDenied.type\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"PermissionDenied\"], baseName' = FName \"type'\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 5}, wireTag = WireTag {getWireTag = 40}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 14}, typeName = Just (ProtoName {protobufName = FIName \".MumbleProto.PermissionDenied.DenyType\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\",MName \"PermissionDenied\"], baseName = MName \"DenyType\"}), hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.PermissionDenied.name\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"PermissionDenied\"], baseName' = FName \"name\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 6}, wireTag = WireTag {getWireTag = 50}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType PermissionDenied where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg PermissionDenied where
  textPut msg
   = do
       P'.tellT "permission" (_permission msg)
       P'.tellT "channel_id" (_channel_id msg)
       P'.tellT "session" (_session msg)
       P'.tellT "reason" (_reason msg)
       P'.tellT "type" (_type' msg)
       P'.tellT "name" (_name msg)
  textGet
   = do
       mods <- P'.sepEndBy
                (P'.choice [parse'_permission, parse'_channel_id, parse'_session, parse'_reason, parse'_type', parse'_name])
                P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_permission
         = P'.try
            (do
               v <- P'.getT "permission"
               Prelude'.return (\ o -> o{_permission = v}))
        parse'_channel_id
         = P'.try
            (do
               v <- P'.getT "channel_id"
               Prelude'.return (\ o -> o{_channel_id = v}))
        parse'_session
         = P'.try
            (do
               v <- P'.getT "session"
               Prelude'.return (\ o -> o{_session = v}))
        parse'_reason
         = P'.try
            (do
               v <- P'.getT "reason"
               Prelude'.return (\ o -> o{_reason = v}))
        parse'_type'
         = P'.try
            (do
               v <- P'.getT "type"
               Prelude'.return (\ o -> o{_type' = v}))
        parse'_name
         = P'.try
            (do
               v <- P'.getT "name"
               Prelude'.return (\ o -> o{_name = v}))