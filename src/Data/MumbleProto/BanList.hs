{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.BanList (BanList(..), bans, query) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH
import qualified Data.MumbleProto.BanList.BanEntry as MumbleProto.BanList (BanEntry)

data BanList = BanList{_bans :: !(P'.Seq MumbleProto.BanList.BanEntry), _query :: !(P'.Maybe P'.Bool)}
               deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''BanList

instance P'.Mergeable BanList where
  mergeAppend (BanList x'1 x'2) (BanList y'1 y'2) = BanList (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2)

instance P'.Default BanList where
  defaultValue = BanList P'.defaultValue (Prelude'.Just Prelude'.False)

instance P'.Wire BanList where
  wireSize ft' self'@(BanList x'1 x'2)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeRep 1 11 x'1 + P'.wireSizeOpt 1 8 x'2)
  wirePutWithSize ft' self'@(BanList x'1 x'2)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields = P'.sequencePutWithSize [P'.wirePutRepWithSize 10 11 x'1, P'.wirePutOptWithSize 16 8 x'2]
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
             10 -> Prelude'.fmap (\ !new'Field -> old'Self{_bans = P'.append (_bans old'Self) new'Field}) (P'.wireGet 11)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_query = Prelude'.Just new'Field}) (P'.wireGet 8)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> BanList) BanList where
  getVal m' f' = f' m'

instance P'.GPB BanList

instance P'.ReflectDescriptor BanList where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [10, 16])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.BanList\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"BanList\"}, descFilePath = [\"Data\",\"MumbleProto\",\"BanList.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.BanList.bans\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"BanList\"], baseName' = FName \"bans\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 10}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".MumbleProto.BanList.BanEntry\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\",MName \"BanList\"], baseName = MName \"BanEntry\"}), hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.BanList.query\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"BanList\"], baseName' = FName \"query\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"false\", hsDefault = Just (HsDef'Bool False)}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType BanList where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg BanList where
  textPut msg
   = do
       P'.tellT "bans" (_bans msg)
       P'.tellT "query" (_query msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_bans, parse'_query]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_bans
         = P'.try
            (do
               v <- P'.getT "bans"
               Prelude'.return (\ o -> o{_bans = P'.append (_bans o) v}))
        parse'_query
         = P'.try
            (do
               v <- P'.getT "query"
               Prelude'.return (\ o -> o{_query = v}))