  -- main.hs as written by me, thuroughly fixed by <https://github.com/h7x4>
main :: IO ()
main = do  
  file <- readFile "input.txt"
  let
    pairs :: [((Int, Int), (Int, Int))]
    pairs = inputLinesToPairs file

  putStrLn "Part 1: "
  print $ part1 pairs

  putStrLn "Part 2: "
  print $ part2 pairs

-- Map each line of input from "1-2,3-4" to ((1,2),(3,4))
inputLinesToPairs :: String -> [((Int, Int), (Int, Int))]
inputLinesToPairs input = result
  where
  stringpairs :: [[String]]
  stringpairs = map (splitWhen (==',')) $ lines input 

  parseRange :: String -> (Int, Int)
  parseRange pair = (read first, read second)
    where
      (first:second:_) = splitWhen (=='-') pair 

  result :: [((Int, Int), (Int, Int))]
  result = map (\x -> (head x, last x)) $ map (map parseRange) stringpairs


part1 :: [((Int, Int), (Int, Int))] -> Int
part1 = length . filter (uncurry rangeIsContained)

part2 :: [((Int, Int), (Int, Int))] -> Int
part2 = length . filter (uncurry rangeOverlaps)

-- True if any part of the two ranges overlap
rangeOverlaps :: (Int, Int) -> (Int, Int) -> Bool
rangeOverlaps (lo1, hi1) (lo2, hi2) = rangeIsContained (lo1, lo1) (lo2, hi2)
                                   || (lo2 >= lo1 && lo2 <= hi1)
                                   || (hi2 >= lo1 && hi2 <= hi1)

-- True if the first range is entirely contained in the second range, or vice versa
rangeIsContained :: (Int, Int) -> (Int, Int) -> Bool
rangeIsContained (lo1, hi1) (lo2, hi2) = (lo1 <= lo2 && hi1 >= hi2)
                                      || (lo1 >= lo2 && hi1 <= hi2)

-- Modified from Prelude.words
splitWhen :: (Char -> Bool) -> String -> [String]
splitWhen p s = case dropWhile p s of
  "" -> []
  s' -> w : splitWhen p s''
    where (w, s'') = break p s'

