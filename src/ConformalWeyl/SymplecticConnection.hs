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


module ConformalWeyl.SymplecticConnection
  ( SymplecticConnection(..), validateConnection, symplecticCompatibilityResidual
  ) where

data SymplecticConnection = SymplecticConnection
  { phaseDimension :: Int
  , coefficients :: [[[Double]]] -- Gamma^a_bc
  } deriving (Eq, Show)

validateConnection :: SymplecticConnection -> Either String ()
validateConnection c
  | phaseDimension c <= 0 = Left "phase dimension must be positive"
  | length (coefficients c) /= phaseDimension c = Left "upper index dimension mismatch"
  | any ((/= phaseDimension c) . length) (coefficients c) = Left "lower index dimension mismatch"
  | any (any ((/= phaseDimension c) . length)) (coefficients c) = Left "lower index dimension mismatch"
  | otherwise = Right ()

-- For constant canonical omega, nabla_A omega_BC = 0 requires
-- Gamma^D_AB omega_DC + Gamma^D_AC omega_BD = 0.
-- This checker takes a supplied omega matrix.
symplecticCompatibilityResidual :: SymplecticConnection -> [[Double]] -> Either String Double
symplecticCompatibilityResidual c omega = do
  validateConnection c
  let n = phaseDimension c
  if length omega /= n || any ((/=n) . length) omega
    then Left "omega shape mismatch"
    else Right (maximum (0 :
      [ abs (sum [coefficients c !! d !! a !! b * omega !! d !! e
                + coefficients c !! d !! a !! e * omega !! b !! d
                 | d <- [0..n-1]])
      | a <- [0..n-1], b <- [0..n-1], e <- [0..n-1]]))
