{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.Authenticate (Authenticate(..), username, password, tokens, celt_versions, opus) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data Authenticate = Authenticate{_username :: !(P'.Maybe P'.Utf8), _password :: !(P'.Maybe P'.Utf8), _tokens :: !(P'.Seq P'.Utf8),
                                 _celt_versions :: !(P'.Seq P'.Int32), _opus :: !(P'.Maybe P'.Bool)}
                    deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''Authenticate

instance P'.Mergeable Authenticate where
  mergeAppend (Authenticate x'1 x'2 x'3 x'4 x'5) (Authenticate y'1 y'2 y'3 y'4 y'5)
   = Authenticate (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)
      (P'.mergeAppend x'5 y'5)

instance P'.Default Authenticate where
  defaultValue = Authenticate P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue (Prelude'.Just Prelude'.False)

instance P'.Wire Authenticate where
  wireSize ft' self'@(Authenticate x'1 x'2 x'3 x'4 x'5)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size
         = (P'.wireSizeOpt 1 9 x'1 + P'.wireSizeOpt 1 9 x'2 + P'.wireSizeRep 1 9 x'3 + P'.wireSizeRep 1 5 x'4 +
             P'.wireSizeOpt 1 8 x'5)
  wirePutWithSize ft' self'@(Authenticate x'1 x'2 x'3 x'4 x'5)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutOptWithSize 10 9 x'1, P'.wirePutOptWithSize 18 9 x'2, P'.wirePutRepWithSize 26 9 x'3,
             P'.wirePutRepWithSize 32 5 x'4, P'.wirePutOptWithSize 40 8 x'5]
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
             10 -> Prelude'.fmap (\ !new'Field -> old'Self{_username = Prelude'.Just new'Field}) (P'.wireGet 9)
             18 -> Prelude'.fmap (\ !new'Field -> old'Self{_password = Prelude'.Just new'Field}) (P'.wireGet 9)
             26 -> Prelude'.fmap (\ !new'Field -> old'Self{_tokens = P'.append (_tokens old'Self) new'Field}) (P'.wireGet 9)
             32 -> Prelude'.fmap (\ !new'Field -> old'Self{_celt_versions = P'.append (_celt_versions old'Self) new'Field})
                    (P'.wireGet 5)
             34 -> Prelude'.fmap (\ !new'Field -> old'Self{_celt_versions = P'.mergeAppend (_celt_versions old'Self) new'Field})
                    (P'.wireGetPacked 5)
             40 -> Prelude'.fmap (\ !new'Field -> old'Self{_opus = Prelude'.Just new'Field}) (P'.wireGet 8)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> Authenticate) Authenticate where
  getVal m' f' = f' m'

instance P'.GPB Authenticate

instance P'.ReflectDescriptor Authenticate where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [10, 18, 26, 32, 34, 40])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.Authenticate\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"Authenticate\"}, descFilePath = [\"Data\",\"MumbleProto\",\"Authenticate.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Authenticate.username\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Authenticate\"], baseName' = FName \"username\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 10}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Authenticate.password\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Authenticate\"], baseName' = FName \"password\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 18}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Authenticate.tokens\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Authenticate\"], baseName' = FName \"tokens\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 26}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Authenticate.celt_versions\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Authenticate\"], baseName' = FName \"celt_versions\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 32}, packedTag = Just (WireTag {getWireTag = 32},WireTag {getWireTag = 34}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Authenticate.opus\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Authenticate\"], baseName' = FName \"opus\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 5}, wireTag = WireTag {getWireTag = 40}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"false\", hsDefault = Just (HsDef'Bool False)}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType Authenticate where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg Authenticate where
  textPut msg
   = do
       P'.tellT "username" (_username msg)
       P'.tellT "password" (_password msg)
       P'.tellT "tokens" (_tokens msg)
       P'.tellT "celt_versions" (_celt_versions msg)
       P'.tellT "opus" (_opus msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_username, parse'_password, parse'_tokens, parse'_celt_versions, parse'_opus])
                P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_username
         = P'.try
            (do
               v <- P'.getT "username"
               Prelude'.return (\ o -> o{_username = v}))
        parse'_password
         = P'.try
            (do
               v <- P'.getT "password"
               Prelude'.return (\ o -> o{_password = v}))
        parse'_tokens
         = P'.try
            (do
               v <- P'.getT "tokens"
               Prelude'.return (\ o -> o{_tokens = P'.append (_tokens o) v}))
        parse'_celt_versions
         = P'.try
            (do
               v <- P'.getT "celt_versions"
               Prelude'.return (\ o -> o{_celt_versions = P'.append (_celt_versions o) v}))
        parse'_opus
         = P'.try
            (do
               v <- P'.getT "opus"
               Prelude'.return (\ o -> o{_opus = v}))