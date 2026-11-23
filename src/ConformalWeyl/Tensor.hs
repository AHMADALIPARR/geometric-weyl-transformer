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


module ConformalWeyl.Tensor
  ( Tensor(..), tensor, dims, at, mapTensor, zipTensor, scaleTensor
  , addTensor, transpose2, contractFirstThird, TensorError(..)
  ) where

data Tensor = Tensor { dims :: [Int], entries :: [Double] }
  deriving (Eq, Show)

data TensorError = BadShape | BadIndex | NotRankTwo | BadContraction
  deriving (Eq, Show)

tensor :: [Int] -> [Double] -> Either TensorError Tensor
tensor ds xs
  | any (<0) ds = Left BadShape
  | product ds /= length xs = Left BadShape
  | otherwise = Right (Tensor ds xs)

strides :: [Int] -> [Int]
strides ds = tail (scanr (*) 1 ds)

linear :: [Int] -> [Int] -> Maybe Int
linear ds is
  | length ds /= length is = Nothing
  | or (zipWith (\d i -> i < 0 || i >= d) ds is) = Nothing
  | otherwise = Just (sum (zipWith (*) is (strides ds)))

at :: Tensor -> [Int] -> Either TensorError Double
at (Tensor ds xs) is = maybe (Left BadIndex) (Right . (xs !!)) (linear ds is)

mapTensor :: (Double -> Double) -> Tensor -> Tensor
mapTensor f (Tensor ds xs) = Tensor ds (map f xs)

zipTensor :: (Double -> Double -> Double) -> Tensor -> Tensor -> Either TensorError Tensor
zipTensor f (Tensor da a) (Tensor db b)
  | da /= db = Left BadShape
  | otherwise = Right (Tensor da (zipWith f a b))

scaleTensor :: Double -> Tensor -> Tensor
scaleTensor c = mapTensor (c *)

addTensor :: Tensor -> Tensor -> Either TensorError Tensor
addTensor = zipTensor (+)

transpose2 :: Tensor -> Either TensorError Tensor
transpose2 (Tensor [n,m] xs) =
  Right (Tensor [m,n] [xs !! (i*m+j) | j <- [0..m-1], i <- [0..n-1]])
transpose2 _ = Left NotRankTwo

-- Contract axes 0 and 2, retaining all other axes in their original order.
contractFirstThird :: Tensor -> Either TensorError Tensor
contractFirstThird (Tensor ds xs)
  | length ds < 3 || head ds /= ds !! 2 = Left BadContraction
  | otherwise =
      let n = head ds
          outDims = take 1 (drop 1 ds) ++ drop 3 ds
          outIndices = sequence (map (\d -> [0..d-1]) outDims)
          value is = sum [lookupValue (insertContract is k) | k <- [0..n-1]]
          insertContract is k = [k] ++ take 1 is ++ [k] ++ drop 1 is
          lookupValue is = case linear ds is of
            Nothing -> 0
            Just ix -> xs !! ix
      in Right (Tensor outDims (map value outIndices))
contractFirstThird _ = Left BadContraction
