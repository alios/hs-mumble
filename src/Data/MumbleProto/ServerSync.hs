{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.ServerSync (ServerSync(..), session, max_bandwidth, welcome_text, permissions) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data ServerSync = ServerSync{_session :: !(P'.Maybe P'.Word32), _max_bandwidth :: !(P'.Maybe P'.Word32),
                             _welcome_text :: !(P'.Maybe P'.Utf8), _permissions :: !(P'.Maybe P'.Word64)}
                  deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''ServerSync

instance P'.Mergeable ServerSync where
  mergeAppend (ServerSync x'1 x'2 x'3 x'4) (ServerSync y'1 y'2 y'3 y'4)
   = ServerSync (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)

instance P'.Default ServerSync where
  defaultValue = ServerSync P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue

instance P'.Wire ServerSync where
  wireSize ft' self'@(ServerSync x'1 x'2 x'3 x'4)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeOpt 1 13 x'1 + P'.wireSizeOpt 1 13 x'2 + P'.wireSizeOpt 1 9 x'3 + P'.wireSizeOpt 1 4 x'4)
  wirePutWithSize ft' self'@(ServerSync x'1 x'2 x'3 x'4)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutOptWithSize 8 13 x'1, P'.wirePutOptWithSize 16 13 x'2, P'.wirePutOptWithSize 26 9 x'3,
             P'.wirePutOptWithSize 32 4 x'4]
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
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_max_bandwidth = Prelude'.Just new'Field}) (P'.wireGet 13)
             26 -> Prelude'.fmap (\ !new'Field -> old'Self{_welcome_text = Prelude'.Just new'Field}) (P'.wireGet 9)
             32 -> Prelude'.fmap (\ !new'Field -> old'Self{_permissions = Prelude'.Just new'Field}) (P'.wireGet 4)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> ServerSync) ServerSync where
  getVal m' f' = f' m'

instance P'.GPB ServerSync

instance P'.ReflectDescriptor ServerSync where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [8, 16, 26, 32])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.ServerSync\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"ServerSync\"}, descFilePath = [\"Data\",\"MumbleProto\",\"ServerSync.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ServerSync.session\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ServerSync\"], baseName' = FName \"session\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ServerSync.max_bandwidth\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ServerSync\"], baseName' = FName \"max_bandwidth\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ServerSync.welcome_text\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ServerSync\"], baseName' = FName \"welcome_text\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 26}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.ServerSync.permissions\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"ServerSync\"], baseName' = FName \"permissions\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 32}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 4}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType ServerSync where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg ServerSync where
  textPut msg
   = do
       P'.tellT "session" (_session msg)
       P'.tellT "max_bandwidth" (_max_bandwidth msg)
       P'.tellT "welcome_text" (_welcome_text msg)
       P'.tellT "permissions" (_permissions msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_session, parse'_max_bandwidth, parse'_welcome_text, parse'_permissions]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_session
         = P'.try
            (do
               v <- P'.getT "session"
               Prelude'.return (\ o -> o{_session = v}))
        parse'_max_bandwidth
         = P'.try
            (do
               v <- P'.getT "max_bandwidth"
               Prelude'.return (\ o -> o{_max_bandwidth = v}))
        parse'_welcome_text
         = P'.try
            (do
               v <- P'.getT "welcome_text"
               Prelude'.return (\ o -> o{_welcome_text = v}))
        parse'_permissions
         = P'.try
            (do
               v <- P'.getT "permissions"
               Prelude'.return (\ o -> o{_permissions = v}))