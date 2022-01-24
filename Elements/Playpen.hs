{-# LANGUAGE FlexibleContexts #-}


-- {-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Elements.Playpen(findEmptyPlace)
where

import Environment.Env (centerPlayPen)


findEmptyPlace :: [(Int,Int)] -> Int -> (Int,Int) -> [(Int,Int)]
findEmptyPlace [] _ _ = []
findEmptyPlace (x:xs) dist center
    | d <= dist = x:findEmptyPlace xs d center
    | otherwise = findEmptyPlace xs d center
    where d = calculateDist x center


-- dist calculated with Manhatam distance
calculateDist :: (Int,Int) -> (Int,Int) -> Int
calculateDist (x1,y1) (x2,y2) =  abs(x1-x2) + abs(y1-y2) 
