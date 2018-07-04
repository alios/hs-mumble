{-# LANGUAGE BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.ContextActionModify.Context (Context(..)) where
import Prelude ((+), (/), (.))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'

data Context = Server
             | Channel
             | User
               deriving (Prelude'.Read, Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data,
                         Prelude'.Generic)

instance P'.Mergeable Context

instance Prelude'.Bounded Context where
  minBound = Server
  maxBound = User

instance P'.Default Context where
  defaultValue = Server

toMaybe'Enum :: Prelude'.Int -> P'.Maybe Context
toMaybe'Enum 1 = Prelude'.Just Server
toMaybe'Enum 2 = Prelude'.Just Channel
toMaybe'Enum 4 = Prelude'.Just User
toMaybe'Enum _ = Prelude'.Nothing

instance Prelude'.Enum Context where
  fromEnum Server = 1
  fromEnum Channel = 2
  fromEnum User = 4
  toEnum
   = P'.fromMaybe (Prelude'.error "hprotoc generated code: toEnum failure for type Data.MumbleProto.ContextActionModify.Context") .
      toMaybe'Enum
  succ Server = Channel
  succ Channel = User
  succ _ = Prelude'.error "hprotoc generated code: succ failure for type Data.MumbleProto.ContextActionModify.Context"
  pred Channel = Server
  pred User = Channel
  pred _ = Prelude'.error "hprotoc generated code: pred failure for type Data.MumbleProto.ContextActionModify.Context"

instance P'.Wire Context where
  wireSize ft' enum = P'.wireSize ft' (Prelude'.fromEnum enum)
  wirePut ft' enum = P'.wirePut ft' (Prelude'.fromEnum enum)
  wireGet 14 = P'.wireGetEnum toMaybe'Enum
  wireGet ft' = P'.wireGetErr ft'
  wireGetPacked 14 = P'.wireGetPackedEnum toMaybe'Enum
  wireGetPacked ft' = P'.wireGetErr ft'

instance P'.GPB Context

instance P'.MessageAPI msg' (msg' -> Context) Context where
  getVal m' f' = f' m'

instance P'.ReflectEnum Context where
  reflectEnum = [(1, "Server", Server), (2, "Channel", Channel), (4, "User", User)]
  reflectEnumInfo _
   = P'.EnumInfo
      (P'.makePNF (P'.pack ".MumbleProto.ContextActionModify.Context") ["Data"] ["MumbleProto", "ContextActionModify"] "Context")
      ["Data", "MumbleProto", "ContextActionModify", "Context.hs"]
      [(1, "Server"), (2, "Channel"), (4, "User")]

instance P'.TextType Context where
  tellT = P'.tellShow
  getT = P'.getRead