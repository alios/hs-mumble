{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.UserState
       (UserState(..), session, actor, name, user_id, channel_id, mute, deaf, suppress, self_mute, self_deaf, texture,
        plugin_context, plugin_identity, comment, hash, comment_hash, texture_hash, priority_speaker, recording)
       where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data UserState = UserState{_session :: !(P'.Maybe P'.Word32), _actor :: !(P'.Maybe P'.Word32), _name :: !(P'.Maybe P'.Utf8),
                           _user_id :: !(P'.Maybe P'.Word32), _channel_id :: !(P'.Maybe P'.Word32), _mute :: !(P'.Maybe P'.Bool),
                           _deaf :: !(P'.Maybe P'.Bool), _suppress :: !(P'.Maybe P'.Bool), _self_mute :: !(P'.Maybe P'.Bool),
                           _self_deaf :: !(P'.Maybe P'.Bool), _texture :: !(P'.Maybe P'.ByteString),
                           _plugin_context :: !(P'.Maybe P'.ByteString), _plugin_identity :: !(P'.Maybe P'.Utf8),
                           _comment :: !(P'.Maybe P'.Utf8), _hash :: !(P'.Maybe P'.Utf8),
                           _comment_hash :: !(P'.Maybe P'.ByteString), _texture_hash :: !(P'.Maybe P'.ByteString),
                           _priority_speaker :: !(P'.Maybe P'.Bool), _recording :: !(P'.Maybe P'.Bool)}
                 deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''UserState

instance P'.Mergeable UserState where
  mergeAppend (UserState x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11 x'12 x'13 x'14 x'15 x'16 x'17 x'18 x'19)
   (UserState y'1 y'2 y'3 y'4 y'5 y'6 y'7 y'8 y'9 y'10 y'11 y'12 y'13 y'14 y'15 y'16 y'17 y'18 y'19)
   = UserState (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)
      (P'.mergeAppend x'5 y'5)
      (P'.mergeAppend x'6 y'6)
      (P'.mergeAppend x'7 y'7)
      (P'.mergeAppend x'8 y'8)
      (P'.mergeAppend x'9 y'9)
      (P'.mergeAppend x'10 y'10)
      (P'.mergeAppend x'11 y'11)
      (P'.mergeAppend x'12 y'12)
      (P'.mergeAppend x'13 y'13)
      (P'.mergeAppend x'14 y'14)
      (P'.mergeAppend x'15 y'15)
      (P'.mergeAppend x'16 y'16)
      (P'.mergeAppend x'17 y'17)
      (P'.mergeAppend x'18 y'18)
      (P'.mergeAppend x'19 y'19)

instance P'.Default UserState where
  defaultValue
   = UserState P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue

instance P'.Wire UserState where
  wireSize ft' self'@(UserState x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11 x'12 x'13 x'14 x'15 x'16 x'17 x'18 x'19)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size
         = (P'.wireSizeOpt 1 13 x'1 + P'.wireSizeOpt 1 13 x'2 + P'.wireSizeOpt 1 9 x'3 + P'.wireSizeOpt 1 13 x'4 +
             P'.wireSizeOpt 1 13 x'5
             + P'.wireSizeOpt 1 8 x'6
             + P'.wireSizeOpt 1 8 x'7
             + P'.wireSizeOpt 1 8 x'8
             + P'.wireSizeOpt 1 8 x'9
             + P'.wireSizeOpt 1 8 x'10
             + P'.wireSizeOpt 1 12 x'11
             + P'.wireSizeOpt 1 12 x'12
             + P'.wireSizeOpt 1 9 x'13
             + P'.wireSizeOpt 1 9 x'14
             + P'.wireSizeOpt 1 9 x'15
             + P'.wireSizeOpt 2 12 x'16
             + P'.wireSizeOpt 2 12 x'17
             + P'.wireSizeOpt 2 8 x'18
             + P'.wireSizeOpt 2 8 x'19)
  wirePutWithSize ft' self'@(UserState x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11 x'12 x'13 x'14 x'15 x'16 x'17 x'18 x'19)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutOptWithSize 8 13 x'1, P'.wirePutOptWithSize 16 13 x'2, P'.wirePutOptWithSize 26 9 x'3,
             P'.wirePutOptWithSize 32 13 x'4, P'.wirePutOptWithSize 40 13 x'5, P'.wirePutOptWithSize 48 8 x'6,
             P'.wirePutOptWithSize 56 8 x'7, P'.wirePutOptWithSize 64 8 x'8, P'.wirePutOptWithSize 72 8 x'9,
             P'.wirePutOptWithSize 80 8 x'10, P'.wirePutOptWithSize 90 12 x'11, P'.wirePutOptWithSize 98 12 x'12,
             P'.wirePutOptWithSize 106 9 x'13, P'.wirePutOptWithSize 114 9 x'14, P'.wirePutOptWithSize 122 9 x'15,
             P'.wirePutOptWithSize 130 12 x'16, P'.wirePutOptWithSize 138 12 x'17, P'.wirePutOptWithSize 144 8 x'18,
             P'.wirePutOptWithSize 152 8 x'19]
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
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_session = Prelude'.Just new'Field}) (P'.wireGet 13)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_actor = Prelude'.Just new'Field}) (P'.wireGet 13)
             26 -> Prelude'.fmap (\ !new'Field -> old'Self{_name = Prelude'.Just new'Field}) (P'.wireGet 9)
             32 -> Prelude'.fmap (\ !new'Field -> old'Self{_user_id = Prelude'.Just new'Field}) (P'.wireGet 13)
             40 -> Prelude'.fmap (\ !new'Field -> old'Self{_channel_id = Prelude'.Just new'Field}) (P'.wireGet 13)
             48 -> Prelude'.fmap (\ !new'Field -> old'Self{_mute = Prelude'.Just new'Field}) (P'.wireGet 8)
             56 -> Prelude'.fmap (\ !new'Field -> old'Self{_deaf = Prelude'.Just new'Field}) (P'.wireGet 8)
             64 -> Prelude'.fmap (\ !new'Field -> old'Self{_suppress = Prelude'.Just new'Field}) (P'.wireGet 8)
             72 -> Prelude'.fmap (\ !new'Field -> old'Self{_self_mute = Prelude'.Just new'Field}) (P'.wireGet 8)
             80 -> Prelude'.fmap (\ !new'Field -> old'Self{_self_deaf = Prelude'.Just new'Field}) (P'.wireGet 8)
             90 -> Prelude'.fmap (\ !new'Field -> old'Self{_texture = Prelude'.Just new'Field}) (P'.wireGet 12)
             98 -> Prelude'.fmap (\ !new'Field -> old'Self{_plugin_context = Prelude'.Just new'Field}) (P'.wireGet 12)
             106 -> Prelude'.fmap (\ !new'Field -> old'Self{_plugin_identity = Prelude'.Just new'Field}) (P'.wireGet 9)
             114 -> Prelude'.fmap (\ !new'Field -> old'Self{_comment = Prelude'.Just new'Field}) (P'.wireGet 9)
             122 -> Prelude'.fmap (\ !new'Field -> old'Self{_hash = Prelude'.Just new'Field}) (P'.wireGet 9)
             130 -> Prelude'.fmap (\ !new'Field -> old'Self{_comment_hash = Prelude'.Just new'Field}) (P'.wireGet 12)
             138 -> Prelude'.fmap (\ !new'Field -> old'Self{_texture_hash = Prelude'.Just new'Field}) (P'.wireGet 12)
             144 -> Prelude'.fmap (\ !new'Field -> old'Self{_priority_speaker = Prelude'.Just new'Field}) (P'.wireGet 8)
             152 -> Prelude'.fmap (\ !new'Field -> old'Self{_recording = Prelude'.Just new'Field}) (P'.wireGet 8)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> UserState) UserState where
  getVal m' f' = f' m'

