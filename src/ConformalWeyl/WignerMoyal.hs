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


module ConformalWeyl.WignerMoyal
  ( ComplexSample, wigner1D, normalizeWigner, discreteMoyalEvolution
  ) where

import Data.Complex

type ComplexSample = Complex Double

-- Midpoint-grid discrete Wigner transform:
-- W(x_j,p_k) = dx/(pi*hbar) sum_l psi*(x_j-l dx) psi(x_j+l dx)
-- exp(-2 i p_k l dx / hbar), with zero extension outside the sample.
wigner1D :: Double -> Double -> [ComplexSample] -> [[Double]]
wigner1D dx hbar psi
  | dx <= 0 || hbar <= 0 = []
  | otherwise =
      [[realPart (dx/(pi*hbar) * sum
          [conjugate (sample (j-l)) * sample (j+l) *
           cis (negate (2*p*fromIntegral l*dx/hbar))
          | l <- [-n..n]]) | p <- momenta] | j <- [0..n-1]]
  where
    n = length psi
    sample i | i < 0 || i >= n = 0
             | otherwise = psi !! i
    momenta = [2*pi*hbar*k/(fromIntegral (max 1 n)*2*dx)
              | k <- [0..n-1]]

normalizeWigner :: Double -> [[Double]] -> Double
normalizeWigner dp w = sum (map sum w) * dp

-- Evolution is supplied as the discrete phase-space RHS. This function
-- performs one explicit Euler step and makes the numerical approximation clear.
discreteMoyalEvolution :: Double -> [[Double]] -> [[Double]] -> Either String [[Double]]
discreteMoyalEvolution dt w rhs
  | dt < 0 = Left "time step must be nonnegative"
  | map length w /= map length rhs = Left "grid shape mismatch"
  | otherwise = Right (zipWith (zipWith (\a b -> a + dt*b)) w rhs)
