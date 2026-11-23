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


module ConformalWeyl.WeylAlgebra
  ( Monomial, Polynomial(..), FormalSeries(..), zeroP, constantP, variableP
  , addP, scaleP, mulP, derivative, degree, truncateP, addSeries
  ) where

import qualified Data.Map.Strict as M
import Data.Complex

-- Sparse polynomials over complex coefficients; variables are x1..xn,p1..pn.
type Monomial = [Int]
newtype Polynomial = Polynomial (M.Map Monomial (Complex Double))
  deriving (Eq, Show)
newtype FormalSeries = FormalSeries (M.Map Int Polynomial)
  deriving (Eq, Show)

zeroP :: Polynomial
zeroP = Polynomial M.empty

constantP :: Int -> Double -> Polynomial
constantP n x = if x == 0 then zeroP else Polynomial (M.singleton (replicate n 0) (x :+ 0))

variableP :: Int -> Int -> Polynomial
variableP n i = Polynomial (M.singleton [if j == i then 1 else 0 | j <- [0..n-1]] (1 :+ 0))

normalize :: M.Map Monomial (Complex Double) -> Polynomial
normalize = Polynomial . M.filter ((> 1e-14) . magnitude)

addP :: Polynomial -> Polynomial -> Polynomial
addP (Polynomial a) (Polynomial b) = normalize (M.unionWith (+) a b)

scaleP :: Complex Double -> Polynomial -> Polynomial
scaleP c (Polynomial a) = normalize (M.map (c*) a)

mulP :: Polynomial -> Polynomial -> Polynomial
mulP (Polynomial a) (Polynomial b) = normalize $ M.fromListWith (+)
  [(zipWith (+) x y, vx*vy) | (x,vx) <- M.toList a, (y,vy) <- M.toList b]

derivative :: Int -> Polynomial -> Polynomial
derivative i (Polynomial a) = normalize $ M.fromListWith (+)
  [(take i e ++ [e!!i-1] ++ drop (i+1) e, c * fromIntegral (e!!i))
  | (e,c) <- M.toList a, i >= 0, i < length e, e!!i > 0]

degree :: Polynomial -> Int
degree (Polynomial a) = maximum (0 : map (sum . fst) (M.toList a))

truncateP :: Int -> Polynomial -> Polynomial
truncateP d (Polynomial a) = normalize (M.filterWithKey (\e _ -> sum e <= d) a)

addSeries :: FormalSeries -> FormalSeries -> FormalSeries
addSeries (FormalSeries a) (FormalSeries b) =
  FormalSeries (M.filter (/=zeroP) (M.unionWith addP a b))