instance P'.GPB UserState

instance P'.ReflectDescriptor UserState where
  getMessageInfo _
   = P'.GetMessageInfo (P'.fromDistinctAscList [])
      (P'.fromDistinctAscList [8, 16, 26, 32, 40, 48, 56, 64, 72, 80, 90, 98, 106, 114, 122, 130, 138, 144, 152])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.UserState\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"UserState\"}, descFilePath = [\"Data\",\"MumbleProto\",\"UserState.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.session\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"session\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.actor\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"actor\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.name\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"name\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 26}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.user_id\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"user_id\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 32}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.channel_id\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"channel_id\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 5}, wireTag = WireTag {getWireTag = 40}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.mute\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"mute\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 6}, wireTag = WireTag {getWireTag = 48}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.deaf\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"deaf\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 7}, wireTag = WireTag {getWireTag = 56}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.suppress\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"suppress\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 8}, wireTag = WireTag {getWireTag = 64}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.self_mute\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"self_mute\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 9}, wireTag = WireTag {getWireTag = 72}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.self_deaf\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"self_deaf\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 10}, wireTag = WireTag {getWireTag = 80}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.texture\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"texture\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 11}, wireTag = WireTag {getWireTag = 90}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 12}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.plugin_context\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"plugin_context\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 12}, wireTag = WireTag {getWireTag = 98}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 12}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.plugin_identity\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"plugin_identity\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 13}, wireTag = WireTag {getWireTag = 106}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.comment\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"comment\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 14}, wireTag = WireTag {getWireTag = 114}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.hash\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"hash\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 15}, wireTag = WireTag {getWireTag = 122}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.comment_hash\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"comment_hash\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 16}, wireTag = WireTag {getWireTag = 130}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 12}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.texture_hash\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"texture_hash\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 17}, wireTag = WireTag {getWireTag = 138}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 12}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.priority_speaker\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"priority_speaker\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 18}, wireTag = WireTag {getWireTag = 144}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserState.recording\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserState\"], baseName' = FName \"recording\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 19}, wireTag = WireTag {getWireTag = 152}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType UserState where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg UserState where
  textPut msg
   = do
       P'.tellT "session" (_session msg)
       P'.tellT "actor" (_actor msg)
       P'.tellT "name" (_name msg)
       P'.tellT "user_id" (_user_id msg)
       P'.tellT "channel_id" (_channel_id msg)
       P'.tellT "mute" (_mute msg)
       P'.tellT "deaf" (_deaf msg)
       P'.tellT "suppress" (_suppress msg)
       P'.tellT "self_mute" (_self_mute msg)
       P'.tellT "self_deaf" (_self_deaf msg)
       P'.tellT "texture" (_texture msg)
       P'.tellT "plugin_context" (_plugin_context msg)
       P'.tellT "plugin_identity" (_plugin_identity msg)
       P'.tellT "comment" (_comment msg)
       P'.tellT "hash" (_hash msg)
       P'.tellT "comment_hash" (_comment_hash msg)
       P'.tellT "texture_hash" (_texture_hash msg)
       P'.tellT "priority_speaker" (_priority_speaker msg)
       P'.tellT "recording" (_recording msg)
  textGet
   = do
       mods <- P'.sepEndBy
                (P'.choice
                  [parse'_session, parse'_actor, parse'_name, parse'_user_id, parse'_channel_id, parse'_mute, parse'_deaf,
                   parse'_suppress, parse'_self_mute, parse'_self_deaf, parse'_texture, parse'_plugin_context,
                   parse'_plugin_identity, parse'_comment, parse'_hash, parse'_comment_hash, parse'_texture_hash,
                   parse'_priority_speaker, parse'_recording])
                P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_session
         = P'.try
            (do
               v <- P'.getT "session"
               Prelude'.return (\ o -> o{_session = v}))
        parse'_actor
         = P'.try
            (do
               v <- P'.getT "actor"
               Prelude'.return (\ o -> o{_actor = v}))
        parse'_name
         = P'.try
            (do
               v <- P'.getT "name"
               Prelude'.return (\ o -> o{_name = v}))
        parse'_user_id
         = P'.try
            (do
               v <- P'.getT "user_id"
               Prelude'.return (\ o -> o{_user_id = v}))
        parse'_channel_id
         = P'.try
            (do
               v <- P'.getT "channel_id"
               Prelude'.return (\ o -> o{_channel_id = v}))
        parse'_mute
         = P'.try
            (do
               v <- P'.getT "mute"
               Prelude'.return (\ o -> o{_mute = v}))
        parse'_deaf
         = P'.try
            (do
               v <- P'.getT "deaf"
               Prelude'.return (\ o -> o{_deaf = v}))
        parse'_suppress
         = P'.try
            (do
               v <- P'.getT "suppress"
               Prelude'.return (\ o -> o{_suppress = v}))
        parse'_self_mute
         = P'.try
            (do
               v <- P'.getT "self_mute"
               Prelude'.return (\ o -> o{_self_mute = v}))
        parse'_self_deaf
         = P'.try
            (do
               v <- P'.getT "self_deaf"
               Prelude'.return (\ o -> o{_self_deaf = v}))
        parse'_texture
         = P'.try
            (do
               v <- P'.getT "texture"
               Prelude'.return (\ o -> o{_texture = v}))
        parse'_plugin_context
         = P'.try
            (do
               v <- P'.getT "plugin_context"
               Prelude'.return (\ o -> o{_plugin_context = v}))
        parse'_plugin_identity
         = P'.try
            (do
               v <- P'.getT "plugin_identity"
               Prelude'.return (\ o -> o{_plugin_identity = v}))
        parse'_comment
         = P'.try
            (do
               v <- P'.getT "comment"
               Prelude'.return (\ o -> o{_comment = v}))
        parse'_hash
         = P'.try
            (do
               v <- P'.getT "hash"
               Prelude'.return (\ o -> o{_hash = v}))
        parse'_comment_hash
         = P'.try
            (do
               v <- P'.getT "comment_hash"
               Prelude'.return (\ o -> o{_comment_hash = v}))
        parse'_texture_hash
         = P'.try
            (do
               v <- P'.getT "texture_hash"
               Prelude'.return (\ o -> o{_texture_hash = v}))
        parse'_priority_speaker
         = P'.try
            (do
               v <- P'.getT "priority_speaker"
               Prelude'.return (\ o -> o{_priority_speaker = v}))
        parse'_recording
         = P'.try
            (do
               v <- P'.getT "recording"
               Prelude'.return (\ o -> o{_recording = v}))