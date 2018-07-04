{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.CryptSetup (CryptSetup(..), key, client_nonce, server_nonce) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data CryptSetup = CryptSetup{_key :: !(P'.Maybe P'.ByteString), _client_nonce :: !(P'.Maybe P'.ByteString),
                             _server_nonce :: !(P'.Maybe P'.ByteString)}
                  deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''CryptSetup

instance P'.Mergeable CryptSetup where
  mergeAppend (CryptSetup x'1 x'2 x'3) (CryptSetup y'1 y'2 y'3)
   = CryptSetup (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3)

instance P'.Default CryptSetup where
  defaultValue = CryptSetup P'.defaultValue P'.defaultValue P'.defaultValue

instance P'.Wire CryptSetup where
  wireSize ft' self'@(CryptSetup x'1 x'2 x'3)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeOpt 1 12 x'1 + P'.wireSizeOpt 1 12 x'2 + P'.wireSizeOpt 1 12 x'3)
  wirePutWithSize ft' self'@(CryptSetup x'1 x'2 x'3)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutOptWithSize 10 12 x'1, P'.wirePutOptWithSize 18 12 x'2, P'.wirePutOptWithSize 26 12 x'3]
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
             10 -> Prelude'.fmap (\ !new'Field -> old'Self{_key = Prelude'.Just new'Field}) (P'.wireGet 12)
             18 -> Prelude'.fmap (\ !new'Field -> old'Self{_client_nonce = Prelude'.Just new'Field}) (P'.wireGet 12)
             26 -> Prelude'.fmap (\ !new'Field -> old'Self{_server_nonce = Prelude'.Just new'Field}) (P'.wireGet 12)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> CryptSetup) CryptSetup where
  getVal m' f' = f' m'

instance P'.GPB CryptSetup

instance P'.ReflectDescriptor CryptSetup where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [10, 18, 26])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.CryptSetup\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"CryptSetup\"}, descFilePath = [\"Data\",\"MumbleProto\",\"CryptSetup.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.CryptSetup.key\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"CryptSetup\"], baseName' = FName \"key\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 10}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 12}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.CryptSetup.client_nonce\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"CryptSetup\"], baseName' = FName \"client_nonce\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 18}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 12}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.CryptSetup.server_nonce\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"CryptSetup\"], baseName' = FName \"server_nonce\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 26}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 12}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType CryptSetup where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg CryptSetup where
  textPut msg
   = do
       P'.tellT "key" (_key msg)
       P'.tellT "client_nonce" (_client_nonce msg)
       P'.tellT "server_nonce" (_server_nonce msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_key, parse'_client_nonce, parse'_server_nonce]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_key
         = P'.try
            (do
               v <- P'.getT "key"
               Prelude'.return (\ o -> o{_key = v}))
        parse'_client_nonce
         = P'.try
            (do
               v <- P'.getT "client_nonce"
               Prelude'.return (\ o -> o{_client_nonce = v}))
        parse'_server_nonce
         = P'.try
            (do
               v <- P'.getT "server_nonce"
               Prelude'.return (\ o -> o{_server_nonce = v}))