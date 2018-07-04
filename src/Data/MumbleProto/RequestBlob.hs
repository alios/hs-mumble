{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.RequestBlob (RequestBlob(..), session_texture, session_comment, channel_description) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data RequestBlob = RequestBlob{_session_texture :: !(P'.Seq P'.Word32), _session_comment :: !(P'.Seq P'.Word32),
                               _channel_description :: !(P'.Seq P'.Word32)}
                   deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''RequestBlob

instance P'.Mergeable RequestBlob where
  mergeAppend (RequestBlob x'1 x'2 x'3) (RequestBlob y'1 y'2 y'3)
   = RequestBlob (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3)

instance P'.Default RequestBlob where
  defaultValue = RequestBlob P'.defaultValue P'.defaultValue P'.defaultValue

instance P'.Wire RequestBlob where
  wireSize ft' self'@(RequestBlob x'1 x'2 x'3)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeRep 1 13 x'1 + P'.wireSizeRep 1 13 x'2 + P'.wireSizeRep 1 13 x'3)
  wirePutWithSize ft' self'@(RequestBlob x'1 x'2 x'3)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize [P'.wirePutRepWithSize 8 13 x'1, P'.wirePutRepWithSize 16 13 x'2, P'.wirePutRepWithSize 24 13 x'3]
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
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_session_texture = P'.append (_session_texture old'Self) new'Field})
                   (P'.wireGet 13)
             10 -> Prelude'.fmap (\ !new'Field -> old'Self{_session_texture = P'.mergeAppend (_session_texture old'Self) new'Field})
                    (P'.wireGetPacked 13)
             16 -> Prelude'.fmap (\ !new'Field -> old'Self{_session_comment = P'.append (_session_comment old'Self) new'Field})
                    (P'.wireGet 13)
             18 -> Prelude'.fmap (\ !new'Field -> old'Self{_session_comment = P'.mergeAppend (_session_comment old'Self) new'Field})
                    (P'.wireGetPacked 13)
             24 -> Prelude'.fmap
                    (\ !new'Field -> old'Self{_channel_description = P'.append (_channel_description old'Self) new'Field})
                    (P'.wireGet 13)
             26 -> Prelude'.fmap
                    (\ !new'Field -> old'Self{_channel_description = P'.mergeAppend (_channel_description old'Self) new'Field})
                    (P'.wireGetPacked 13)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> RequestBlob) RequestBlob where
  getVal m' f' = f' m'

instance P'.GPB RequestBlob

instance P'.ReflectDescriptor RequestBlob where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [8, 10, 16, 18, 24, 26])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.RequestBlob\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"RequestBlob\"}, descFilePath = [\"Data\",\"MumbleProto\",\"RequestBlob.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.RequestBlob.session_texture\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"RequestBlob\"], baseName' = FName \"session_texture\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Just (WireTag {getWireTag = 8},WireTag {getWireTag = 10}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.RequestBlob.session_comment\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"RequestBlob\"], baseName' = FName \"session_comment\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 16}, packedTag = Just (WireTag {getWireTag = 16},WireTag {getWireTag = 18}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.RequestBlob.channel_description\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"RequestBlob\"], baseName' = FName \"channel_description\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 24}, packedTag = Just (WireTag {getWireTag = 24},WireTag {getWireTag = 26}), wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = True, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType RequestBlob where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg RequestBlob where
  textPut msg
   = do
       P'.tellT "session_texture" (_session_texture msg)
       P'.tellT "session_comment" (_session_comment msg)
       P'.tellT "channel_description" (_channel_description msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_session_texture, parse'_session_comment, parse'_channel_description]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_session_texture
         = P'.try
            (do
               v <- P'.getT "session_texture"
               Prelude'.return (\ o -> o{_session_texture = P'.append (_session_texture o) v}))
        parse'_session_comment
         = P'.try
            (do
               v <- P'.getT "session_comment"
               Prelude'.return (\ o -> o{_session_comment = P'.append (_session_comment o) v}))
        parse'_channel_description
         = P'.try
            (do
               v <- P'.getT "channel_description"
               Prelude'.return (\ o -> o{_channel_description = P'.append (_channel_description o) v}))