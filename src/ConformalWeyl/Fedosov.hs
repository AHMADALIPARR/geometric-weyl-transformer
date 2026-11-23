-- This file is part of Geometric Weyl Transformer.
-- Copyright (C) 2026 AHMAD ALI PARR / SnapKitty Research Lab
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Affero General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Affero General Public License for more details.
--
-- You should have received a copy of the GNU Affero General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.


module ConformalWeyl.Fedosov
  ( FedosovConfig(..), FedosovState(..), FedosovError(..)
  , deltaHomotopyCoefficient, validateFedosovConfig, solveFormalRecursion
  ) where

data FedosovConfig = FedosovConfig
  { fiberDimension :: Int
  , maximumFiberDegree :: Int
  , maximumHbarOrder :: Int
  , centralFormClosed :: Bool
  } deriving (Eq, Show)

data FedosovState a = FedosovState
  { recursionDegree :: Int
  , recursionValue :: a
  } deriving (Eq, Show)

data FedosovError
  = InvalidDimension | InvalidTruncation | CentralFormNotClosed
  | RecursionNotIncreasing
  deriving (Eq, Show)

validateFedosovConfig :: FedosovConfig -> Either FedosovError ()
validateFedosovConfig c
  | fiberDimension c <= 0 = Left InvalidDimension
  | maximumFiberDegree c < 0 || maximumHbarOrder c < 0 = Left InvalidTruncation
  | not (centralFormClosed c) = Left CentralFormNotClosed
  | otherwise = Right ()

-- On a homogeneous component with fiber degree p and exterior degree q,
-- delta^{-1} multiplies the contraction by 1/(p+q).
deltaHomotopyCoefficient :: Int -> Int -> Either FedosovError Double
deltaHomotopyCoefficient p q
  | p < 0 || q < 0 = Left InvalidTruncation
  | p+q == 0 = Right 0
  | otherwise = Right (1 / fromIntegral (p+q))

-- Generic filtration-ordered fixed-point recursion. The caller supplies
-- the concrete Fedosov right-hand side. This routine checks degree progress;
-- it does not assert flatness of an arbitrary supplied operator.
solveFormalRecursion :: Int -> (Int -> a -> Either FedosovError a)
                     -> a -> Either FedosovError (FedosovState a)
solveFormalRecursion limit step initial
  | limit < 0 = Left InvalidTruncation
  | otherwise = go 0 initial
  where
    go k x
      | k > limit = Right (FedosovState k x)
      | otherwise = do
          y <- step k x
          go (k+1) y
