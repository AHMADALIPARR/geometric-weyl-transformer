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


module ConformalWeyl.Curvature
  ( CurvatureData(..), schouten, weylFromRiemann, weylTrace
  , conformalMixedWeylScale, zeroTensor
  ) where

import ConformalWeyl.Tensor

data CurvatureData = CurvatureData
  { riemann :: Tensor       -- R_abcd, all indices lowered
  , ricci :: Tensor         -- R_bd = g^ac R_abcd (convention used here)
  , scalarCurvature :: Double
  , schoutenTensor :: Tensor
  , weylTensor :: Tensor
  } deriving (Eq, Show)

zeroTensor :: [Int] -> Tensor
zeroTensor ds = Tensor ds (replicate (product ds) 0)

schouten :: Int -> Double -> Tensor -> Either String Tensor
schouten n scalar ric
  | n < 3 = Left "Schouten tensor requires dimension >= 3"
  | dims ric /= [n,n] = Left "Ricci tensor shape mismatch"
  | otherwise =
      let factor = 1 / fromIntegral (n-2)
          scalarPart = scalar / (2 * fromIntegral (n-1))
      in Right (mapTensor (*factor) (mapTensor id (Tensor [n,n]
           [ (entry ric i j) - (if i == j then scalarPart else 0)
           | i <- [0..n-1], j <- [0..n-1] ])))
  where
    entry t i j = either (const 0) id (at t [i,j])

weylFromRiemann :: Int -> Tensor -> Tensor -> Either String Tensor
weylFromRiemann n r p
  | n < 3 = Left "Weyl decomposition requires dimension >= 3"
  | dims r /= replicate 4 n || dims p /= [n,n] = Left "tensor shape mismatch"
  | otherwise =
      let v a b c d =
            getR a b c d
            - metric a c * getP b d + metric a d * getP b c
            + metric b c * getP a d - metric b d * getP a c
          metric i j = if i == j then 1 else 0
          getR a b c d = either (const 0) id (at r [a,b,c,d])
          getP a b = either (const 0) id (at p [a,b])
      in Right (Tensor (replicate 4 n)
           [v a b c d | a <- [0..n-1], b <- [0..n-1],
                        c <- [0..n-1], d <- [0..n-1]])

weylTrace :: Int -> Tensor -> Either String Tensor
weylTrace n c
  | dims c /= replicate 4 n = Left "Weyl tensor shape mismatch"
  | otherwise = Right (Tensor [n,n]
      [sum [either (const 0) id (at c [a,b,a,d]) | a <- [0..n-1]]
       | b <- [0..n-1], d <- [0..n-1]])

-- Mixed-index C^a_bcd is conformally invariant. The all-lowered
-- C_abcd instead scales by exp(2 omega).
conformalMixedWeylScale :: Double
conformalMixedWeylScale = 1
