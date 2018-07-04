{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.VoiceTarget (VoiceTarget(..), id, targets) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH
import qualified Data.MumbleProto.VoiceTarget.Target as MumbleProto.VoiceTarget (Target)

data VoiceTarget = VoiceTarget{_id :: !(P'.Maybe P'.Word32), _targets :: !(P'.Seq MumbleProto.VoiceTarget.Target)}
                   deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''VoiceTarget

instance P'.Mergeable VoiceTarget where
  mergeAppend (VoiceTarget x'1 x'2) (VoiceTarget y'1 y'2) = VoiceTarget (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2)

instance P'.Default VoiceTarget where
  defaultValue = VoiceTarget P'.defaultValue P'.defaultValue

instance P'.Wire VoiceTarget where
  wireSize ft' self'@(VoiceTarget x'1 x'2)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeOpt 1 13 x'1 + P'.wireSizeRep 1 11 x'2)
  wirePutWithSize ft' self'@(VoiceTarget x'1 x'2)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields = P'.sequencePutWithSize [P'.wirePutOptWithSize 8 13 x'1, P'.wirePutRepWithSize 18 11 x'2]
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
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_id = Prelude'.Just new'Field}) (P'.wireGet 13)
             18 -> Prelude'.fmap (\ !new'Field -> old'Self{_targets = P'.append (_targets old'Self) new'Field}) (P'.wireGet 11)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> VoiceTarget) VoiceTarget where
  getVal m' f' = f' m'

instance P'.GPB VoiceTarget

instance P'.ReflectDescriptor VoiceTarget where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [8, 18])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.VoiceTarget\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"VoiceTarget\"}, descFilePath = [\"Data\",\"MumbleProto\",\"VoiceTarget.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.VoiceTarget.id\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"VoiceTarget\"], baseName' = FName \"id\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.VoiceTarget.targets\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"VoiceTarget\"], baseName' = FName \"targets\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 18}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".MumbleProto.VoiceTarget.Target\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\",MName \"VoiceTarget\"], baseName = MName \"Target\"}), hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType VoiceTarget where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg VoiceTarget where
  textPut msg
   = do
       P'.tellT "id" (_id msg)
       P'.tellT "targets" (_targets msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_id, parse'_targets]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_id
         = P'.try
            (do
               v <- P'.getT "id"
               Prelude'.return (\ o -> o{_id = v}))
        parse'_targets
         = P'.try
            (do
               v <- P'.getT "targets"
               Prelude'.return (\ o -> o{_targets = P'.append (_targets o) v}))