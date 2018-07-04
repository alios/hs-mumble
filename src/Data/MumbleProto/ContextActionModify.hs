{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.ContextActionModify (ContextActionModify(..), action, text, context, operation) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH
import qualified Data.MumbleProto.ContextActionModify.Operation as MumbleProto.ContextActionModify (Operation)

data ContextActionModify = ContextActionModify{_action :: !(P'.Utf8), _text :: !(P'.Maybe P'.Utf8),
                                               _context :: !(P'.Maybe P'.Word32),
                                               _operation :: !(P'.Maybe MumbleProto.ContextActionModify.Operation)}
                           deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''ContextActionModify

instance P'.Mergeable ContextActionModify where
  mergeAppend (ContextActionModify x'1 x'2 x'3 x'4) (ContextActionModify y'1 y'2 y'3 y'4)
   = ContextActionModify (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)

instance P'.Default ContextActionModify where
  defaultValue = ContextActionModify P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue

instance P'.Wire ContextActionModify where
  wireSize ft' self'@(ContextActionModify x'1 x'2 x'3 x'4)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeReq 1 9 x'1 + P'.wireSizeOpt 1 9 x'2 + P'.wireSizeOpt 1 13 x'3 + P'.wireSizeOpt 1 14 x'4)
  wirePutWithSize ft' self'@(ContextActionModify x'1 x'2 x'3 x'4)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutReqWithSize 10 9 x'1, P'.wirePutOptWithSize 18 9 x'2, P'.wirePutOptWithSize 24 13 x'3,
             P'.wirePutOptWithSize 32 14 x'4]
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
             10 -> Prelude'.fmap (\ !new'Field -> old'Self{_action = new'Field}) (P'.wireGet 9)
             18 -> Prelude'.fmap (\ !new'Field -> old'Self{_text = Prelude'.Just new'Field}) (P'.wireGet 9)
             24 -> Prelude'.fmap (\ !new'Field -> old'Self{_context = Prelude'.Just new'Field}) (P'.wireGet 13)
             32 -> Prelude'.fmap (\ !new'Field -> old'Self{_operation = Prelude'.Just new'Field}) (P'.wireGet 14)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> ContextActionModify) ContextActionModify where
  getVal m' f' = f' m'

instance P'.GPB ContextActionModify

instance P'.ReflectDescriptor ContextActionModify where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList [10]) (P'.fromDistinctAscList [10, 18, 24, 32])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.ContextActionModify\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"ContextActionModify\"}, descFilePath = [\"Data\",\"MumbleProto\",\"ContextActionModify.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ContextActionModify.action\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ContextActionModify\"], baseName' = FName \"action\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 10}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ContextActionModify.text\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ContextActionModify\"], baseName' = FName \"text\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 18}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ContextActionModify.context\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ContextActionModify\"], baseName' = FName \"context\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 24}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ContextActionModify.operation\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ContextActionModify\"], baseName' = FName \"operation\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 32}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 14}, typeName = Just (ProtoName {protobufName = FIName \".MumbleProto.ContextActionModify.Operation\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\",MName \"ContextActionModify\"], baseName = MName \"Operation\"}), hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType ContextActionModify where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg ContextActionModify where
  textPut msg
   = do
       P'.tellT "action" (_action msg)
       P'.tellT "text" (_text msg)
       P'.tellT "context" (_context msg)
       P'.tellT "operation" (_operation msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_action, parse'_text, parse'_context, parse'_operation]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_action
         = P'.try
            (do
               v <- P'.getT "action"
               Prelude'.return (\ o -> o{_action = v}))
        parse'_text
         = P'.try
            (do
               v <- P'.getT "text"
               Prelude'.return (\ o -> o{_text = v}))
        parse'_context
         = P'.try
            (do
               v <- P'.getT "context"
               Prelude'.return (\ o -> o{_context = v}))
        parse'_operation
         = P'.try
            (do
               v <- P'.getT "operation"
               Prelude'.return (\ o -> o{_operation = v}))