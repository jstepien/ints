module Ints (Int(), one, zero, eq, lt, add, mul, sub, format, parse) where

import Data.String (charAt, drop)
import Data.Array (length)

data Bit = O | Z
type Nat = [Bit]
data Int = Pos Nat

instance eqBit :: Eq Bit where
  (==) = refEq
  (/=) = refIneq

zero :: Int
zero = Pos []

one :: Int
one = Pos [O]

add :: Int -> Int -> Int
add (Pos a) (Pos b) = Pos $ add' Z a b
  where add' Z x [] = x
        add' O x [] = add' Z x [O]
        add' c [] x = add' c x []
        add' O (O : xs) (O : ys) = O : add' O xs ys
        add' O (O : xs) (Z : ys) = Z : add' O xs ys
        add' O (Z : xs) (O : ys) = Z : add' O xs ys
        add' O (Z : xs) (Z : ys) = O : add' Z xs ys
        add' Z (O : xs) (O : ys) = Z : add' O xs ys
        add' Z (O : xs) (Z : ys) = O : add' Z xs ys
        add' Z (Z : xs) (O : ys) = O : add' Z xs ys
        add' Z (Z : xs) (Z : ys) = Z : add' Z xs ys

mul :: Int -> Int -> Int
mul _ (Pos []) = zero
mul (Pos []) _ = zero
mul (Pos (Z : xs)) (Pos ys) = mul (Pos xs) (Pos (Z : ys))
mul (Pos (O : xs)) (Pos ys) = (Pos ys) `add` mul (Pos xs) (Pos (Z : ys))

sub :: Int -> Int -> Int
sub (Pos a) (Pos b) = if (Pos a) `lt` (Pos b)
                        then zero
                        else Pos $ sub' Z a b
  where sub' Z x [] = x
        sub' O x [] = sub' Z x [O]
        sub' _ [] _ = []
        sub' O (O : xs) (O : ys) = O : sub' O xs ys
        sub' O (O : xs) (Z : ys) = Z : sub' Z xs ys
        sub' O (Z : xs) (O : ys) = Z : sub' O xs ys
        sub' O (Z : xs) (Z : ys) = O : sub' O xs ys
        sub' Z (O : xs) (O : ys) = Z : sub' Z xs ys
        sub' Z (O : xs) (Z : ys) = O : sub' Z xs ys
        sub' Z (Z : xs) (O : ys) = O : sub' O xs ys
        sub' Z (Z : xs) (Z : ys) = Z : sub' Z xs ys

eq :: Int -> Int -> Boolean
eq (Pos x) (Pos y) = x == y

lt :: Int -> Int -> Boolean
lt (Pos a) (Pos b) = length a < length b || lt' a b
  where lt' [] (_ : _) = true
        lt' _ [] = false
        lt' (O : x) (Z : y) = x /= y && lt' x y
        lt' (Z : x) (O : y) = x == y || lt' x y
        lt' (_ : x) (_ : y) = lt' x y

format :: Int -> String
format (Pos []) = "0"
format (Pos x) = fmt "" $ reverse x
  where fmt str [] = str
        fmt str (Z : xs) = fmt (str ++ "0") xs
        fmt str (O : xs) = fmt (str ++ "1") xs

parse :: String -> Int
parse str = Pos $ reverse $ dropZeroes $ parse' str
  where parse' "" = []
        parse' s = case charAt 0 s of
                     "0" -> Z : rest
                     "1" -> O : rest
                       where rest = parse' $ drop 1 s
        dropZeroes [] = []
        dropZeroes (Z : xs) = dropZeroes xs
        dropZeroes xs@(O : _) = xs

reverse :: forall a . [a] -> [a]
reverse = rev []
  where rev xs [] = xs
        rev ys (x : xs) = rev (x : ys) xs
