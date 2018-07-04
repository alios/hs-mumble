{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.UserStats
       (UserStats(..), session, stats_only, certificates, from_client, from_server, udp_packets, tcp_packets, udp_ping_avg,
        udp_ping_var, tcp_ping_avg, tcp_ping_var, version, celt_versions, address, bandwidth, onlinesecs, idlesecs,
        strong_certificate, opus)
       where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH
import qualified Data.MumbleProto.UserStats.Stats as MumbleProto.UserStats (Stats)
import qualified Data.MumbleProto.Version as MumbleProto (Version)

data UserStats = UserStats{_session :: !(P'.Maybe P'.Word32), _stats_only :: !(P'.Maybe P'.Bool),
                           _certificates :: !(P'.Seq P'.ByteString), _from_client :: !(P'.Maybe MumbleProto.UserStats.Stats),
                           _from_server :: !(P'.Maybe MumbleProto.UserStats.Stats), _udp_packets :: !(P'.Maybe P'.Word32),
                           _tcp_packets :: !(P'.Maybe P'.Word32), _udp_ping_avg :: !(P'.Maybe P'.Float),
                           _udp_ping_var :: !(P'.Maybe P'.Float), _tcp_ping_avg :: !(P'.Maybe P'.Float),
                           _tcp_ping_var :: !(P'.Maybe P'.Float), _version :: !(P'.Maybe MumbleProto.Version),
                           _celt_versions :: !(P'.Seq P'.Int32), _address :: !(P'.Maybe P'.ByteString),
                           _bandwidth :: !(P'.Maybe P'.Word32), _onlinesecs :: !(P'.Maybe P'.Word32),
                           _idlesecs :: !(P'.Maybe P'.Word32), _strong_certificate :: !(P'.Maybe P'.Bool),
                           _opus :: !(P'.Maybe P'.Bool)}
                 deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''UserStats

instance P'.Mergeable UserStats where
  mergeAppend (UserStats x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11 x'12 x'13 x'14 x'15 x'16 x'17 x'18 x'19)
   (UserStats y'1 y'2 y'3 y'4 y'5 y'6 y'7 y'8 y'9 y'10 y'11 y'12 y'13 y'14 y'15 y'16 y'17 y'18 y'19)
   = UserStats (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)
      (P'.mergeAppend x'5 y'5)
      (P'.mergeAppend x'6 y'6)
      (P'.mergeAppend x'7 y'7)
      (P'.mergeAppend x'8 y'8)
      (P'.mergeAppend x'9 y'9)
      (P'.mergeAppend x'10 y'10)
      (P'.mergeAppend x'11 y'11)
      (P'.mergeAppend x'12 y'12)
      (P'.mergeAppend x'13 y'13)
      (P'.mergeAppend x'14 y'14)
      (P'.mergeAppend x'15 y'15)
      (P'.mergeAppend x'16 y'16)
      (P'.mergeAppend x'17 y'17)
      (P'.mergeAppend x'18 y'18)
      (P'.mergeAppend x'19 y'19)

instance P'.Default UserStats where
  defaultValue
   = UserStats P'.defaultValue (Prelude'.Just Prelude'.False) P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      P'.defaultValue
      (Prelude'.Just Prelude'.False)
      (Prelude'.Just Prelude'.False)

instance P'.Wire UserStats where
  wireSize ft' self'@(UserStats x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11 x'12 x'13 x'14 x'15 x'16 x'17 x'18 x'19)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size
         = (P'.wireSizeOpt 1 13 x'1 + P'.wireSizeOpt 1 8 x'2 + P'.wireSizeRep 1 12 x'3 + P'.wireSizeOpt 1 11 x'4 +
             P'.wireSizeOpt 1 11 x'5
             + P'.wireSizeOpt 1 13 x'6
             + P'.wireSizeOpt 1 13 x'7
             + P'.wireSizeOpt 1 2 x'8
             + P'.wireSizeOpt 1 2 x'9
             + P'.wireSizeOpt 1 2 x'10
             + P'.wireSizeOpt 1 2 x'11
             + P'.wireSizeOpt 1 11 x'12
             + P'.wireSizeRep 1 5 x'13
             + P'.wireSizeOpt 1 12 x'14
             + P'.wireSizeOpt 1 13 x'15
             + P'.wireSizeOpt 2 13 x'16
             + P'.wireSizeOpt 2 13 x'17
             + P'.wireSizeOpt 2 8 x'18
             + P'.wireSizeOpt 2 8 x'19)
  wirePutWithSize ft' self'@(UserStats x'1 x'2 x'3 x'4 x'5 x'6 x'7 x'8 x'9 x'10 x'11 x'12 x'13 x'14 x'15 x'16 x'17 x'18 x'19)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutOptWithSize 8 13 x'1, P'.wirePutOptWithSize 16 8 x'2, P'.wirePutRepWithSize 26 12 x'3,
             P'.wirePutOptWithSize 34 11 x'4, P'.wirePutOptWithSize 42 11 x'5, P'.wirePutOptWithSize 48 13 x'6,
             P'.wirePutOptWithSize 56 13 x'7, P'.wirePutOptWithSize 69 2 x'8, P'.wirePutOptWithSize 77 2 x'9,
             P'.wirePutOptWithSize 85 2 x'10, P'.wirePutOptWithSize 93 2 x'11, P'.wirePutOptWithSize 98 11 x'12,
             P'.wirePutRepWithSize 104 5 x'13, P'.wirePutOptWithSize 114 12 x'14, P'.wirePutOptWithSize 120 13 x'15,
             P'.wirePutOptWithSize 128 13 x'16, P'.wirePutOptWithSize 136 13 x'17, P'.wirePutOptWithSize 144 8 x'18,
             P'.wirePutOptWithSize 152 8 x'19]
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
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_stats_only = Prelude'.Just new'Field}) (P'.wireGet 8)
             26 -> Prelude'.fmap (\ !new'Field -> old'Self{_certificates = P'.append (_certificates old'Self) new'Field})
                    (P'.wireGet 12)
             34 -> Prelude'.fmap
                    (\ !new'Field -> old'Self{_from_client = P'.mergeAppend (_from_client old'Self) (Prelude'.Just new'Field)})
                    (P'.wireGet 11)
             42 -> Prelude'.fmap
                    (\ !new'Field -> old'Self{_from_server = P'.mergeAppend (_from_server old'Self) (Prelude'.Just new'Field)})
                    (P'.wireGet 11)
             48 -> Prelude'.fmap (\ !new'Field -> old'Self{_udp_packets = Prelude'.Just new'Field}) (P'.wireGet 13)
             56 -> Prelude'.fmap (\ !new'Field -> old'Self{_tcp_packets = Prelude'.Just new'Field}) (P'.wireGet 13)
             69 -> Prelude'.fmap (\ !new'Field -> old'Self{_udp_ping_avg = Prelude'.Just new'Field}) (P'.wireGet 2)
             77 -> Prelude'.fmap (\ !new'Field -> old'Self{_udp_ping_var = Prelude'.Just new'Field}) (P'.wireGet 2)
             85 -> Prelude'.fmap (\ !new'Field -> old'Self{_tcp_ping_avg = Prelude'.Just new'Field}) (P'.wireGet 2)
             93 -> Prelude'.fmap (\ !new'Field -> old'Self{_tcp_ping_var = Prelude'.Just new'Field}) (P'.wireGet 2)
             98 -> Prelude'.fmap (\ !new'Field -> old'Self{_version = P'.mergeAppend (_version old'Self) (Prelude'.Just new'Field)})
                    (P'.wireGet 11)
             104 -> Prelude'.fmap (\ !new'Field -> old'Self{_celt_versions = P'.append (_celt_versions old'Self) new'Field})
                     (P'.wireGet 5)
             106 -> Prelude'.fmap (\ !new'Field -> old'Self{_celt_versions = P'.mergeAppend (_celt_versions old'Self) new'Field})
                     (P'.wireGetPacked 5)
             114 -> Prelude'.fmap (\ !new'Field -> old'Self{_address = Prelude'.Just new'Field}) (P'.wireGet 12)
             120 -> Prelude'.fmap (\ !new'Field -> old'Self{_bandwidth = Prelude'.Just new'Field}) (P'.wireGet 13)
             128 -> Prelude'.fmap (\ !new'Field -> old'Self{_onlinesecs = Prelude'.Just new'Field}) (P'.wireGet 13)
             136 -> Prelude'.fmap (\ !new'Field -> old'Self{_idlesecs = Prelude'.Just new'Field}) (P'.wireGet 13)
             144 -> Prelude'.fmap (\ !new'Field -> old'Self{_strong_certificate = Prelude'.Just new'Field}) (P'.wireGet 8)
             152 -> Prelude'.fmap (\ !new'Field -> old'Self{_opus = Prelude'.Just new'Field}) (P'.wireGet 8)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> UserStats) UserStats where
  getVal m' f' = f' m'

instance P'.GPB UserStats

instance P'.ReflectDescriptor UserStats where
  getMessageInfo _
   = P'.GetMessageInfo (P'.fromDistinctAscList [])
      (P'.fromDistinctAscList [8, 16, 26, 34, 42, 48, 56, 69, 77, 85, 93, 98, 104, 106, 114, 120, 128, 136, 144, 152])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.UserStats\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"UserStats\"}, descFilePath = [\"Data\",\"MumbleProto\",\"UserStats.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.session\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"session\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.stats_only\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"stats_only\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"false\", hsDefault = Just (HsDef'Bool False)},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.certificates\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"certificates\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 26}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = False, typeCode = FieldType {getFieldType = 12}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.from_client\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"from_client\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 34}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".MumbleProto.UserStats.Stats\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\",MName \"UserStats\"], baseName = MName \"Stats\"}), hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.from_server\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"from_server\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 5}, wireTag = WireTag {getWireTag = 42}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".MumbleProto.UserStats.Stats\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\",MName \"UserStats\"], baseName = MName \"Stats\"}), hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.udp_packets\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"udp_packets\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 6}, wireTag = WireTag {getWireTag = 48}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.tcp_packets\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"tcp_packets\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 7}, wireTag = WireTag {getWireTag = 56}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.udp_ping_avg\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"udp_ping_avg\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 8}, wireTag = WireTag {getWireTag = 69}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 2}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.udp_ping_var\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"udp_ping_var\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 9}, wireTag = WireTag {getWireTag = 77}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 2}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.tcp_ping_avg\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"tcp_ping_avg\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 10}, wireTag = WireTag {getWireTag = 85}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 2}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.tcp_ping_var\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"tcp_ping_var\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 11}, wireTag = WireTag {getWireTag = 93}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 2}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.version\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"version\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 12}, wireTag = WireTag {getWireTag = 98}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".MumbleProto.Version\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"Version\"}), hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.celt_versions\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"celt_versions\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 13}, wireTag = WireTag {getWireTag = 104}, packedTag = Just (WireTag {getWireTag = 104},WireTag {getWireTag = 106}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 5}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.address\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"address\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 14}, wireTag = WireTag {getWireTag = 114}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 12}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.bandwidth\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"bandwidth\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 15}, wireTag = WireTag {getWireTag = 120}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.onlinesecs\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"onlinesecs\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 16}, wireTag = WireTag {getWireTag = 128}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.idlesecs\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"idlesecs\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 17}, wireTag = WireTag {getWireTag = 136}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.strong_certificate\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"strong_certificate\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 18}, wireTag = WireTag {getWireTag = 144}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"false\", hsDefault = Just (HsDef'Bool False)},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserStats.opus\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserStats\"], baseName' = FName \"opus\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 19}, wireTag = WireTag {getWireTag = 152}, packedTag = Nothing, wireTagLength = 2, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 8}, typeName = Nothing, hsRawDefault = Just \"false\", hsDefault = Just (HsDef'Bool False)}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType UserStats where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg UserStats where
  textPut msg
   = do
       P'.tellT "session" (_session msg)
       P'.tellT "stats_only" (_stats_only msg)
       P'.tellT "certificates" (_certificates msg)
       P'.tellT "from_client" (_from_client msg)
       P'.tellT "from_server" (_from_server msg)
       P'.tellT "udp_packets" (_udp_packets msg)
       P'.tellT "tcp_packets" (_tcp_packets msg)
       P'.tellT "udp_ping_avg" (_udp_ping_avg msg)
       P'.tellT "udp_ping_var" (_udp_ping_var msg)
       P'.tellT "tcp_ping_avg" (_tcp_ping_avg msg)
       P'.tellT "tcp_ping_var" (_tcp_ping_var msg)
       P'.tellT "version" (_version msg)
       P'.tellT "celt_versions" (_celt_versions msg)
       P'.tellT "address" (_address msg)
       P'.tellT "bandwidth" (_bandwidth msg)
       P'.tellT "onlinesecs" (_onlinesecs msg)
       P'.tellT "idlesecs" (_idlesecs msg)
       P'.tellT "strong_certificate" (_strong_certificate msg)
       P'.tellT "opus" (_opus msg)
  textGet
   = do
       mods <- P'.sepEndBy
                (P'.choice
                  [parse'_session, parse'_stats_only, parse'_certificates, parse'_from_client, parse'_from_server,
                   parse'_udp_packets, parse'_tcp_packets, parse'_udp_ping_avg, parse'_udp_ping_var, parse'_tcp_ping_avg,
                   parse'_tcp_ping_var, parse'_version, parse'_celt_versions, parse'_address, parse'_bandwidth, parse'_onlinesecs,
                   parse'_idlesecs, parse'_strong_certificate, parse'_opus])
                P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_session
         = P'.try
            (do
               v <- P'.getT "session"
               Prelude'.return (\ o -> o{_session = v}))
        parse'_stats_only
         = P'.try
            (do
               v <- P'.getT "stats_only"
               Prelude'.return (\ o -> o{_stats_only = v}))
        parse'_certificates
         = P'.try
            (do
               v <- P'.getT "certificates"
               Prelude'.return (\ o -> o{_certificates = P'.append (_certificates o) v}))
        parse'_from_client
         = P'.try
            (do
               v <- P'.getT "from_client"
               Prelude'.return (\ o -> o{_from_client = v}))
        parse'_from_server
         = P'.try
            (do
               v <- P'.getT "from_server"
               Prelude'.return (\ o -> o{_from_server = v}))
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
        parse'_version
         = P'.try
            (do
               v <- P'.getT "version"
               Prelude'.return (\ o -> o{_version = v}))
        parse'_celt_versions
         = P'.try
            (do
               v <- P'.getT "celt_versions"
               Prelude'.return (\ o -> o{_celt_versions = P'.append (_celt_versions o) v}))
        parse'_address
         = P'.try
            (do
               v <- P'.getT "address"
               Prelude'.return (\ o -> o{_address = v}))
        parse'_bandwidth
         = P'.try
            (do
               v <- P'.getT "bandwidth"
               Prelude'.return (\ o -> o{_bandwidth = v}))
        parse'_onlinesecs
         = P'.try
            (do
               v <- P'.getT "onlinesecs"
               Prelude'.return (\ o -> o{_onlinesecs = v}))
        parse'_idlesecs
         = P'.try
            (do
               v <- P'.getT "idlesecs"
               Prelude'.return (\ o -> o{_idlesecs = v}))
        parse'_strong_certificate
         = P'.try
            (do
               v <- P'.getT "strong_certificate"
               Prelude'.return (\ o -> o{_strong_certificate = v}))
        parse'_opus
         = P'.try
            (do
               v <- P'.getT "opus"
               Prelude'.return (\ o -> o{_opus = v}))