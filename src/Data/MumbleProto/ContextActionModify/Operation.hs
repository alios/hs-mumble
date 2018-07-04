{-# LANGUAGE BangPatterns, DeriveDataTypeable, DeriveGeneric, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Data.MumbleProto.ContextActionModify.Operation (Operation(..)) where
import Prelude ((+), (/), (.))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified GHC.Generics as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'

data Operation = Add
               | Remove
                 deriving (Prelude'.Read, Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data,
                           Prelude'.Generic)

instance P'.Mergeable Operation

instance Prelude'.Bounded Operation where
  minBound = Add
  maxBound = Remove

instance P'.Default Operation where
  defaultValue = Add

toMaybe'Enum :: Prelude'.Int -> P'.Maybe Operation
toMaybe'Enum 0 = Prelude'.Just Add
toMaybe'Enum 1 = Prelude'.Just Remove
toMaybe'Enum _ = Prelude'.Nothing

instance Prelude'.Enum Operation where
  fromEnum Add = 0
  fromEnum Remove = 1
  toEnum
   = P'.fromMaybe (Prelude'.error "hprotoc generated code: toEnum failure for type Data.MumbleProto.ContextActionModify.Operation")
      . toMaybe'Enum
  succ Add = Remove
  succ _ = Prelude'.error "hprotoc generated code: succ failure for type Data.MumbleProto.ContextActionModify.Operation"
  pred Remove = Add
  pred _ = Prelude'.error "hprotoc generated code: pred failure for type Data.MumbleProto.ContextActionModify.Operation"

instance P'.Wire Operation where
  wireSize ft' enum = P'.wireSize ft' (Prelude'.fromEnum enum)
  wirePut ft' enum = P'.wirePut ft' (Prelude'.fromEnum enum)
  wireGet 14 = P'.wireGetEnum toMaybe'Enum
  wireGet ft' = P'.wireGetErr ft'
  wireGetPacked 14 = P'.wireGetPackedEnum toMaybe'Enum
  wireGetPacked ft' = P'.wireGetErr ft'

instance P'.GPB Operation

instance P'.MessageAPI msg' (msg' -> Operation) Operation where
  getVal m' f' = f' m'

instance P'.ReflectEnum Operation where
  reflectEnum = [(0, "Add", Add), (1, "Remove", Remove)]
  reflectEnumInfo _
   = P'.EnumInfo
      (P'.makePNF (P'.pack ".MumbleProto.ContextActionModify.Operation") ["Data"] ["MumbleProto", "ContextActionModify"]
        "Operation")
      ["Data", "MumbleProto", "ContextActionModify", "Operation.hs"]
      [(0, "Add"), (1, "Remove")]

instance P'.TextType Operation where
  tellT = P'.tellShow
  getT = P'.getRead