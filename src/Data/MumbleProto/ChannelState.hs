{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.ChannelState
       (ChannelState(..), channel_id, parent, name, links, description, links_add, links_remove, temporary, position,
        description_hash, max_users)
       where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data ChannelState = ChannelState{_channel_id :: !(P'.Maybe P'.Word32), _parent :: !(P'.Maybe P'.Word32),
                                 _name :: !(P'.Maybe P'.Utf8), _links :: !(P'.Seq P'.Word32), _description :: !(P'.Maybe P'.Utf8),
                                 _links_add :: !(P'.Seq P'.Word32), _links_remove :: !(P'.Seq P'.Word32),
                                 _temporary :: !(P'.Maybe P'.Bool), _position :: !(P'.Maybe P'.Int32),
                                 _description_hash :: !(P'.Maybe P'.ByteString), _max_users :: !(P'.Maybe P'.Word32)}
                    deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''ChannelState

instance P'.Mergeable ChannelState where
  mergeAppend (ChannelState x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11)
   (ChannelState y'1 y'2 y'3 y'4 y'5 y'6 y'7 y'8 y'9 y'10 y'11)
   = ChannelState (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)
      (P'.mergeAppend x'5 y'5)
      (P'.mergeAppend x'6 y'6)
      (P'.mergeAppend x'7 y'7)
      (P'.mergeAppend x'8 y'8)
      (P'.mergeAppend x'9 y'9)
      (P'.mergeAppend x'10 y'10)
      (P'.mergeAppend x'11 y'11)

instance P'.Default ChannelState where
  defaultValue
   = ChannelState P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue
      (Prelude'.Just Prelude'.False)
      (Prelude'.Just 0)
      P'.defaultValue
      P'.defaultValue

instance P'.Wire ChannelState where
  wireSize ft' self'@(ChannelState x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size
         = (P'.wireSizeOpt 1 13 x'1 + P'.wireSizeOpt 1 13 x'2 + P'.wireSizeOpt 1 9 x'3 + P'.wireSizeRep 1 13 x'4 +
             P'.wireSizeOpt 1 9 x'5
             + P'.wireSizeRep 1 13 x'6
             + P'.wireSizeRep 1 13 x'7
             + P'.wireSizeOpt 1 8 x'8
             + P'.wireSizeOpt 1 5 x'9
             + P'.wireSizeOpt 1 12 x'10
             + P'.wireSizeOpt 1 13 x'11)
  wirePutWithSize ft' self'@(ChannelState x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutOptWithSize 8 13 x'1, P'.wirePutOptWithSize 16 13 x'2, P'.wirePutOptWithSize 26 9 x'3,
             P'.wirePutRepWithSize 32 13 x'4, P'.wirePutOptWithSize 42 9 x'5, P'.wirePutRepWithSize 48 13 x'6,
             P'.wirePutRepWithSize 56 13 x'7, P'.wirePutOptWithSize 64 8 x'8, P'.wirePutOptWithSize 72 5 x'9,
             P'.wirePutOptWithSize 82 12 x'10, P'.wirePutOptWithSize 88 13 x'11]
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
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_channel_id = Prelude'.Just new'Field}) (P'.wireGet 13)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_parent = Prelude'.Just new'Field}) (P'.wireGet 13)
             26 -> Prelude'.fmap (\ !new'Field -> old'Self{_name = Prelude'.Just new'Field}) (P'.wireGet 9)
             32 -> Prelude'.fmap (\ !new'Field -> old'Self{_links = P'.append (_links old'Self) new'Field}) (P'.wireGet 13)
             34 -> Prelude'.fmap (\ !new'Field -> old'Self{_links = P'.mergeAppend (_links old'Self) new'Field})
                    (P'.wireGetPacked 13)
             42 -> Prelude'.fmap (\ !new'Field -> old'Self{_description = Prelude'.Just new'Field}) (P'.wireGet 9)
             48 -> Prelude'.fmap (\ !new'Field -> old'Self{_links_add = P'.append (_links_add old'Self) new'Field}) (P'.wireGet 13)
             50 -> Prelude'.fmap (\ !new'Field -> old'Self{_links_add = P'.mergeAppend (_links_add old'Self) new'Field})
                    (P'.wireGetPacked 13)
             56 -> Prelude'.fmap (\ !new'Field -> old'Self{_links_remove = P'.append (_links_remove old'Self) new'Field})
                    (P'.wireGet 13)
             58 -> Prelude'.fmap (\ !new'Field -> old'Self{_links_remove = P'.mergeAppend (_links_remove old'Self) new'Field})
                    (P'.wireGetPacked 13)
             64 -> Prelude'.fmap (\ !new'Field -> old'Self{_temporary = Prelude'.Just new'Field}) (P'.wireGet 8)
             72 -> Prelude'.fmap (\ !new'Field -> old'Self{_position = Prelude'.Just new'Field}) (P'.wireGet 5)
             82 -> Prelude'.fmap (\ !new'Field -> old'Self{_description_hash = Prelude'.Just new'Field}) (P'.wireGet 12)
             88 -> Prelude'.fmap (\ !new'Field -> old'Self{_max_users = Prelude'.Just new'Field}) (P'.wireGet 13)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> ChannelState) ChannelState where
  getVal m' f' = f' m'

instance P'.GPB ChannelState

instance P'.ReflectDescriptor ChannelState where
  getMessageInfo _
   = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [8, 16, 26, 32, 34, 42, 48, 50, 56, 58, 64, 72, 82, 88])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.ChannelState\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"ChannelState\"}, descFilePath = [\"Data\",\"MumbleProto\",\"ChannelState.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ChannelState.channel_id\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ChannelState\"], baseName' = FName \"channel_id\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ChannelState.parent\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ChannelState\"], baseName' = FName \"parent\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ChannelState.name\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ChannelState\"], baseName' = FName \"name\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 26}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ChannelState.links\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ChannelState\"], baseName' = FName \"links\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 32}, packedTag = Just (WireTag {getWireTag = 32},WireTag {getWireTag = 34}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ChannelState.description\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ChannelState\"], baseName' = FName \"description\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 5}, wireTag = WireTag {getWireTag = 42}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ChannelState.links_add\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ChannelState\"], baseName' = FName \"links_add\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 6}, wireTag = WireTag {getWireTag = 48}, packedTag = Just (WireTag {getWireTag = 48},WireTag {getWireTag = 50}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ChannelState.links_remove\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ChannelState\"], baseName' = FName \"links_remove\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 7}, wireTag = WireTag {getWireTag = 56}, packedTag = Just (WireTag {getWireTag = 56},WireTag {getWireTag = 58}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ChannelState.temporary\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ChannelState\"], baseName' = FName \"temporary\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 8}, wireTag = WireTag {getWireTag = 64}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"false\", hsDefault = Just (HsDef'Bool False)},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ChannelState.position\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ChannelState\"], baseName' = FName \"position\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 9}, wireTag = WireTag {getWireTag = 72}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Just \"0\", hsDefault = Just (HsDef'Integer 0)},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ChannelState.description_hash\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ChannelState\"], baseName' = FName \"description_hash\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 10}, wireTag = WireTag {getWireTag = 82}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 12}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ChannelState.max_users\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ChannelState\"], baseName' = FName \"max_users\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 11}, wireTag = WireTag {getWireTag = 88}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType ChannelState where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg ChannelState where
  textPut msg
   = do
       P'.tellT "channel_id" (_channel_id msg)
       P'.tellT "parent" (_parent msg)
       P'.tellT "name" (_name msg)
       P'.tellT "links" (_links msg)
       P'.tellT "description" (_description msg)
       P'.tellT "links_add" (_links_add msg)
       P'.tellT "links_remove" (_links_remove msg)
       P'.tellT "temporary" (_temporary msg)
       P'.tellT "position" (_position msg)
       P'.tellT "description_hash" (_description_hash msg)
       P'.tellT "max_users" (_max_users msg)
  textGet
   = do
       mods <- P'.sepEndBy
                (P'.choice
                  [parse'_channel_id, parse'_parent, parse'_name, parse'_links, parse'_description, parse'_links_add,
                   parse'_links_remove, parse'_temporary, parse'_position, parse'_description_hash, parse'_max_users])
                P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_channel_id
         = P'.try
            (do
               v <- P'.getT "channel_id"
               Prelude'.return (\ o -> o{_channel_id = v}))
        parse'_parent
         = P'.try
            (do
               v <- P'.getT "parent"
               Prelude'.return (\ o -> o{_parent = v}))
        parse'_name
         = P'.try
            (do
               v <- P'.getT "name"
               Prelude'.return (\ o -> o{_name = v}))
        parse'_links
         = P'.try
            (do
               v <- P'.getT "links"
               Prelude'.return (\ o -> o{_links = P'.append (_links o) v}))
        parse'_description
         = P'.try
            (do
               v <- P'.getT "description"
               Prelude'.return (\ o -> o{_description = v}))
        parse'_links_add
         = P'.try
            (do
               v <- P'.getT "links_add"
               Prelude'.return (\ o -> o{_links_add = P'.append (_links_add o) v}))
        parse'_links_remove
         = P'.try
            (do
               v <- P'.getT "links_remove"
               Prelude'.return (\ o -> o{_links_remove = P'.append (_links_remove o) v}))
        parse'_temporary
         = P'.try
            (do
               v <- P'.getT "temporary"
               Prelude'.return (\ o -> o{_temporary = v}))
        parse'_position
         = P'.try
            (do
               v <- P'.getT "position"
               Prelude'.return (\ o -> o{_position = v}))
        parse'_description_hash
         = P'.try
            (do
               v <- P'.getT "description_hash"
               Prelude'.return (\ o -> o{_description_hash = v}))
        parse'_max_users
         = P'.try
            (do
               v <- P'.getT "max_users"
               Prelude'.return (\ o -> o{_max_users = v}))