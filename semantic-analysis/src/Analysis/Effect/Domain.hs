{-# LANGUAGE GADTs #-}
{-
TODO

- machine integer sizes
-}
module Analysis.Effect.Domain
( -- * Variables
  dvar
  -- * Functions
, dabs
, dapp
  -- * Integers
, dint
  -- * Unit
, dunit
  -- * Booleans
, dtrue
, dfalse
, dbool
, dif
  -- * Strings
, dstring
  -- * Exceptions
, ddie
, Dom(..)
) where

import Analysis.Functor.Named
import Control.Algebra
import Data.Text (Text)

-- Variables

dvar :: Has (Dom val) sig m => Name -> m val
dvar = send . DVar


-- Functions

dabs :: Has (Dom val) sig m => Name -> (val -> m val) -> m val
dabs n = send . DAbs n

dapp :: Has (Dom val) sig m => val -> val -> m val
dapp f a = send $ DApp f a


-- Integers

dint :: Has (Dom val) sig m => Int -> m val
dint = send . DInt


-- Unit

dunit :: Has (Dom val) sig m => m val
dunit = send DUnit


-- Booleans

dtrue :: Has (Dom val) sig m => m val
dtrue = dbool True

dfalse :: Has (Dom val) sig m => m val
dfalse = dbool False

dbool :: Has (Dom val) sig m => Bool -> m val
dbool = send . DBool

dif :: Has (Dom val) sig m => val -> m a -> m a -> m a
dif c t e = send $ DIf c t e


-- Strings

dstring :: Has (Dom val) sig m => Text -> m val
dstring = send . DString


-- Exceptions

ddie :: Has (Dom val) sig m => String -> m val
ddie = send . DDie

data Dom val m k where
  DVar :: Name -> Dom val m val
  DAbs :: Name -> (val -> m val) -> Dom val m val
  DApp :: val -> val -> Dom val m val
  DInt :: Int -> Dom val m val
  DUnit :: Dom val m val
  DBool :: Bool -> Dom val m val
  DIf :: val -> m a -> m a -> Dom val m a
  DString :: Text -> Dom val m val
  DDie :: String -> Dom val m val
