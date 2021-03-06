module Ints (Int(), one, zero, eq, lt, add, mul, div, sub, format, parse) where

import Prelude hiding (one, zero)
import Data.String (charAt, drop)
import Data.Array (length, map, range, append, concat, take, reverse)
import Data.Maybe

data Bit = O | Z
type Nat = [Bit]
data Int = Pos Nat | Neg Nat

instance eqBit :: Eq Bit where
  (==) = refEq
  (/=) = refIneq

zero :: Int
zero = Pos []

one :: Int
one = Pos [O]

neg :: Int -> Int
neg (Pos a) = Neg a
neg (Neg a) = Pos a

add :: Int -> Int -> Int
add (Neg a) (Neg b) = neg $ add (Pos a) (Pos b)
add (Pos a) (Neg b) = (Pos a) `sub` (Pos b)
add (Neg a) (Pos b) = (Pos b) `sub` (Pos a)
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
mul (Neg x) (Neg y) = (Pos x) `mul` (Pos y)
mul (Neg x) (Pos y) = neg $ (Pos x) `mul` (Pos y)
mul (Pos x) (Neg y) = (Neg x) `mul` (Pos y)
mul (Pos x) (Pos y) = mul' zero x y
  where mul' acc []       _  = acc
        mul' acc _        [] = acc
        mul' acc (Z : as) bs = mul' acc                as (Z : bs)
        mul' acc (O : as) bs = mul' (acc `add` Pos bs) as (Z : bs)

sub :: Int -> Int -> Int
sub (Pos a) (Neg b) = (Pos a) `add` (Pos b)
sub (Neg a) (Pos b) = neg $ (Pos a) `add` (Pos b)
sub (Neg a) (Neg b) = (Pos b) `sub` (Pos a)
sub (Pos a) (Pos b) = if (Pos a) `lt` (Pos b)
                        then neg $ (Pos b) `sub` (Pos a)
                        else Pos $ dropZeroes $ sub' Z a b
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

div :: Int -> Int -> Maybe Int
div (Neg a) (Neg b)  = div (Pos a) (Pos b)
div (Neg a) (Pos b)  = div (Pos a) (Neg b)
div (Pos a) (Neg b)  = neg <$> div (Pos a) (Pos b)
div   _     (Pos []) = Nothing
div (Pos a) (Pos b)  | length a < length b = Just zero
div (Pos a) (Pos b)  = Just $ Pos $ hlp (reverse a) pads []
  where pads = map padWithZeros (range lengthDiff 0)
        zeroes 0 = []
        zeroes n = Z : zeroes (n - 1)
        padWithZeros n = (reverse b) `append` zeroes n
        lengthDiff = length a - length b
        hlp _  []         acc = dropZeroes acc
        hlp xs (ys : yss) acc = recur numeratorIsLesser
          where numeratorIsLesser = length xs < length ys
                bitsToPos bits = Pos $ reverse bits
                posToBits (Pos bits) = reverse bits
                recur true  = hlp xs yss (Z : acc)
                recur false = let diff = bitsToPos xs `sub` bitsToPos ys in
                                  if diff `lt` zero
                                     then recur true
                                     else hlp (posToBits diff) yss (O : acc)


eq :: Int -> Int -> Boolean
eq (Pos x) (Pos y) = x == y
eq (Neg x) (Neg y) = x == y
eq _ _ = false

lt :: Int -> Int -> Boolean
lt (Neg a) (Neg b) = a /= b && not ((Pos a) `lt` (Pos b))
lt (Neg _) (Pos _) = true
lt (Pos _) (Neg _) = false
lt (Pos a) (Pos b) = length a < length b || lt' a b
  where lt' [] (_ : _) = true
        lt' _ [] = false
        lt' (O : x) (Z : y) = x /= y && lt' x y
        lt' (Z : x) (O : y) = x == y || lt' x y
        lt' (_ : x) (_ : y) = lt' x y

format :: Int -> String
format (Neg x) = "-" ++ format (Pos x)
format (Pos []) = "0"
format (Pos x) = fmt "" $ reverse x
  where fmt str [] = str
        fmt str (Z : xs) = fmt (str ++ "0") xs
        fmt str (O : xs) = fmt (str ++ "1") xs

parse :: String -> Int
parse str = sign $ dropZeroes $ reverse $ parse' $ withoutMinus
  where parse' "" = []
        parse' s = case charAt 0 s of
                     "0" -> Z : rest
                     "1" -> O : rest
                       where rest = parse' $ drop 1 s
        negative = charAt 0 str == "-"
        withoutMinus = if negative then drop 1 str else str
        sign = if negative then Neg else Pos

type Seen1 = Boolean
type Index = Number
data Last1 = Last1 Seen1 Index

-- Removes most significant zeroes.
dropZeroes :: Nat -> Nat
dropZeroes [] = []
dropZeroes bits = filtered $ fold bits
  where filtered (Last1 false _)   = []
        filtered (Last1 true  n) = take n bits
        fold = foldr removeZeroes
          where foldr f [] = Last1 false (length bits)
                foldr f (x:xs) = f x (fold xs)
        removeZeroes _ (Last1 true  n) = Last1 true  n
        removeZeroes O (Last1 false n) = Last1 true  n
        removeZeroes Z (Last1 false n) = Last1 false (n - 1)
