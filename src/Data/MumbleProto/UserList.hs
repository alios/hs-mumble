{-# LANGUAGE TemplateHaskell, BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.UserList (UserList(..), users) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Control.Lens.TH
import qualified Data.MumbleProto.UserList.User as MumbleProto.UserList (User)

data UserList = UserList{_users :: !(P'.Seq MumbleProto.UserList.User)}
                deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data, Prelude'.Generic)

Control.Lens.TH.makeLenses ''UserList

instance P'.Mergeable UserList where
  mergeAppend (UserList x'1) (UserList y'1) = UserList (P'.mergeAppend x'1 y'1)

instance P'.Default UserList where
  defaultValue = UserList P'.defaultValue

instance P'.Wire UserList where
  wireSize ft' self'@(UserList x'1)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeRep 1 11 x'1)
  wirePutWithSize ft' self'@(UserList x'1)
   = case ft' of
       10 -> put'Fields
       11 -> put'FieldsSized
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields = P'.sequencePutWithSize [P'.wirePutRepWithSize 10 11 x'1]
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
             10 -> Prelude'.fmap (\ !new'Field -> old'Self{_users = P'.append (_users old'Self) new'Field}) (P'.wireGet 11)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> UserList) UserList where
  getVal m' f' = f' m'

instance P'.GPB UserList

instance P'.ReflectDescriptor UserList where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList []) (P'.fromDistinctAscList [10])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".MumbleProto.UserList\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\"], baseName = MName \"UserList\"}, descFilePath = [\"Data\",\"MumbleProto\",\"UserList.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".MumbleProto.UserList.users\", haskellPrefix' = [MName \"Data\"], parentModule' = [MName \"MumbleProto\",MName \"UserList\"], baseName' = FName \"users\", baseNamePrefix' = \"_\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 10}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = False, canRepeat = True, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".MumbleProto.UserList.User\", haskellPrefix = [MName \"Data\"], parentModule = [MName \"MumbleProto\",MName \"UserList\"], baseName = MName \"User\"}), hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = True}"

instance P'.TextType UserList where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg UserList where
  textPut msg
   = do
       P'.tellT "users" (_users msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'_users]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'_users
         = P'.try
            (do
               v <- P'.getT "users"
               Prelude'.return (\ o -> o{_users = P'.append (_users o) v}))