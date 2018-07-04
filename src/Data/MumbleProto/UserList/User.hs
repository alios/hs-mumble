{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.UserList.User (User(..), user_id, name, last_seen, last_channel) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH

data User = User{_user_id :: !(P'.Word32), _name :: !(P'.Maybe P'.Utf8), _last_seen :: !(P'.Maybe P'.Utf8),
                 _last_channel :: !(P'.Maybe P'.Word32)}
            deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''User

instance P'.Mergeable User where
  mergeAppend (User x'1 x'2 x'3 x'4) (User y'1 y'2 y'3 y'4)
   = User (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2) (P'.mergeAppend x'3 y'3) (P'.mergeAppend x'4 y'4)

instance P'.Default User where
  defaultValue = User P'.defaultValue P'.defaultValue P'.defaultValue P'.defaultValue

instance P'.Wire User where
  wireSize ft' self'@(User x'1 x'2 x'3 x'4)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeReq 1 13 x'1 + P'.wireSizeOpt 1 9 x'2 + P'.wireSizeOpt 1 9 x'3 + P'.wireSizeOpt 1 13 x'4)
  wirePutWithSize ft' self'@(User x'1 x'2 x'3 x'4)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = P'.sequencePutWithSize
            [P'.wirePutReqWithSize 8 13 x'1, P'.wirePutOptWithSize 18 9 x'2, P'.wirePutOptWithSize 26 9 x'3,
             P'.wirePutOptWithSize 32 13 x'4]
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
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{_user_id = new'Field}) (P'.wireGet 13)
             18 -> Prelude'.fmap (\ !new'Field -> old'Self{_name = Prelude'.Just new'Field}) (P'.wireGet 9)
             26 -> Prelude'.fmap (\ !new'Field -> old'Self{_last_seen = Prelude'.Just new'Field}) (P'.wireGet 9)
             32 -> Prelude'.fmap (\ !new'Field -> old'Self{_last_channel = Prelude'.Just new'Field}) (P'.wireGet 13)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> User) User where
  getVal m' f' = f' m'

instance P'.GPB User

instance P'.ReflectDescriptor User where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList [8]) (P'.fromDistinctAscList [8, 18, 26, 32])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.UserList.User\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\",MName \"UserList\"], baseName = MName \"User\"}, descFilePath = [\"Data\",\"MumbleProto\",\"UserList\",\"User.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserList.User.user_id\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserList\",MName \"User\"], baseName' = FName \"user_id\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserList.User.name\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserList\",MName \"User\"], baseName' = FName \"name\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 18}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserList.User.last_seen\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserList\",MName \"User\"], baseName' = FName \"last_seen\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 3}, wireTag = WireTag {getWireTag = 26}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 9}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserList.User.last_channel\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserList\",MName \"User\"], baseName' = FName \"last_channel\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 4}, wireTag = WireTag {getWireTag = 32}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 13}, typeName = Nothing, hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType User where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg User where
  textPut msg
   = do
       P'.tellT "user_id" (_user_id msg)
       P'.tellT "name" (_name msg)
       P'.tellT "last_seen" (_last_seen msg)
       P'.tellT "last_channel" (_last_channel msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_user_id, parse'_name, parse'_last_seen, parse'_last_channel]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_user_id
         = P'.try
            (do
               v <- P'.getT "user_id"
               Prelude'.return (\ o -> o{_user_id = v}))
        parse'_name
         = P'.try
            (do
               v <- P'.getT "name"
               Prelude'.return (\ o -> o{_name = v}))
        parse'_last_seen
         = P'.try
            (do
               v <- P'.getT "last_seen"
               Prelude'.return (\ o -> o{_last_seen = v}))
        parse'_last_channel
         = P'.try
            (do
               v <- P'.getT "last_channel"
               Prelude'.return (\ o -> o{_last_channel = v}))