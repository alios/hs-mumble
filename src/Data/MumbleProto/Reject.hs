{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.Reject (Reject(..), type', reason) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH
import qualified Data.MumbleProto.Reject.RejectType as MumbleProto.Reject (RejectType)

data Reject = Reject{_type' :: !(P'.Maybe MumbleProto.Reject.RejectType), _reason :: !(P'.Maybe P'.Utf8)}
              deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''Reject

instance P'.Mergeable Reject where
  mergeAppend (Reject x'1 x'2) (Reject y'1 y'2) = Reject (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2)

instance P'.Default Reject where
  defaultValue = Reject P'.defaultValue P'.defaultValue

instance P'.Wire Reject where
  wireSize ft' self'@(Reject x'1 x'2)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeOpt 1 14 x'1 + P'.wireSizeOpt 1 9 x'2)
  wirePutWithSize ft' self'@(Reject x'1 x'2)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields = P'.sequencePutWithSize [P'.wirePutOptWithSize 8 14 x'1, P'.wirePutOptWithSize 18 9 x'2]
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
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_type' = Prelude'.Just new'Field}) (P'.wireGet 14)
             18 -> Prelude'.fmap (\ !new'Field -> old'Self{_reason = Prelude'.Just new'Field}) (P'.wireGet 9)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> Reject) Reject where
  getVal m' f' = f' m'

instance P'.GPB Reject

instance P'.ReflectDescriptor Reject where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [8, 18])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.Reject\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"Reject\"}, descFilePath = [\"Data\",\"MumbleProto\",\"Reject.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Reject.type\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Reject\"], baseName' = FName \"type'\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 14}, typeName = Just (ProtoName {protobufName = FIName \".MumbleProto.Reject.RejectType\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\",MName \"Reject\"], baseName = MName \"RejectType\"}), hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Reject.reason\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Reject\"], baseName' = FName \"reason\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 18}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType Reject where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg Reject where
  textPut msg
   = do
       P'.tellT "type" (_type' msg)
       P'.tellT "reason" (_reason msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_type', parse'_reason]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_type'
         = P'.try
            (do
               v <- P'.getT "type"
               Prelude'.return (\ o -> o{_type' = v}))
        parse'_reason
         = P'.try
            (do
               v <- P'.getT "reason"
               Prelude'.return (\ o -> o{_reason = v}))