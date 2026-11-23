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


module Main where

import ConformalWeyl.Validation
import ConformalWeyl.WeylAlgebra
import ConformalWeyl.StarProduct

main :: IO ()
main = do
  putStrLn "Conformal Weyl–Fedosov research implementation"
  mapM_ print runCoreValidation
  let x = variableP 2 0
      p = variableP 2 1
  putStrLn "Formal Moyal product x ⋆ p (hbar orders):"
  print (moyalProduct 1 3 1 x p)
