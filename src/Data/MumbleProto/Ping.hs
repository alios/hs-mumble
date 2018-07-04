{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.Ping
       (Ping(..), timestamp, good, late, lost, resync, udp_packets, tcp_packets, udp_ping_avg, udp_ping_var, tcp_ping_avg,
        tcp_ping_var)
       where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data Ping = Ping{_timestamp :: !(P'.Maybe P'.Word64), _good :: !(P'.Maybe P'.Word32), _late :: !(P'.Maybe P'.Word32),
                 _lost :: !(P'.Maybe P'.Word32), _resync :: !(P'.Maybe P'.Word32), _udp_packets :: !(P'.Maybe P'.Word32),
                 _tcp_packets :: !(P'.Maybe P'.Word32), _udp_ping_avg :: !(P'.Maybe P'.Float),
                 _udp_ping_var :: !(P'.Maybe P'.Float), _tcp_ping_avg :: !(P'.Maybe P'.Float),
                 _tcp_ping_var :: !(P'.Maybe P'.Float)}
            deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''Ping

instance P'.Mergeable Ping where
  mergeAppend (Ping x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11) (Ping y'1 y'2 y'3 y'4 y'5 y'6 y'7 y'8 y'9 y'10 y'11)
   = Ping (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)
      (P'.mergeAppend x'5 y'5)
      (P'.mergeAppend x'6 y'6)
      (P'.mergeAppend x'7 y'7)
      (P'.mergeAppend x'8 y'8)
      (P'.mergeAppend x'9 y'9)
      (P'.mergeAppend x'10 y'10)
      (P'.mergeAppend x'11 y'11)

instance P'.Default Ping where
  defaultValue
   = Ping P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue

instance P'.Wire Ping where
  wireSize ft' self'@(Ping x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size
         = (P'.wireSizeOpt 1 4 x'1 + P'.wireSizeOpt 1 13 x'2 + P'.wireSizeOpt 1 13 x'3 + P'.wireSizeOpt 1 13 x'4 +
             P'.wireSizeOpt 1 13 x'5
             + P'.wireSizeOpt 1 13 x'6
             + P'.wireSizeOpt 1 13 x'7
             + P'.wireSizeOpt 1 2 x'8
             + P'.wireSizeOpt 1 2 x'9
             + P'.wireSizeOpt 1 2 x'10
             + P'.wireSizeOpt 1 2 x'11)
  wirePutWithSize ft' self'@(Ping x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutOptWithSize 8 4 x'1, P'.wirePutOptWithSize 16 13 x'2, P'.wirePutOptWithSize 24 13 x'3,
             P'.wirePutOptWithSize 32 13 x'4, P'.wirePutOptWithSize 40 13 x'5, P'.wirePutOptWithSize 48 13 x'6,
             P'.wirePutOptWithSize 56 13 x'7, P'.wirePutOptWithSize 69 2 x'8, P'.wirePutOptWithSize 77 2 x'9,
             P'.wirePutOptWithSize 85 2 x'10, P'.wirePutOptWithSize 93 2 x'11]
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
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_timestamp = Prelude'.Just new'Field}) (P'.wireGet 4)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_good = Prelude'.Just new'Field}) (P'.wireGet 13)
             24 -> Prelude'.fmap (\ !new'Field -> old'Self{_late = Prelude'.Just new'Field}) (P'.wireGet 13)
             32 -> Prelude'.fmap (\ !new'Field -> old'Self{_lost = Prelude'.Just new'Field}) (P'.wireGet 13)
             40 -> Prelude'.fmap (\ !new'Field -> old'Self{_resync = Prelude'.Just new'Field}) (P'.wireGet 13)
             48 -> Prelude'.fmap (\ !new'Field -> old'Self{_udp_packets = Prelude'.Just new'Field}) (P'.wireGet 13)
             56 -> Prelude'.fmap (\ !new'Field -> old'Self{_tcp_packets = Prelude'.Just new'Field}) (P'.wireGet 13)
             69 -> Prelude'.fmap (\ !new'Field -> old'Self{_udp_ping_avg = Prelude'.Just new'Field}) (P'.wireGet 2)
             77 -> Prelude'.fmap (\ !new'Field -> old'Self{_udp_ping_var = Prelude'.Just new'Field}) (P'.wireGet 2)
             85 -> Prelude'.fmap (\ !new'Field -> old'Self{_tcp_ping_avg = Prelude'.Just new'Field}) (P'.wireGet 2)
             93 -> Prelude'.fmap (\ !new'Field -> old'Self{_tcp_ping_var = Prelude'.Just new'Field}) (P'.wireGet 2)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> Ping) Ping where
  getVal m' f' = f' m'

