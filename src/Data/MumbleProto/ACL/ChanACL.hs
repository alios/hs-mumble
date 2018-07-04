{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.ACL.ChanACL (ChanACL(..), apply_here, apply_subs, inherited, user_id, group, grant, deny) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data ChanACL = ChanACL{_apply_here :: !(P'.Maybe P'.Bool), _apply_subs :: !(P'.Maybe P'.Bool), _inherited :: !(P'.Maybe P'.Bool),
                       _user_id :: !(P'.Maybe P'.Word32), _group :: !(P'.Maybe P'.Utf8), _grant :: !(P'.Maybe P'.Word32),
                       _deny :: !(P'.Maybe P'.Word32)}
               deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''ChanACL

instance P'.Mergeable ChanACL where
  mergeAppend (ChanACL x'1 x'2 x'3 x'4 x'5 x'6 x'7) (ChanACL y'1 y'2 y'3 y'4 y'5 y'6 y'7)
   = ChanACL (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)
      (P'.mergeAppend x'5 y'5)
      (P'.mergeAppend x'6 y'6)
      (P'.mergeAppend x'7 y'7)

instance P'.Default ChanACL where
  defaultValue
   = ChanACL (Prelude'.Just Prelude'.True) (Prelude'.Just Prelude'.True) (Prelude'.Just Prelude'.True) P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue

instance P'.Wire ChanACL where
  wireSize ft' self'@(ChanACL x'1 x'2 x'3 x'4 x'5 x'6 x'7)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size
         = (P'.wireSizeOpt 1 8 x'1 + P'.wireSizeOpt 1 8 x'2 + P'.wireSizeOpt 1 8 x'3 + P'.wireSizeOpt 1 13 x'4 +
             P'.wireSizeOpt 1 9 x'5
             + P'.wireSizeOpt 1 13 x'6
             + P'.wireSizeOpt 1 13 x'7)
  wirePutWithSize ft' self'@(ChanACL x'1 x'2 x'3 x'4 x'5 x'6 x'7)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutOptWithSize 8 8 x'1, P'.wirePutOptWithSize 16 8 x'2, P'.wirePutOptWithSize 24 8 x'3,
             P'.wirePutOptWithSize 32 13 x'4, P'.wirePutOptWithSize 42 9 x'5, P'.wirePutOptWithSize 48 13 x'6,
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
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_apply_here = Prelude'.Just new'Field}) (P'.wireGet 8)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_apply_subs = Prelude'.Just new'Field}) (P'.wireGet 8)
             24 -> Prelude'.fmap (\ !new'Field -> old'Self{_inherited = Prelude'.Just new'Field}) (P'.wireGet 8)
             32 -> Prelude'.fmap (\ !new'Field -> old'Self{_user_id = Prelude'.Just new'Field}) (P'.wireGet 13)
             42 -> Prelude'.fmap (\ !new'Field -> old'Self{_group = Prelude'.Just new'Field}) (P'.wireGet 9)
             48 -> Prelude'.fmap (\ !new'Field -> old'Self{_grant = Prelude'.Just new'Field}) (P'.wireGet 13)
             56 -> Prelude'.fmap (\ !new'Field -> old'Self{_deny = Prelude'.Just new'Field}) (P'.wireGet 13)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> ChanACL) ChanACL where
  getVal m' f' = f' m'

instance P'.GPB ChanACL

instance P'.ReflectDescriptor ChanACL where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [8, 16, 24, 32, 42, 48, 56])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.ACL.ChanACL\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\",MName \"ACL\"], baseName = MName \"ChanACL\"}, descFilePath = [\"Data\",\"MumbleProto\",\"ACL\",\"ChanACL.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.ChanACL.apply_here\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\",MName \"ChanACL\"], baseName' = FName \"apply_here\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"true\", hsDefault = Just (HsDef'Bool True)},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.ChanACL.apply_subs\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\",MName \"ChanACL\"], baseName' = FName \"apply_subs\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"true\", hsDefault = Just (HsDef'Bool True)},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.ChanACL.inherited\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\",MName \"ChanACL\"], baseName' = FName \"inherited\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 24}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"true\", hsDefault = Just (HsDef'Bool True)},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.ChanACL.user_id\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\",MName \"ChanACL\"], baseName' = FName \"user_id\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 32}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.ChanACL.group\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\",MName \"ChanACL\"], baseName' = FName \"group\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 5}, wireTag = WireTag {getWireTag = 42}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.ChanACL.grant\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\",MName \"ChanACL\"], baseName' = FName \"grant\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 6}, wireTag = WireTag {getWireTag = 48}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.ChanACL.deny\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\",MName \"ChanACL\"], baseName' = FName \"deny\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 7}, wireTag = WireTag {getWireTag = 56}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType ChanACL where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg ChanACL where
  textPut msg
   = do
       P'.tellT "apply_here" (_apply_here msg)
       P'.tellT "apply_subs" (_apply_subs msg)
       P'.tellT "inherited" (_inherited msg)
       P'.tellT "user_id" (_user_id msg)
       P'.tellT "group" (_group msg)
       P'.tellT "grant" (_grant msg)
       P'.tellT "deny" (_deny msg)
  textGet
   = do
       mods <- P'.sepEndBy
                (P'.choice
                  [parse'_apply_here, parse'_apply_subs, parse'_inherited, parse'_user_id, parse'_group, parse'_grant, parse'_deny])
                P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_apply_here
         = P'.try
            (do
               v <- P'.getT "apply_here"
               Prelude'.return (\ o -> o{_apply_here = v}))
        parse'_apply_subs
         = P'.try
            (do
               v <- P'.getT "apply_subs"
               Prelude'.return (\ o -> o{_apply_subs = v}))
        parse'_inherited
         = P'.try
            (do
               v <- P'.getT "inherited"
               Prelude'.return (\ o -> o{_inherited = v}))
        parse'_user_id
         = P'.try
            (do
               v <- P'.getT "user_id"
               Prelude'.return (\ o -> o{_user_id = v}))
        parse'_group
         = P'.try
            (do
               v <- P'.getT "group"
               Prelude'.return (\ o -> o{_group = v}))
        parse'_grant
         = P'.try
            (do
               v <- P'.getT "grant"
               Prelude'.return (\ o -> o{_grant = v}))
        parse'_deny
         = P'.try
            (do
               v <- P'.getT "deny"
               Prelude'.return (\ o -> o{_deny = v}))