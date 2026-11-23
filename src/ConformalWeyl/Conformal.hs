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


module ConformalWeyl.Conformal
  ( ConformalMetric(..), rescaleMetric, transformInverseMetric
  , transformChristoffel, conformalScale
  ) where

import ConformalWeyl.Tensor

data ConformalMetric = ConformalMetric
  { metricMatrix :: Tensor
  , conformalFactor :: Double
  } deriving (Eq, Show)

conformalScale :: Double -> Either String Double
conformalScale w
  | isNaN w || isInfinite w = Left "conformal exponent must be finite"
  | otherwise = Right (exp (2*w))

rescaleMetric :: Double -> Tensor -> Either String Tensor
rescaleMetric w g = case conformalScale w of
  Left e -> Left e
  Right s -> Right (scaleTensor s g)

transformInverseMetric :: Double -> Tensor -> Either String Tensor
transformInverseMetric w gi = case conformalScale w of
  Left e -> Left e
  Right s -> Right (scaleTensor (1/s) gi)

-- Gamma~^c_ab = Gamma^c_ab + delta^c_a omega_b
--              + delta^c_b omega_a - g_ab omega^c.
-- Inputs: Gamma [n,n,n], g [n,n], omegaDown [n], omegaUp [n].
transformChristoffel :: Tensor -> Tensor -> [Double] -> [Double]
                     -> Either String Tensor
transformChristoffel gamma g od ou =
  case (dims gamma, dims g) of
    ([n,n1,n2],[m,m1]) | n == n1 && n == n2 && n == m && m == m1
      && length od == n && length ou == n ->
        let ix a b c = at gamma [a,b,c]
            gij a b = at g [a,b]
            val a b c = do
              base <- ix a b c
              gab <- gij b c
              let d1 = if a == b then od !! c else 0
                  d2 = if a == c then od !! b else 0
              pure (base + d1 + d2 - gab * (ou !! a))
        in do ys <- sequence [val a b c | a <- [0..n-1], b <- [0..n-1], c <- [0..n-1]]
              pure (Tensor [n,n,n] ys)
    _ -> Left "Christoffel/g metric dimensions must be [n,n,n] and [n,n]"
