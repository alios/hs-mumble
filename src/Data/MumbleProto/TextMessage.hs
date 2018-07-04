{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.TextMessage (TextMessage(..), actor, session, channel_id, tree_id, message) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data TextMessage = TextMessage{_actor :: !(P'.Maybe P'.Word32), _session :: !(P'.Seq P'.Word32), _channel_id :: !(P'.Seq P'.Word32),
                               _tree_id :: !(P'.Seq P'.Word32), _message :: !(P'.Utf8)}
                   deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''TextMessage

instance P'.Mergeable TextMessage where
  mergeAppend (TextMessage x'1 x'2 x'3 x'4 x'5) (TextMessage y'1 y'2 y'3 y'4 y'5)
   = TextMessage (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)
      (P'.mergeAppend x'5 y'5)

instance P'.Default TextMessage where
  defaultValue = TextMessage P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue

instance P'.Wire TextMessage where
  wireSize ft' self'@(TextMessage x'1 x'2 x'3 x'4 x'5)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size
         = (P'.wireSizeOpt 1 13 x'1 + P'.wireSizeRep 1 13 x'2 + P'.wireSizeRep 1 13 x'3 + P'.wireSizeRep 1 13 x'4 +
             P'.wireSizeReq 1 9 x'5)
  wirePutWithSize ft' self'@(TextMessage x'1 x'2 x'3 x'4 x'5)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutOptWithSize 8 13 x'1, P'.wirePutRepWithSize 16 13 x'2, P'.wirePutRepWithSize 24 13 x'3,
             P'.wirePutRepWithSize 32 13 x'4, P'.wirePutReqWithSize 42 9 x'5]
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
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_actor = Prelude'.Just new'Field}) (P'.wireGet 13)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_session = P'.append (_session old'Self) new'Field}) (P'.wireGet 13)
             18 -> Prelude'.fmap (\ !new'Field -> old'Self{_session = P'.mergeAppend (_session old'Self) new'Field})
                    (P'.wireGetPacked 13)
             24 -> Prelude'.fmap (\ !new'Field -> old'Self{_channel_id = P'.append (_channel_id old'Self) new'Field})
                    (P'.wireGet 13)
             26 -> Prelude'.fmap (\ !new'Field -> old'Self{_channel_id = P'.mergeAppend (_channel_id old'Self) new'Field})
                    (P'.wireGetPacked 13)
             32 -> Prelude'.fmap (\ !new'Field -> old'Self{_tree_id = P'.append (_tree_id old'Self) new'Field}) (P'.wireGet 13)
             34 -> Prelude'.fmap (\ !new'Field -> old'Self{_tree_id = P'.mergeAppend (_tree_id old'Self) new'Field})
                    (P'.wireGetPacked 13)
             42 -> Prelude'.fmap (\ !new'Field -> old'Self{_message = new'Field}) (P'.wireGet 9)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> TextMessage) TextMessage where
  getVal m' f' = f' m'

instance P'.GPB TextMessage

instance P'.ReflectDescriptor TextMessage where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList [42]) (P'.fromDistinctAscList [8, 16, 18, 24, 26, 32, 34, 42])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.TextMessage\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"TextMessage\"}, descFilePath = [\"Data\",\"MumbleProto\",\"TextMessage.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.TextMessage.actor\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"TextMessage\"], baseName' = FName \"actor\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.TextMessage.session\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"TextMessage\"], baseName' = FName \"session\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Just (WireTag {getWireTag = 16},WireTag {getWireTag = 18}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.TextMessage.channel_id\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"TextMessage\"], baseName' = FName \"channel_id\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 24}, packedTag = Just (WireTag {getWireTag = 24},WireTag {getWireTag = 26}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.TextMessage.tree_id\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"TextMessage\"], baseName' = FName \"tree_id\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 32}, packedTag = Just (WireTag {getWireTag = 32},WireTag {getWireTag = 34}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.TextMessage.message\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"TextMessage\"], baseName' = FName \"message\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 5}, wireTag = WireTag {getWireTag = 42}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType TextMessage where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg TextMessage where
  textPut msg
   = do
       P'.tellT "actor" (_actor msg)
       P'.tellT "session" (_session msg)
       P'.tellT "channel_id" (_channel_id msg)
       P'.tellT "tree_id" (_tree_id msg)
       P'.tellT "message" (_message msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_actor, parse'_session, parse'_channel_id, parse'_tree_id, parse'_message]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_actor
         = P'.try
            (do
               v <- P'.getT "actor"
               Prelude'.return (\ o -> o{_actor = v}))
        parse'_session
         = P'.try
            (do
               v <- P'.getT "session"
               Prelude'.return (\ o -> o{_session = P'.append (_session o) v}))
        parse'_channel_id
         = P'.try
            (do
               v <- P'.getT "channel_id"
               Prelude'.return (\ o -> o{_channel_id = P'.append (_channel_id o) v}))
        parse'_tree_id
         = P'.try
            (do
               v <- P'.getT "tree_id"
               Prelude'.return (\ o -> o{_tree_id = P'.append (_tree_id o) v}))
        parse'_message
         = P'.try
            (do
               v <- P'.getT "message"
               Prelude'.return (\ o -> o{_message = v}))