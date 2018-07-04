{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Monad.Mumble
import           Data.Conduit.Network.TLS

main :: IO ()
main =
  let u = "username"
      p = pure "password"
      tlsCfg = tlsClientConfig 64738 "mumble.server.org"
  in startClient tlsCfg u p
