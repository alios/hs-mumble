{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.VoiceTarget.Target (Target(..), session, channel_id, group, links, children) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data Target = Target{_session :: !(P'.Seq P'.Word32), _channel_id :: !(P'.Maybe P'.Word32), _group :: !(P'.Maybe P'.Utf8),
                     _links :: !(P'.Maybe P'.Bool), _children :: !(P'.Maybe P'.Bool)}
              deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''Target

instance P'.Mergeable Target where
  mergeAppend (Target x'1 x'2 x'3 x'4 x'5) (Target y'1 y'2 y'3 y'4 y'5)
   = Target (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)
      (P'.mergeAppend x'5 y'5)

instance P'.Default Target where
  defaultValue
   = Target P'.defaultValue P'.defaultValue P'.defaultValue (Prelude'.Just Prelude'.False) (Prelude'.Just Prelude'.False)

instance P'.Wire Target where
  wireSize ft' self'@(Target x'1 x'2 x'3 x'4 x'5)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size
         = (P'.wireSizeRep 1 13 x'1 + P'.wireSizeOpt 1 13 x'2 + P'.wireSizeOpt 1 9 x'3 + P'.wireSizeOpt 1 8 x'4 +
             P'.wireSizeOpt 1 8 x'5)
  wirePutWithSize ft' self'@(Target x'1 x'2 x'3 x'4 x'5)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutRepWithSize 8 13 x'1, P'.wirePutOptWithSize 16 13 x'2, P'.wirePutOptWithSize 26 9 x'3,
             P'.wirePutOptWithSize 32 8 x'4, P'.wirePutOptWithSize 40 8 x'5]
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
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_session = P'.append (_session old'Self) new'Field}) (P'.wireGet 13)
             10 -> Prelude'.fmap (\ !new'Field -> old'Self{_session = P'.mergeAppend (_session old'Self) new'Field})
                    (P'.wireGetPacked 13)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_channel_id = Prelude'.Just new'Field}) (P'.wireGet 13)
             26 -> Prelude'.fmap (\ !new'Field -> old'Self{_group = Prelude'.Just new'Field}) (P'.wireGet 9)
             32 -> Prelude'.fmap (\ !new'Field -> old'Self{_links = Prelude'.Just new'Field}) (P'.wireGet 8)
             40 -> Prelude'.fmap (\ !new'Field -> old'Self{_children = Prelude'.Just new'Field}) (P'.wireGet 8)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> Target) Target where
  getVal m' f' = f' m'

instance P'.GPB Target

instance P'.ReflectDescriptor Target where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [8, 10, 16, 26, 32, 40])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.VoiceTarget.Target\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\",MName \"VoiceTarget\"], baseName = MName \"Target\"}, descFilePath = [\"Data\",\"MumbleProto\",\"VoiceTarget\",\"Target.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.VoiceTarget.Target.session\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"VoiceTarget\",MName \"Target\"], baseName' = FName \"session\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Just (WireTag {getWireTag = 8},WireTag {getWireTag = 10}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.VoiceTarget.Target.channel_id\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"VoiceTarget\",MName \"Target\"], baseName' = FName \"channel_id\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.VoiceTarget.Target.group\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"VoiceTarget\",MName \"Target\"], baseName' = FName \"group\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 26}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.VoiceTarget.Target.links\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"VoiceTarget\",MName \"Target\"], baseName' = FName \"links\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 32}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"false\", hsDefault = Just (HsDef'Bool False)},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.VoiceTarget.Target.children\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"VoiceTarget\",MName \"Target\"], baseName' = FName \"children\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 5}, wireTag = WireTag {getWireTag = 40}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"false\", hsDefault = Just (HsDef'Bool False)}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType Target where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg Target where
  textPut msg
   = do
       P'.tellT "session" (_session msg)
       P'.tellT "channel_id" (_channel_id msg)
       P'.tellT "group" (_group msg)
       P'.tellT "links" (_links msg)
       P'.tellT "children" (_children msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_session, parse'_channel_id, parse'_group, parse'_links, parse'_children]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_session
         = P'.try
            (do
               v <- P'.getT "session"
               Prelude'.return (\ o -> o{_session = P'.append (_session o) v}))
        parse'_channel_id
         = P'.try
            (do
               v <- P'.getT "channel_id"
               Prelude'.return (\ o -> o{_channel_id = v}))
        parse'_group
         = P'.try
            (do
               v <- P'.getT "group"
               Prelude'.return (\ o -> o{_group = v}))
        parse'_links
         = P'.try
            (do
               v <- P'.getT "links"
               Prelude'.return (\ o -> o{_links = v}))
        parse'_children
         = P'.try
            (do
               v <- P'.getT "children"
               Prelude'.return (\ o -> o{_children = v}))