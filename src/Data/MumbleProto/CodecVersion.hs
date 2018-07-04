{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.CodecVersion (CodecVersion(..), alpha, beta, prefer_alpha, opus) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data CodecVersion = CodecVersion{_alpha :: !(P'.Int32), _beta :: !(P'.Int32), _prefer_alpha :: !(P'.Bool),
                                 _opus :: !(P'.Maybe P'.Bool)}
                    deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''CodecVersion

instance P'.Mergeable CodecVersion where
  mergeAppend (CodecVersion x'1 x'2 x'3 x'4) (CodecVersion y'1 y'2 y'3 y'4)
   = CodecVersion (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)

instance P'.Default CodecVersion where
  defaultValue = CodecVersion P'.defaultValue P'.defaultValue Prelude'.True (Prelude'.Just Prelude'.False)

instance P'.Wire CodecVersion where
  wireSize ft' self'@(CodecVersion x'1 x'2 x'3 x'4)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeReq 1 5 x'1 + P'.wireSizeReq 1 5 x'2 + P'.wireSizeReq 1 8 x'3 + P'.wireSizeOpt 1 8 x'4)
  wirePutWithSize ft' self'@(CodecVersion x'1 x'2 x'3 x'4)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutReqWithSize 8 5 x'1, P'.wirePutReqWithSize 16 5 x'2, P'.wirePutReqWithSize 24 8 x'3,
             P'.wirePutOptWithSize 32 8 x'4]
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
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_alpha = new'Field}) (P'.wireGet 5)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_beta = new'Field}) (P'.wireGet 5)
             24 -> Prelude'.fmap (\ !new'Field -> old'Self{_prefer_alpha = new'Field}) (P'.wireGet 8)
             32 -> Prelude'.fmap (\ !new'Field -> old'Self{_opus = Prelude'.Just new'Field}) (P'.wireGet 8)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> CodecVersion) CodecVersion where
  getVal m' f' = f' m'

instance P'.GPB CodecVersion

instance P'.ReflectDescriptor CodecVersion where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList [8, 16, 24]) (P'.fromDistinctAscList [8, 16, 24, 32])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.CodecVersion\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"CodecVersion\"}, descFilePath = [\"Data\",\"MumbleProto\",\"CodecVersion.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.CodecVersion.alpha\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"CodecVersion\"], baseName' = FName \"alpha\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.CodecVersion.beta\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"CodecVersion\"], baseName' = FName \"beta\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.CodecVersion.prefer_alpha\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"CodecVersion\"], baseName' = FName \"prefer_alpha\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 24}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"true\", hsDefault = Just (HsDef'Bool True)},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.CodecVersion.opus\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"CodecVersion\"], baseName' = FName \"opus\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 32}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"false\", hsDefault = Just (HsDef'Bool False)}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType CodecVersion where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg CodecVersion where
  textPut msg
   = do
       P'.tellT "alpha" (_alpha msg)
       P'.tellT "beta" (_beta msg)
       P'.tellT "prefer_alpha" (_prefer_alpha msg)
       P'.tellT "opus" (_opus msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_alpha, parse'_beta, parse'_prefer_alpha, parse'_opus]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_alpha
         = P'.try
            (do
               v <- P'.getT "alpha"
               Prelude'.return (\ o -> o{_alpha = v}))
        parse'_beta
         = P'.try
            (do
               v <- P'.getT "beta"
               Prelude'.return (\ o -> o{_beta = v}))
        parse'_prefer_alpha
         = P'.try
            (do
               v <- P'.getT "prefer_alpha"
               Prelude'.return (\ o -> o{_prefer_alpha = v}))
        parse'_opus
         = P'.try
            (do
               v <- P'.getT "opus"
               Prelude'.return (\ o -> o{_opus = v}))