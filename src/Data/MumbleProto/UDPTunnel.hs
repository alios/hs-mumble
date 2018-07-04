{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.UDPTunnel (UDPTunnel(..), packet) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data UDPTunnel = UDPTunnel{_packet :: !(P'.ByteString)}
                 deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''UDPTunnel

instance P'.Mergeable UDPTunnel where
  mergeAppend (UDPTunnel x'1) (UDPTunnel y'1) = UDPTunnel (P'.mergeAppend x'1 y'1)

instance P'.Default UDPTunnel where
  defaultValue = UDPTunnel P'.defaultValue

instance P'.Wire UDPTunnel where
  wireSize ft' self'@(UDPTunnel x'1)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeReq 1 12 x'1)
  wirePutWithSize ft' self'@(UDPTunnel x'1)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields = P'.sequencePutWithSize [P'.wirePutReqWithSize 10 12 x'1]
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
             10 -> Prelude'.fmap (\ !new'Field -> old'Self{_packet = new'Field}) (P'.wireGet 12)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> UDPTunnel) UDPTunnel where
  getVal m' f' = f' m'

instance P'.GPB UDPTunnel

instance P'.ReflectDescriptor UDPTunnel where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList [10]) (P'.fromDistinctAscList [10])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.UDPTunnel\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"UDPTunnel\"}, descFilePath = [\"Data\",\"MumbleProto\",\"UDPTunnel.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UDPTunnel.packet\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UDPTunnel\"], baseName' = FName \"packet\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 10}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 12}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType UDPTunnel where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg UDPTunnel where
  textPut msg
   = do
       P'.tellT "packet" (_packet msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_packet]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_packet
         = P'.try
            (do
               v <- P'.getT "packet"
               Prelude'.return (\ o -> o{_packet = v}))