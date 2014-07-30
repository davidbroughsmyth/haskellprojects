module Biometrics.Face.EigenFaces where

import Biometrics.Face.FaceDatabase (faceDatabase)
import Numeric.Statistics.PCA
import Codec.BMP

import qualified Data.Vector.Storable as V
import Data.Array

import Data.ByteString (unpack)
import Control.Monad (liftM)
import Data.Either (rights)
import Data.Word (Word8)

import Data.List (nub)
import Data.List.Split (chunksOf)

-- TODO export these to an appropriate place
readDatabase :: IO (Array Int (V.Vector Double))
readDatabase = do
  x <- liftM rights $ mapM readBMP faceDatabase
  let y = map toVector x
  print (nub $ map V.length y)
  return $ listArray (1,length x) (map toVector x)

convert :: [BMP] -> [V.Vector Double]
convert = map toVector

toVector :: BMP -> V.Vector Double
toVector = toDouble . unpack . unpackBMPToRGBA32

toDouble :: [Word8] -> V.Vector Double
toDouble = V.fromList . map (scale . average) . chunksOf 4

average :: [Word8] -> Word8
average p@(_:_:_:_:[]) = (sum $ map fromIntegral p) `div` 4
average _            = error "unexpected image format"

scale :: Word8 -> Double
scale x = (fromIntegral x) / 255.0
