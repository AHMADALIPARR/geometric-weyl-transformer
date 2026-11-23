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


module ConformalWeyl.ConformalTransport
  ( ConformalWeight(..), WeightedSymbol(..), TransportLaw(..)
  , rescaleWeightedValue, checkIntertwining
  ) where

data ConformalWeight = ConformalWeight { densityWeight :: Double }
  deriving (Eq, Show)

data WeightedSymbol a = WeightedSymbol
  { weight :: ConformalWeight, payload :: a }
  deriving (Eq, Show)

data TransportLaw = TransportLaw
  { sourceScaleExponent :: Double
  , targetScaleExponent :: Double
  } deriving (Eq, Show)

rescaleWeightedValue :: Double -> ConformalWeight -> Double -> Either String Double
rescaleWeightedValue omega (ConformalWeight w) value
  | isNaN omega || isInfinite omega = Left "non-finite conformal exponent"
  | otherwise = Right (exp (w*omega) * value)

-- Numerical diagnostic for a proposed intertwiner on supplied values.
checkIntertwining :: (Double -> Double -> Double)
                  -> (Double -> Double -> Double)
                  -> (Double -> Double) -> Double -> Double -> Double
                  -> Double
checkIntertwining starSource starTarget transport f g =
  abs (transport (starSource f g) -
       starTarget (transport f) (transport g))
