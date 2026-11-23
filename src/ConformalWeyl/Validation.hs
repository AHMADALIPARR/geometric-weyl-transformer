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


module ConformalWeyl.Validation
  ( TestResult(..), near, runCoreValidation
  ) where

import Data.Complex
import ConformalWeyl.Cotangent
import ConformalWeyl.StarProduct
import ConformalWeyl.WeylAlgebra

data TestResult = TestResult { testName :: String, passed :: Bool, detail :: String }
  deriving (Eq, Show)

near :: Double -> Double -> Double -> Bool
near eps a b = abs (a-b) <= eps

runCoreValidation :: [TestResult]
runCoreValidation =
  [ TestResult "canonical Poisson {x,p}=1" (near 1e-12 bracket 1)
      ("computed " ++ show bracket)
  , TestResult "Moyal x star p has i*hbar/2 coefficient"
      (case evalFormal [0,0] productXP of
         Right xs -> lookup 0 xs == Just (0 :+ 0)
                  && lookup 1 xs == Just (0 :+ 0.5)
         Left _ -> False)
      "complex formal coefficient retained"
  , TestResult "Hamiltonian vector field dimension"
      (length (either (const []) id (hamiltonianVector [1,2,3,4])) == 4)
      "four-dimensional phase vector"
  ]
  where
    bracket = either (const 0) id (poissonBracket [1,0] [0,1] [0])
    x = variableP 2 0
    p = variableP 2 1
    productXP = moyalProduct 1 2 1 x p
