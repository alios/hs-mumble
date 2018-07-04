{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.ContextAction (ContextAction(..), session, channel_id, action) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data ContextAction = ContextAction{_session :: !(P'.Maybe P'.Word32), _channel_id :: !(P'.Maybe P'.Word32), _action :: !(P'.Utf8)}
                     deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''ContextAction

instance P'.Mergeable ContextAction where
  mergeAppend (ContextAction x'1 x'2 x'3) (ContextAction y'1 y'2 y'3)
   = ContextAction (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3)

instance P'.Default ContextAction where
  defaultValue = ContextAction P'.defaultValue P'.defaultValue P'.defaultValue

instance P'.Wire ContextAction where
  wireSize ft' self'@(ContextAction x'1 x'2 x'3)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeOpt 1 13 x'1 + P'.wireSizeOpt 1 13 x'2 + P'.wireSizeReq 1 9 x'3)
  wirePutWithSize ft' self'@(ContextAction x'1 x'2 x'3)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize [P'.wirePutOptWithSize 8 13 x'1, P'.wirePutOptWithSize 16 13 x'2, P'.wirePutReqWithSize 26 9 x'3]
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
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_channel_id = Prelude'.Just new'Field}) (P'.wireGet 13)
             26 -> Prelude'.fmap (\ !new'Field -> old'Self{_action = new'Field}) (P'.wireGet 9)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> ContextAction) ContextAction where
  getVal m' f' = f' m'

instance P'.GPB ContextAction

instance P'.ReflectDescriptor ContextAction where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList [26]) (P'.fromDistinctAscList [8, 16, 26])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.ContextAction\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"ContextAction\"}, descFilePath = [\"Data\",\"MumbleProto\",\"ContextAction.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ContextAction.session\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ContextAction\"], baseName' = FName \"session\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ContextAction.channel_id\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ContextAction\"], baseName' = FName \"channel_id\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ContextAction.action\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ContextAction\"], baseName' = FName \"action\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 26}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType ContextAction where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg ContextAction where
  textPut msg
   = do
       P'.tellT "session" (_session msg)
       P'.tellT "channel_id" (_channel_id msg)
       P'.tellT "action" (_action msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_session, parse'_channel_id, parse'_action]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_session
         = P'.try
            (do
               v <- P'.getT "session"
               Prelude'.return (\ o -> o{_session = v}))
        parse'_channel_id
         = P'.try
            (do
               v <- P'.getT "channel_id"
               Prelude'.return (\ o -> o{_channel_id = v}))
        parse'_action
         = P'.try
            (do
               v <- P'.getT "action"
               Prelude'.return (\ o -> o{_action = v}))