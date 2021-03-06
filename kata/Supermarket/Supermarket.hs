{-

Coding kata taken from http://nimblepros.com/media/36760/supermarket%20pricing%20kata.pdf

-}
module SuperMarket where

import Test.Hspec
import Test.QuickCheck
import Data.Monoid

data Money = Cents Integer deriving (Show,Eq)

dollar :: Integer -> Money
dollar x = Cents (x * 100)

cents :: Integer -> Money
cents = Cents 

data Item = Loaf
          | Noodles
          | Soup

instance Monoid Money where
  mempty = Cents 0
  mappend (Cents x) (Cents y) = Cents (x + y)

priceOf' :: Item -> Money
priceOf' Loaf    = dollar 1
priceOf' Noodles = cents 50
priceOf' Soup    = dollar 2 

priceOf :: [Item] -> Money
priceOf = mconcat . map priceOf' 

main :: IO ()
main = hspec $ do
  describe "Supermarket pricing" $ do
    it "a loaf of bread is a dollar" $ do
      priceOf' Loaf `shouldBe` Cents 100
    it "a pack of noodles is 50 cents" $ do
      priceOf' Noodles `shouldBe` Cents 50
    it "a can of soup is 2 dollars" $ do
      priceOf' Soup `shouldBe` Cents 200
    it "a loaf, some noodles and soup is $3.50" $ do
      priceOf [Loaf,Noodles,Soup] `shouldBe` Cents 350
