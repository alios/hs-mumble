{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.SuggestConfig (SuggestConfig(..), version, positional, push_to_talk) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data SuggestConfig = SuggestConfig{_version :: !(P'.Maybe P'.Word32), _positional :: !(P'.Maybe P'.Bool),
                                   _push_to_talk :: !(P'.Maybe P'.Bool)}
                     deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''SuggestConfig

instance P'.Mergeable SuggestConfig where
  mergeAppend (SuggestConfig x'1 x'2 x'3) (SuggestConfig y'1 y'2 y'3)
   = SuggestConfig (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3)

instance P'.Default SuggestConfig where
  defaultValue = SuggestConfig P'.defaultValue P'.defaultValue P'.defaultValue

instance P'.Wire SuggestConfig where
  wireSize ft' self'@(SuggestConfig x'1 x'2 x'3)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeOpt 1 13 x'1 + P'.wireSizeOpt 1 8 x'2 + P'.wireSizeOpt 1 8 x'3)
  wirePutWithSize ft' self'@(SuggestConfig x'1 x'2 x'3)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize [P'.wirePutOptWithSize 8 13 x'1, P'.wirePutOptWithSize 16 8 x'2, P'.wirePutOptWithSize 24 8 x'3]
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
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_version = Prelude'.Just new'Field}) (P'.wireGet 13)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_positional = Prelude'.Just new'Field}) (P'.wireGet 8)
             24 -> Prelude'.fmap (\ !new'Field -> old'Self{_push_to_talk = Prelude'.Just new'Field}) (P'.wireGet 8)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> SuggestConfig) SuggestConfig where
  getVal m' f' = f' m'

instance P'.GPB SuggestConfig

instance P'.ReflectDescriptor SuggestConfig where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [8, 16, 24])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.SuggestConfig\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"SuggestConfig\"}, descFilePath = [\"Data\",\"MumbleProto\",\"SuggestConfig.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.SuggestConfig.version\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"SuggestConfig\"], baseName' = FName \"version\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.SuggestConfig.positional\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"SuggestConfig\"], baseName' = FName \"positional\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.SuggestConfig.push_to_talk\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"SuggestConfig\"], baseName' = FName \"push_to_talk\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 24}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType SuggestConfig where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg SuggestConfig where
  textPut msg
   = do
       P'.tellT "version" (_version msg)
       P'.tellT "positional" (_positional msg)
       P'.tellT "push_to_talk" (_push_to_talk msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_version, parse'_positional, parse'_push_to_talk]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_version
         = P'.try
            (do
               v <- P'.getT "version"
               Prelude'.return (\ o -> o{_version = v}))
        parse'_positional
         = P'.try
            (do
               v <- P'.getT "positional"
               Prelude'.return (\ o -> o{_positional = v}))
        parse'_push_to_talk
         = P'.try
            (do
               v <- P'.getT "push_to_talk"
               Prelude'.return (\ o -> o{_push_to_talk = v}))