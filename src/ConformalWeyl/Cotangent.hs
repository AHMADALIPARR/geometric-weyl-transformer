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


module ConformalWeyl.Cotangent
  ( PhasePoint(..), canonicalOmega, poissonBracket, hamiltonianVector
  ) where

data PhasePoint = PhasePoint { position :: [Double], momentum :: [Double] }
  deriving (Eq, Show)

canonicalOmega :: Int -> [[Double]]
canonicalOmega n =
  [[entry i j | j <- [0..2*n-1]] | i <- [0..2*n-1]]
  where
    entry i j
      | i < n && j == i+n = 1
      | i >= n && j == i-n = -1
      | otherwise = 0

poissonBracket :: [Double] -> [Double] -> [Double] -> Either String Double
poissonBracket gradF gradG nvec
  | length gradF /= 2*n || length gradG /= 2*n =
      Left "gradient length must equal twice phase dimension"
  | otherwise = Right (sum
      [ gradF !! i * gradG !! (i+n) - gradF !! (i+n) * gradG !! i
      | i <- [0..n-1]])
  where n = length nvec

hamiltonianVector :: [Double] -> Either String [Double]
hamiltonianVector gradH
  | odd (length gradH) = Left "phase gradient must have even length"
  | otherwise =
      let n = length gradH `div` 2
      in Right (take n (drop n gradH) ++ map negate (take n gradH))
