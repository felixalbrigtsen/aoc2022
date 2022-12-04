import Data.Char

main = do  
  let list = []
  file <- readFile "input.txt"
  let inputLines = lines file
  let pairs = map (splitWhen (==',')) inputLines

  -- Each pair is a set of two numbers separated by a dash
  let limits = map (map parseRange) pairs

  let containedWithin = map rangeListIsContained limits
  
  let containedCount = length $ filter (==True) containedWithin
  print "Part 1: "
  print containedCount

  let overlap = map rangeListOverlap limits
  let overlapCount = length $ filter (==True) overlap
  print "Part 2: "
  print overlapCount


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

-- True if any endpoint of a range is within the other range
rangeOverlaps :: (Int, Int) -> (Int, Int) -> Bool
rangeOverlaps (lo1, hi1) (lo2, hi2)
  | rangeIsContained (lo1, lo1) (lo2, hi2) = True
  | lo2 >= lo1 && lo2 <= hi1 = True
  | hi2 >= lo1 && hi2 <= hi1 = True
  | otherwise = False


-- This is mega dirty, should probably be replaced with a smart map.
rangeListIsContained :: [(Int, Int)] -> Bool
rangeListIsContained ranges = do
  let first = ranges !! 0
  let second = ranges !! 1
  rangeIsContained first second

rangeListOverlap :: [(Int, Int)] -> Bool
rangeListOverlap ranges = do
  let first = ranges !! 0
  let second = ranges !! 1
  rangeOverlaps first second

-- Modified from Prelude.words
splitWhen :: (Char -> Bool) -> String -> [String]
splitWhen p s = case dropWhile p s of
  "" -> []
  s' -> w : splitWhen p s''
    where (w, s'') = break p s'