instance P'.GPB Ping

instance P'.ReflectDescriptor Ping where
  getMessageInfo _
   = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [8, 16, 24, 32, 40, 48, 56, 69, 77, 85, 93])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.Ping\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"Ping\"}, descFilePath = [\"Data\",\"MumbleProto\",\"Ping.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Ping.timestamp\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Ping\"], baseName' = FName \"timestamp\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 4}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Ping.good\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Ping\"], baseName' = FName \"good\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Ping.late\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Ping\"], baseName' = FName \"late\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 24}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Ping.lost\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Ping\"], baseName' = FName \"lost\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 32}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Ping.resync\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Ping\"], baseName' = FName \"resync\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 5}, wireTag = WireTag {getWireTag = 40}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Ping.udp_packets\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Ping\"], baseName' = FName \"udp_packets\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 6}, wireTag = WireTag {getWireTag = 48}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Ping.tcp_packets\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Ping\"], baseName' = FName \"tcp_packets\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 7}, wireTag = WireTag {getWireTag = 56}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Ping.udp_ping_avg\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Ping\"], baseName' = FName \"udp_ping_avg\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 8}, wireTag = WireTag {getWireTag = 69}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 2}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Ping.udp_ping_var\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Ping\"], baseName' = FName \"udp_ping_var\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 9}, wireTag = WireTag {getWireTag = 77}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 2}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Ping.tcp_ping_avg\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Ping\"], baseName' = FName \"tcp_ping_avg\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 10}, wireTag = WireTag {getWireTag = 85}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 2}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.Ping.tcp_ping_var\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"Ping\"], baseName' = FName \"tcp_ping_var\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 11}, wireTag = WireTag {getWireTag = 93}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 2}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType Ping where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg Ping where
  textPut msg
   = do
       P'.tellT "timestamp" (_timestamp msg)
       P'.tellT "good" (_good msg)
       P'.tellT "late" (_late msg)
       P'.tellT "lost" (_lost msg)
       P'.tellT "resync" (_resync msg)
       P'.tellT "udp_packets" (_udp_packets msg)
       P'.tellT "tcp_packets" (_tcp_packets msg)
       P'.tellT "udp_ping_avg" (_udp_ping_avg msg)
       P'.tellT "udp_ping_var" (_udp_ping_var msg)
       P'.tellT "tcp_ping_avg" (_tcp_ping_avg msg)
       P'.tellT "tcp_ping_var" (_tcp_ping_var msg)
  textGet
   = do
       mods <- P'.sepEndBy
                (P'.choice
                  [parse'_timestamp, parse'_good, parse'_late, parse'_lost, parse'_resync, parse'_udp_packets, parse'_tcp_packets,
                   parse'_udp_ping_avg, parse'_udp_ping_var, parse'_tcp_ping_avg, parse'_tcp_ping_var])
                P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_timestamp
         = P'.try
            (do
               v <- P'.getT "timestamp"
               Prelude'.return (\ o -> o{_timestamp = v}))
        parse'_good
         = P'.try
            (do
               v <- P'.getT "good"
               Prelude'.return (\ o -> o{_good = v}))
        parse'_late
         = P'.try
            (do
               v <- P'.getT "late"
               Prelude'.return (\ o -> o{_late = v}))
        parse'_lost
         = P'.try
            (do
               v <- P'.getT "lost"
               Prelude'.return (\ o -> o{_lost = v}))
        parse'_resync
         = P'.try
            (do
               v <- P'.getT "resync"
               Prelude'.return (\ o -> o{_resync = v}))
        parse'_udp_packets
         = P'.try
            (do
               v <- P'.getT "udp_packets"
               Prelude'.return (\ o -> o{_udp_packets = v}))
        parse'_tcp_packets
         = P'.try
            (do
               v <- P'.getT "tcp_packets"
               Prelude'.return (\ o -> o{_tcp_packets = v}))
        parse'_udp_ping_avg
         = P'.try
            (do
               v <- P'.getT "udp_ping_avg"
               Prelude'.return (\ o -> o{_udp_ping_avg = v}))
        parse'_udp_ping_var
         = P'.try
            (do
               v <- P'.getT "udp_ping_var"
               Prelude'.return (\ o -> o{_udp_ping_var = v}))
        parse'_tcp_ping_avg
         = P'.try
            (do
               v <- P'.getT "tcp_ping_avg"
               Prelude'.return (\ o -> o{_tcp_ping_avg = v}))
        parse'_tcp_ping_var
         = P'.try
            (do
               v <- P'.getT "tcp_ping_var"
               Prelude'.return (\ o -> o{_tcp_ping_var = v}))