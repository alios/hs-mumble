{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.ACL.ChanGroup (ChanGroup(..), name, inherited, inherit, inheritable, add, remove, inherited_members) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data ChanGroup = ChanGroup{_name :: !(P'.Utf8), _inherited :: !(P'.Maybe P'.Bool), _inherit :: !(P'.Maybe P'.Bool),
                           _inheritable :: !(P'.Maybe P'.Bool), _add :: !(P'.Seq P'.Word32), _remove :: !(P'.Seq P'.Word32),
                           _inherited_members :: !(P'.Seq P'.Word32)}
                 deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''ChanGroup

instance P'.Mergeable ChanGroup where
  mergeAppend (ChanGroup x'1 x'2 x'3 x'4 x'5 x'6 x'7) (ChanGroup y'1 y'2 y'3 y'4 y'5 y'6 y'7)
   = ChanGroup (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)
      (P'.mergeAppend x'5 y'5)
      (P'.mergeAppend x'6 y'6)
      (P'.mergeAppend x'7 y'7)

instance P'.Default ChanGroup where
  defaultValue
   = ChanGroup P'.defaultValue (Prelude'.Just Prelude'.True) (Prelude'.Just Prelude'.True) (Prelude'.Just Prelude'.True)
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue

instance P'.Wire ChanGroup where
  wireSize ft' self'@(ChanGroup x'1 x'2 x'3 x'4 x'5 x'6 x'7)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size
         = (P'.wireSizeReq 1 9 x'1 + P'.wireSizeOpt 1 8 x'2 + P'.wireSizeOpt 1 8 x'3 + P'.wireSizeOpt 1 8 x'4 +
             P'.wireSizeRep 1 13 x'5
             + P'.wireSizeRep 1 13 x'6
             + P'.wireSizeRep 1 13 x'7)
  wirePutWithSize ft' self'@(ChanGroup x'1 x'2 x'3 x'4 x'5 x'6 x'7)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutReqWithSize 10 9 x'1, P'.wirePutOptWithSize 16 8 x'2, P'.wirePutOptWithSize 24 8 x'3,
             P'.wirePutOptWithSize 32 8 x'4, P'.wirePutRepWithSize 40 13 x'5, P'.wirePutRepWithSize 48 13 x'6,
             P'.wirePutRepWithSize 56 13 x'7]
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
             10 -> Prelude'.fmap (\ !new'Field -> old'Self{_name = new'Field}) (P'.wireGet 9)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_inherited = Prelude'.Just new'Field}) (P'.wireGet 8)
             24 -> Prelude'.fmap (\ !new'Field -> old'Self{_inherit = Prelude'.Just new'Field}) (P'.wireGet 8)
             32 -> Prelude'.fmap (\ !new'Field -> old'Self{_inheritable = Prelude'.Just new'Field}) (P'.wireGet 8)
             40 -> Prelude'.fmap (\ !new'Field -> old'Self{_add = P'.append (_add old'Self) new'Field}) (P'.wireGet 13)
             42 -> Prelude'.fmap (\ !new'Field -> old'Self{_add = P'.mergeAppend (_add old'Self) new'Field}) (P'.wireGetPacked 13)
             48 -> Prelude'.fmap (\ !new'Field -> old'Self{_remove = P'.append (_remove old'Self) new'Field}) (P'.wireGet 13)
             50 -> Prelude'.fmap (\ !new'Field -> old'Self{_remove = P'.mergeAppend (_remove old'Self) new'Field})
                    (P'.wireGetPacked 13)
             56 -> Prelude'.fmap (\ !new'Field -> old'Self{_inherited_members = P'.append (_inherited_members old'Self) new'Field})
                    (P'.wireGet 13)
             58 -> Prelude'.fmap
                    (\ !new'Field -> old'Self{_inherited_members = P'.mergeAppend (_inherited_members old'Self) new'Field})
                    (P'.wireGetPacked 13)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> ChanGroup) ChanGroup where
  getVal m' f' = f' m'

instance P'.GPB ChanGroup

instance P'.ReflectDescriptor ChanGroup where
  getMessageInfo _
   = P'.GetMessageInfo (P'.fromDistinctAscList [10]) (P'.fromDistinctAscList [10, 16, 24, 32, 40, 42, 48, 50, 56, 58])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.ACL.ChanGroup\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\",MName \"ACL\"], baseName = MName \"ChanGroup\"}, descFilePath = [\"Data\",\"MumbleProto\",\"ACL\",\"ChanGroup.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.ChanGroup.name\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\",MName \"ChanGroup\"], baseName' = FName \"name\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 10}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.ChanGroup.inherited\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\",MName \"ChanGroup\"], baseName' = FName \"inherited\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"true\", hsDefault = Just (HsDef'Bool True)},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.ChanGroup.inherit\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\",MName \"ChanGroup\"], baseName' = FName \"inherit\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 24}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"true\", hsDefault = Just (HsDef'Bool True)},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.ChanGroup.inheritable\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\",MName \"ChanGroup\"], baseName' = FName \"inheritable\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 32}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"true\", hsDefault = Just (HsDef'Bool True)},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.ChanGroup.add\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\",MName \"ChanGroup\"], baseName' = FName \"add\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 5}, wireTag = WireTag {getWireTag = 40}, packedTag = Just (WireTag {getWireTag = 40},WireTag {getWireTag = 42}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.ChanGroup.remove\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\",MName \"ChanGroup\"], baseName' = FName \"remove\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 6}, wireTag = WireTag {getWireTag = 48}, packedTag = Just (WireTag {getWireTag = 48},WireTag {getWireTag = 50}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ACL.ChanGroup.inherited_members\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ACL\",MName \"ChanGroup\"], baseName' = FName \"inherited_members\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 7}, wireTag = WireTag {getWireTag = 56}, packedTag = Just (WireTag {getWireTag = 56},WireTag {getWireTag = 58}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType ChanGroup where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg ChanGroup where
  textPut msg
   = do
       P'.tellT "name" (_name msg)
       P'.tellT "inherited" (_inherited msg)
       P'.tellT "inherit" (_inherit msg)
       P'.tellT "inheritable" (_inheritable msg)
       P'.tellT "add" (_add msg)
       P'.tellT "remove" (_remove msg)
       P'.tellT "inherited_members" (_inherited_members msg)
  textGet
   = do
       mods <- P'.sepEndBy
                (P'.choice
                  [parse'_name, parse'_inherited, parse'_inherit, parse'_inheritable, parse'_add, parse'_remove,
                   parse'_inherited_members])
                P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_name
         = P'.try
            (do
               v <- P'.getT "name"
               Prelude'.return (\ o -> o{_name = v}))
        parse'_inherited
         = P'.try
            (do
               v <- P'.getT "inherited"
               Prelude'.return (\ o -> o{_inherited = v}))
        parse'_inherit
         = P'.try
            (do
               v <- P'.getT "inherit"
               Prelude'.return (\ o -> o{_inherit = v}))
        parse'_inheritable
         = P'.try
            (do
               v <- P'.getT "inheritable"
               Prelude'.return (\ o -> o{_inheritable = v}))
        parse'_add
         = P'.try
            (do
               v <- P'.getT "add"
               Prelude'.return (\ o -> o{_add = P'.append (_add o) v}))
        parse'_remove
         = P'.try
            (do
               v <- P'.getT "remove"
               Prelude'.return (\ o -> o{_remove = P'.append (_remove o) v}))
        parse'_inherited_members
         = P'.try
            (do
               v <- P'.getT "inherited_members"
               Prelude'.return (\ o -> o{_inherited_members = P'.append (_inherited_members o) v}))