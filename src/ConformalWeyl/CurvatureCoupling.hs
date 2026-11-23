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


module ConformalWeyl.CurvatureCoupling
  ( CentralTwoForm(..), WeylCoupling(..), validateCentralCoupling
  , unresolvedWeylCoupling
  ) where

import ConformalWeyl.Tensor

data CentralTwoForm = CentralTwoForm
  { phaseFormDimension :: Int
  , twoFormComponents :: Tensor
  , isClosed :: Bool
  } deriving (Eq, Show)

data WeylCoupling = WeylCoupling
  { baseWeylTensor :: Tensor
  , inducedCentralForm :: CentralTwoForm
  , couplingOrder :: Int
  , couplingParameter :: Double
  } deriving (Eq, Show)

validateCentralCoupling :: WeylCoupling -> Either String ()
validateCentralCoupling c
  | couplingOrder c < 0 = Left "coupling order must be nonnegative"
  | phaseFormDimension form <= 0 = Left "phase dimension must be positive"
  | dims (twoFormComponents form) /= [phaseFormDimension form, phaseFormDimension form] =
      Left "coupling must be a phase-space two-form"
  | not (isClosed form) = Left "central Fedosov two-form must be closed"
  | otherwise = Right ()
  where form = inducedCentralForm c

-- This constructor intentionally refuses to manufacture a coupling from C_abcd.
-- A tensorial map C -> closed phase-space 2-form and its conformal law
-- remain research obligations; an arbitrary four-tensor is not a 2-form.
unresolvedWeylCoupling :: Tensor -> Either String WeylCoupling
unresolvedWeylCoupling _ =
  Left "unresolved research: supply a proved tensorial closed 2-form K_C"
