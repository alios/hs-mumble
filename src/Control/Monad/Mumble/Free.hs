{-# LANGUAGE ConstraintKinds  #-}
{-# LANGUAGE DeriveFunctor    #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs            #-}
{-# LANGUAGE KindSignatures   #-}
{-# LANGUAGE TemplateHaskell  #-}

module Control.Monad.Mumble.Free
  ( MonadMumble, MumbleF
  , mumbleReceiveRaw, mumbleReceiveAny, mumbleReceiveManyOf, mumbleReceiveEither
  , mumbleSendRaw, mumbleSendPacket
  , mumbleRunPlugin
  , MonadMumblePlugin, MumblePluginF
  , mumblePluginAnySource, mumblePluginSendRaw
  , MumbleException(..)
  ) where

import           Conduit
import           Control.Exception
import           Control.Lens.Operators
import           Control.Monad.Free
import           Control.Monad.Free.TH
import           Control.Monad.Mumble.Plugins
import           Data.Mumble.Packet
import           Data.MumbleProto.Ping
import           Data.MumbleProto.Reject
import           Data.MumbleProto.TextMessage
import           Data.Typeable                (Typeable)


data MumblePluginF next where
  MumblePluginSendRaw :: RawPacket -> next -> MumblePluginF next
  MumblePluginAnySource :: (ConduitT () APacket m () -> next) -> MumblePluginF next

type MonadMumblePlugin = MonadFree MumblePluginF
type MumblePluginM = Free MumblePluginF

instance Functor MumblePluginF where
  fmap f (MumblePluginSendRaw p n) = MumblePluginSendRaw p (f n)
  fmap f (MumblePluginAnySource g) = MumblePluginAnySource (f . g)



-- | The 'MonadFree' we use for communication with the mumble server.
data MumbleF next where
  MumbleSendRaw :: RawPacket -> next -> MumbleF next
  MumbleReceiveRaw :: (RawPacket -> next) -> MumbleF next
  MumbleReceiveManyOf :: MumblePacket a =>
    PacketTypeProxy a -> ([a] -> next) -> MumbleF next
  MumbleRunPlugin :: MumblePlugin p =>
    p -> (MumblePluginInstance p -> next) -> MumbleF next
  MumbleStopPlugin :: MumblePlugin p =>
    MumblePluginInstance p -> next -> MumbleF next

-- | The Monad we run communications with mumble server in.
type MonadMumble = MonadFree MumbleF
type MumbleM = Free MumbleF

instance Functor MumbleF where
  fmap f (MumbleSendRaw p n)       = MumbleSendRaw p (f n)
  fmap f (MumbleReceiveRaw g)      = MumbleReceiveRaw (f . g)
  fmap f (MumbleReceiveManyOf p g) = MumbleReceiveManyOf p (f . g)

makeFree_ ''MumbleF

-- | send a 'RawPacket' to the mumble server
mumbleSendRaw :: MonadMumble m => RawPacket -> m ()

-- | receive (wait for) a 'RawPacket' from mumble server.
mumbleReceiveRaw :: MonadMumble m => m RawPacket

-- | receive all successive packets of a given type
mumbleReceiveManyOf :: (MumblePacket a, MonadMumble m) =>
  PacketTypeProxy a -> m [a]

-- | run a 'MumblePlugin' asyncronously
mumbleRunPlugin :: (MumblePlugin p, MonadMumble m) =>
  p -> m (MumblePluginInstance p)

-- | stop a 'MumblePlugin'
mumbleStopPlugin :: (MumblePlugin p, MonadMumble m) =>
  MumblePluginInstance p -> m ()



makeFree_ ''MumblePluginF

-- | send a 'RawPacket' to the mumble server
mumblePluginSendRaw ::
  MonadMumblePlugin m => RawPacket -> m ()

mumblePluginAnySource ::
  MonadMumblePlugin m => m (ConduitT () APacket m ())







-- | Exceptions that might be thrown in a 'MonadMumble'.
data MumbleException
  = NoMoreData
  | InvalidState String
  | DecodePacketFailed String
  | UnexpectedRawPacket PacketType PacketType RawPacket
  | UnexpectedPacket PacketType PacketType
  | AuthenticationFailed Reject
  | ChannelDBFail String
  | UserDBFail String
  | PongFailure Ping Ping
  | TextMessageFailure TextMessage String
  deriving Typeable


-- | Send a 'MumblePacket' to the connected server.
mumbleSendPacket :: (MumblePacket a, MonadMumble m) => a -> m ()
mumbleSendPacket = mumbleSendRaw . rawFromPacket

-- | Receive a packet of anytype. See 'APacket'.
mumbleReceiveAny :: (MonadMumble m, MonadThrow m) => m APacket
mumbleReceiveAny = do
  f <- raw2apacket <$> mumbleReceiveRaw
  either (throwM . DecodePacketFailed) pure f


-- | Get 'Either' packet of type given by 'PacketTypeProxy' a or b.
--   Might throw an 'UnexpectedRawPacket' or 'DecodePacketFailed' exception.
mumbleReceiveEither ::
  (MumblePacket a, MumblePacket b, MonadMumble m, MonadThrow m) =>
  PacketTypeProxy a -> PacketTypeProxy b -> m (Either a b)
mumbleReceiveEither a b =
  mumbleEitherPacket a b <$> mumbleReceiveRaw >>=
    either throwM pure















mumbleEitherPacket ::
  (MumblePacket a, MumblePacket b) =>
  PacketTypeProxy a -> PacketTypeProxy b -> RawPacket ->
  Either MumbleException (Either a b)
mumbleEitherPacket a b rp
  | c == a' = onE $ Left <$> packetFromRawE a rp
  | c == b' = onE $ Right <$> packetFromRawE b rp
  | otherwise = Left (UnexpectedRawPacket a' b' rp)
  where
    a' = proxyPacketType a
    b' = proxyPacketType b
    (c,_) = rp ^. _RawPacket
    onE = either (Left . DecodePacketFailed) Right

instance Show MumbleException where
    show NoMoreData               = "no more packets from mumble socket"
    show (InvalidState s)         = "application in invalid state: " ++ s
    show (DecodePacketFailed s)   = " unable to parse raw packet: " ++ s
    show (UnexpectedRawPacket a b rp) =
      let c = fst $ rp ^. _RawPacket
      in mconcat ["expectede packet ", show a, " or ", show b, ", but got ", show c]
    show (UnexpectedPacket a b) =
      mconcat ["expected packet ", show a, " but got ", show b]
    show (AuthenticationFailed r) =
      mconcat ["authentication failed: ", maybe "" show $ r ^. reason]
    show (ChannelDBFail err) =
      mconcat ["error updating channel db: ", err]
    show (UserDBFail err) =
      mconcat ["error updating user db: ", err]
    show (PongFailure a b) =
      mconcat ["expected pong: " , show a, ", got: ", show b]
    show (TextMessageFailure m e) =
      mconcat ["unexpected TextMessage: '" , show e, "': ", show m]
instance Exception MumbleException
