module Example.Nested where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)
import Control.Monad.Except (runExcept)

import Data.CForeign (F)
import Data.CForeign.Class (class IsForeign, readJSON, readProp)
import Data.CForeign.Index (prop)

data Foo = Foo Bar Baz

data Bar = Bar String

data Baz = Baz Number

instance showFoo :: Show Foo where
  show (Foo bar baz) = "(Foo " <> show bar <> " " <> show baz <> ")"

instance showBar :: Show Bar where
  show (Bar s) = "(Bar " <> show s <> ")"

instance showBaz :: Show Baz where
  show (Baz n) = "(Baz " <> show n <> ")"

instance fooIsForeign :: IsForeign Foo where
  read value = do
    s <- value # (prop "foo" >=> readProp "bar")
    n <- value # (prop "foo" >=> readProp "baz")
    pure $ Foo (Bar s) (Baz n)

main :: Eff (console :: CONSOLE) Unit
main = do
  logShow $ runExcept $ readJSON """{ "foo": { "bar": "bar", "baz": 1 } }""" :: F Foo
