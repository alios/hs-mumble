{-# LANGUAGE BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.Reject.RejectType (RejectType(..)) where
import Prelude ((+), (/), (.))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'

data RejectType = None
                | WrongVersion
                | InvalidUsername
                | WrongUserPW
                | WrongServerPW
                | UsernameInUse
                | ServerFull
                | NoCertificate
                | AuthenticatorFail
                  deriving (Prelude'.Read, Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data,
                            Prelude'.Generic)

instance P'.Mergeable RejectType

instance Prelude'.Bounded RejectType where
  minBound = None
  maxBound = AuthenticatorFail

instance P'.Default RejectType where
  defaultValue = None

toMaybe'Enum :: Prelude'.Int -> P'.Maybe RejectType
toMaybe'Enum 0 = Prelude'.Just None
toMaybe'Enum 1 = Prelude'.Just WrongVersion
toMaybe'Enum 2 = Prelude'.Just InvalidUsername
toMaybe'Enum 3 = Prelude'.Just WrongUserPW
toMaybe'Enum 4 = Prelude'.Just WrongServerPW
toMaybe'Enum 5 = Prelude'.Just UsernameInUse
toMaybe'Enum 6 = Prelude'.Just ServerFull
toMaybe'Enum 7 = Prelude'.Just NoCertificate
toMaybe'Enum 8 = Prelude'.Just AuthenticatorFail
toMaybe'Enum _ = Prelude'.Nothing

instance Prelude'.Enum RejectType where
  fromEnum None = 0
  fromEnum WrongVersion = 1
  fromEnum InvalidUsername = 2
  fromEnum WrongUserPW = 3
  fromEnum WrongServerPW = 4
  fromEnum UsernameInUse = 5
  fromEnum ServerFull = 6
  fromEnum NoCertificate = 7
  fromEnum AuthenticatorFail = 8
  toEnum
   = P'.fromMaybe (Prelude'.error "hprotoc generated code: toEnum failure for type Data.MumbleProto.Reject.RejectType") .
      toMaybe'Enum
  succ None = WrongVersion
  succ WrongVersion = InvalidUsername
  succ InvalidUsername = WrongUserPW
  succ WrongUserPW = WrongServerPW
  succ WrongServerPW = UsernameInUse
  succ UsernameInUse = ServerFull
  succ ServerFull = NoCertificate
  succ NoCertificate = AuthenticatorFail
  succ _ = Prelude'.error "hprotoc generated code: succ failure for type Data.MumbleProto.Reject.RejectType"
  pred WrongVersion = None
  pred InvalidUsername = WrongVersion
  pred WrongUserPW = InvalidUsername
  pred WrongServerPW = WrongUserPW
  pred UsernameInUse = WrongServerPW
  pred ServerFull = UsernameInUse
  pred NoCertificate = ServerFull
  pred AuthenticatorFail = NoCertificate
  pred _ = Prelude'.error "hprotoc generated code: pred failure for type Data.MumbleProto.Reject.RejectType"

instance P'.Wire RejectType where
  wireSize ft' enum = P'.wireSize ft' (Prelude'.fromEnum enum)
  wirePut ft' enum = P'.wirePut ft' (Prelude'.fromEnum enum)
  wireGet 14 = P'.wireGetEnum toMaybe'Enum
  wireGet ft' = P'.wireGetErr ft'
  wireGetPacked 14 = P'.wireGetPackedEnum toMaybe'Enum
  wireGetPacked ft' = P'.wireGetErr ft'

instance P'.GPB RejectType

instance P'.MessageAPI msg' (msg' -> RejectType) RejectType where
  getVal m' f' = f' m'

instance P'.ReflectEnum RejectType where
  reflectEnum
   = [(0, "None", None), (1, "WrongVersion", WrongVersion), (2, "InvalidUsername", InvalidUsername),
      (3, "WrongUserPW", WrongUserPW), (4, "WrongServerPW", WrongServerPW), (5, "UsernameInUse", UsernameInUse),
      (6, "ServerFull", ServerFull), (7, "NoCertificate", NoCertificate), (8, "AuthenticatorFail", AuthenticatorFail)]
  reflectEnumInfo _
   = P'.EnumInfo (P'.makePNF (P'.pack ".MumbleProto.Reject.RejectType") ["Data"] ["MumbleProto", "Reject"] "RejectType")
      ["Data", "MumbleProto", "Reject", "RejectType.hs"]
      [(0, "None"), (1, "WrongVersion"), (2, "InvalidUsername"), (3, "WrongUserPW"), (4, "WrongServerPW"), (5, "UsernameInUse"),
       (6, "ServerFull"), (7, "NoCertificate"), (8, "AuthenticatorFail")]

instance P'.TextType RejectType where
  tellT = P'.tellShow
  getT = P'.getRead