import Data.Char

main = do  
  let list = []
  file <- readFile "input.txt"
  let inputLines = lines file
  let stringpairs = map (splitWhen (==',')) inputLines

  let listpairs = map (map parseRange) stringpairs
  let pairs = map (\x -> (head x, last x)) listpairs

  -- Each line of input has now gone from "1-2,3-4" to ((1,2),(3,4))

  let containedWithin = map (uncurry rangeIsContained) pairs
  let containedCount = length $ filter (==True) containedWithin
  print "Part 1: "
  print containedCount

  let overlap = map (uncurry rangeOverlaps) pairs
  let overlapCount = length $ filter (==True) overlap
  print "Part 2: "
  print overlapCount


-- "1-3" -> (1,3)
parseRange :: String -> (Int, Int)
parseRange pair = do
  let numbers = splitWhen (=='-') pair
  let first = read (numbers !! 0) :: Int
  let second = read (numbers !! 1) :: Int
  (first, second)

-- True if the first range is entirely contained in the second range, or vice versa
rangeIsContained :: (Int, Int) -> (Int, Int) -> Bool
rangeIsContained (lo1, hi1) (lo2, hi2)
  | lo1 <= lo2 && hi1 >= hi2 = True
  | lo1 >= lo2 && hi1 <= hi2 = True
  | otherwise = False

-- True if any part of the two ranges overlap
rangeOverlaps :: (Int, Int) -> (Int, Int) -> Bool
rangeOverlaps (lo1, hi1) (lo2, hi2)
  | rangeIsContained (lo1, lo1) (lo2, hi2) = True
  | lo2 >= lo1 && lo2 <= hi1 = True
  | hi2 >= lo1 && hi2 <= hi1 = True
  | otherwise = False

-- Modified from Prelude.words
splitWhen :: (Char -> Bool) -> String -> [String]
splitWhen p s = case dropWhile p s of
  "" -> []
  s' -> w : splitWhen p s''
    where (w, s'') = break p s'

