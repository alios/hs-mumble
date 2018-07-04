{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.ACL (ACL(..), channel_id, inherit_acls, groups, acls, query) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH
import qualified Data.MumbleProto.ACL.ChanACL as MumbleProto.ACL (ChanACL)
import qualified Data.MumbleProto.ACL.ChanGroup as MumbleProto.ACL (ChanGroup)

data ACL = ACL{_channel_id :: !(P'.Word32), _inherit_acls :: !(P'.Maybe P'.Bool), _groups :: !(P'.Seq MumbleProto.ACL.ChanGroup),
               _acls :: !(P'.Seq MumbleProto.ACL.ChanACL), _query :: !(P'.Maybe P'.Bool)}
           deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''ACL

instance P'.Mergeable ACL where
  mergeAppend (ACL x'1 x'2 x'3 x'4 x'5) (ACL y'1 y'2 y'3 y'4 y'5)
   = ACL (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)
      (P'.mergeAppend x'5 y'5)

instance P'.Default ACL where
  defaultValue = ACL P'.defaultValue (Prelude'.Just Prelude'.True) P'.defaultValue P'.defaultValue (Prelude'.Just Prelude'.False)

instance P'.Wire ACL where
  wireSize ft' self'@(ACL x'1 x'2 x'3 x'4 x'5)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size
         = (P'.wireSizeReq 1 13 x'1 + P'.wireSizeOpt 1 8 x'2 + P'.wireSizeRep 1 11 x'3 + P'.wireSizeRep 1 11 x'4 +
             P'.wireSizeOpt 1 8 x'5)
  wirePutWithSize ft' self'@(ACL x'1 x'2 x'3 x'4 x'5)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutReqWithSize 8 13 x'1, P'.wirePutOptWithSize 16 8 x'2, P'.wirePutRepWithSize 26 11 x'3,
             P'.wirePutRepWithSize 34 11 x'4, P'.wirePutOptWithSize 40 8 x'5]
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
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_channel_id = new'Field}) (P'.wireGet 13)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_inherit_acls = Prelude'.Just new'Field}) (P'.wireGet 8)
             26 -> Prelude'.fmap (\ !new'Field -> old'Self{_groups = P'.append (_groups old'Self) new'Field}) (P'.wireGet 11)
             34 -> Prelude'.fmap (\ !new'Field -> old'Self{_acls = P'.append (_acls old'Self) new'Field}) (P'.wireGet 11)
             40 -> Prelude'.fmap (\ !new'Field -> old'Self{_query = Prelude'.Just new'Field}) (P'.wireGet 8)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> ACL) ACL where
  getVal m' f' = f' m'

instance P'.GPB ACL

instance P'.ReflectDescriptor ACL where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList [8]) (P'.fromDistinctAscList [8, 16, 26, 34, 40])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.ACL\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"ACL\"}, descFilePath = [\"Data\",\"MumbleProto\",\"ACL.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.channel_id\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\"], baseName' = FName \"channel_id\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.inherit_acls\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\"], baseName' = FName \"inherit_acls\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"true\", hsDefault = Just (HsDef'Bool True)},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.groups\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\"], baseName' = FName \"groups\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 26}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".MumbleProto.ACL.ChanGroup\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\",MName \"ACL\"], baseName = MName \"ChanGroup\"}), hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.acls\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\"], baseName' = FName \"acls\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 34}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".MumbleProto.ACL.ChanACL\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\",MName \"ACL\"], baseName = MName \"ChanACL\"}), hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.query\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\"], baseName' = FName \"query\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 5}, wireTag = WireTag {getWireTag = 40}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"false\", hsDefault = Just (HsDef'Bool False)}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType ACL where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg ACL where
  textPut msg
   = do
       P'.tellT "channel_id" (_channel_id msg)
       P'.tellT "inherit_acls" (_inherit_acls msg)
       P'.tellT "groups" (_groups msg)
       P'.tellT "acls" (_acls msg)
       P'.tellT "query" (_query msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_channel_id, parse'_inherit_acls, parse'_groups, parse'_acls, parse'_query]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_channel_id
         = P'.try
            (do
               v <- P'.getT "channel_id"
               Prelude'.return (\ o -> o{_channel_id = v}))
        parse'_inherit_acls
         = P'.try
            (do
               v <- P'.getT "inherit_acls"
               Prelude'.return (\ o -> o{_inherit_acls = v}))
        parse'_groups
         = P'.try
            (do
               v <- P'.getT "groups"
               Prelude'.return (\ o -> o{_groups = P'.append (_groups o) v}))
        parse'_acls
         = P'.try
            (do
               v <- P'.getT "acls"
               Prelude'.return (\ o -> o{_acls = P'.append (_acls o) v}))
        parse'_query
         = P'.try
            (do
               v <- P'.getT "query"
               Prelude'.return (\ o -> o{_query = v}))