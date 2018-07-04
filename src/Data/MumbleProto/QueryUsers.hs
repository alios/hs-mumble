{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.QueryUsers (QueryUsers(..), ids, names) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data QueryUsers = QueryUsers{_ids :: !(P'.Seq P'.Word32), _names :: !(P'.Seq P'.Utf8)}
                  deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''QueryUsers

instance P'.Mergeable QueryUsers where
  mergeAppend (QueryUsers x'1 x'2) (QueryUsers y'1 y'2) = QueryUsers (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2)

instance P'.Default QueryUsers where
  defaultValue = QueryUsers P'.defaultValue P'.defaultValue

instance P'.Wire QueryUsers where
  wireSize ft' self'@(QueryUsers x'1 x'2)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeRep 1 13 x'1 + P'.wireSizeRep 1 9 x'2)
  wirePutWithSize ft' self'@(QueryUsers x'1 x'2)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields = P'.sequencePutWithSize [P'.wirePutRepWithSize 8 13 x'1, P'.wirePutRepWithSize 18 9 x'2]
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
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_ids = P'.append (_ids old'Self) new'Field}) (P'.wireGet 13)
             10 -> Prelude'.fmap (\ !new'Field -> old'Self{_ids = P'.mergeAppend (_ids old'Self) new'Field}) (P'.wireGetPacked 13)
             18 -> Prelude'.fmap (\ !new'Field -> old'Self{_names = P'.append (_names old'Self) new'Field}) (P'.wireGet 9)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> QueryUsers) QueryUsers where
  getVal m' f' = f' m'

instance P'.GPB QueryUsers

instance P'.ReflectDescriptor QueryUsers where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [8, 10, 18])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.QueryUsers\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"QueryUsers\"}, descFilePath = [\"Data\",\"MumbleProto\",\"QueryUsers.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.QueryUsers.ids\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"QueryUsers\"], baseName' = FName \"ids\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Just (WireTag {getWireTag = 8},WireTag {getWireTag = 10}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.QueryUsers.names\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"QueryUsers\"], baseName' = FName \"names\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 18}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType QueryUsers where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg QueryUsers where
  textPut msg
   = do
       P'.tellT "ids" (_ids msg)
       P'.tellT "names" (_names msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_ids, parse'_names]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_ids
         = P'.try
            (do
               v <- P'.getT "ids"
               Prelude'.return (\ o -> o{_ids = P'.append (_ids o) v}))
        parse'_names
         = P'.try
            (do
               v <- P'.getT "names"
               Prelude'.return (\ o -> o{_names = P'.append (_names o) v}))