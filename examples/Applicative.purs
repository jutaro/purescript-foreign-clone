module Example.Applicative where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)
import Control.Monad.Except (runExcept)

import Data.CForeign (F)
import Data.CForeign.Class (class IsForeign, readJSON, readProp)

data Point = Point Number Number Number

instance showPoint :: Show Point where
  show (Point x y z) = "(Point " <> show [x, y, z] <> ")"

instance pointIsForeign :: IsForeign Point where
  read value = Point <$> readProp "x" value
                     <*> readProp "y" value
                     <*> readProp "z" value

main :: Eff (console :: CONSOLE) Unit
main = logShow $ runExcept $
  readJSON """{ "x": 1, "y": 2, "z": 3 }""" :: F Point
