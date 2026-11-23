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


module ConformalWeyl.StarProduct
  ( moyalProduct, moyalBracket, evaluatePolynomial, evalFormal
  ) where

import qualified Data.Map.Strict as M
import Data.Complex
import ConformalWeyl.WeylAlgebra

-- Apply the canonical Poisson bidifferential operator once to a tensor pair.
-- Each branch is (∂x_i f)(∂p_i g) - (∂p_i f)(∂x_i g).
type PairTerm = (Polynomial, Polynomial, Double)

applyP :: Int -> [PairTerm] -> [PairTerm]
applyP n terms = concatMap branch terms
  where
    branch (f,g,c) = concat
      [ [(derivative i f, derivative (i+n) g, c)
        ,(derivative (i+n) f, derivative i g, -c)]
      | i <- [0..n-1]]

combineTerms :: [PairTerm] -> Polynomial
combineTerms = foldl addP zeroP . map (\(f,g,c) -> scaleP (c :+ 0) (mulP f g))

factorial :: Int -> Double
factorial k = fromIntegral (product [1..k])

moyalProduct :: Int -> Int -> Double -> Polynomial -> Polynomial -> FormalSeries
moyalProduct n maxOrder hbar f g
  | n < 0 || maxOrder < 0 = FormalSeries M.empty
  | otherwise = FormalSeries (M.fromList
      [(k, scaleP ((0 :+ (hbar/2)) ^ k / (factorial k :+ 0))
                   (combineTerms (iterate (applyP n) [(f,g,1)]) !! k))
      | k <- [0..maxOrder]])

moyalBracket :: Int -> Int -> Double -> Polynomial -> Polynomial -> FormalSeries
moyalBracket n order h f g =
  let FormalSeries fg = moyalProduct n order h f g
      FormalSeries gf = moyalProduct n order h g f
      comm = M.unionWith addP fg (M.map (scaleP ((-1):+0)) gf)
  in FormalSeries (M.map (scaleP (0 :+ (1/h))) comm)

evaluatePolynomial :: [Double] -> Polynomial -> Either String (Complex Double)
evaluatePolynomial xs (Polynomial terms) =
  if any ((/=length xs) . length . fst) (M.toList terms)
  then Left "point dimension mismatch"
  else Right (sum [c * (product (zipWith (**) xs (map fromIntegral exps)) :+ 0)
                  | (exps,c) <- M.toList terms])

evalFormal :: [Double] -> FormalSeries -> Either String [(Int,Complex Double)]
evalFormal xs (FormalSeries terms) =
  mapM (\(k,p) -> (,) k <$> evaluatePolynomial xs p) (M.toAscList terms)
