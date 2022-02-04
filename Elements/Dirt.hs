{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Elements.Dirt(generateDirt)
where
    

import Utils.Utils (pickRandom, randomNumbers)
import System.Random (StdGen, newStdGen)


generateDirt :: Int -> [(Int,Int)] -> StdGen -> StdGen-> [(Int,Int)]
generateDirt _ [] _ _ = [] 
generateDirt kidsAround ady genToPick genToMess 
    | kidsAround == 0 = let mess = head (randomNumbers 2 genToMess)
                        in pickRandom ady mess genToPick
    | kidsAround == 1 =  let mess = head (randomNumbers 4 genToMess)
                        in pickRandom ady mess genToPick
    | otherwise = let mess = head (randomNumbers 7 genToMess)
                  in pickRandom ady mess genToPick
