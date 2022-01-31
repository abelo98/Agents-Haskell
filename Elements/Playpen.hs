{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Elements.Playpen(emptyPlace,buildPlayPen)
where

import Environment.Env (ENV (playpen, playpenTaken), chld, rows, columns)
import Utils.Utils (disjoin, inList, getAdy)


emptyPlace env = head (playpen env)

buildPlayPen start totalKids env =
    let
        expand = expandForPlaypen start totalKids (getAdy start env) env []
        new_expantion_cell = cells2Corners expand (-1,-1) 10000 (rows env) (columns env)
    in setPriority [new_expantion_cell] expand [] env

-- startx,starty,total_children,stack_ady,env ,taken_ady -> answer
expandForPlaypen :: (Int, Int) -> Int -> [(Int,Int)]-> ENV -> [(Int,Int)] -> [(Int,Int)]
expandForPlaypen start 0 ady env taken = []
expandForPlaypen start n_cldr ady@(e:rest) env taken
    | not (inList start taken)  =
        let next_x = fst e
            next_y = snd e
            new_adys = ady ++ disjoin (getAdy (next_x, next_y) env) ady
        in start:expandForPlaypen (next_x, next_y) (n_cldr-1) new_adys env (taken++[start])
    | otherwise = expandForPlaypen (head rest) n_cldr rest env taken

-- Computes the cell with the minimun distance of all playpen cells to the 4 corners
cells2Corners :: [(Int,Int)] -> (Int,Int)-> Int -> Int -> Int -> (Int,Int)
cells2Corners [] answ dist _ _ = answ
cells2Corners (x:xs) answ dist n m =
    let
        distance_cell = calculateDistance x (0,0) (0,m-1) (0,n-1) (m-1,m-1)
    in if fst distance_cell < dist
       then cells2Corners xs (snd distance_cell) (fst distance_cell) n m
       else cells2Corners xs answ dist n m

-- gets the closest distance among one cell and the 4 corners of the matriz
-- then returns (distance,cell)
calculateDistance :: Integral a => (a, a) -> (a, a) -> (a, a) -> (a, a) -> (a, a) -> (a, (a, a))
calculateDistance pos c1 c2 c3 c4
    | w <= x && w <= y && w <= z = (w,pos)
    | x <= w && x <= y && x <= z = (x,pos)
    | y <= x && y <= w && y <= z = (y,pos)
    | z <= x && z <= y && z <= w = (z,pos)
    where w = manhatamDist pos c1
          x = manhatamDist pos c2
          y = manhatamDist pos c3
          z = manhatamDist pos c4



manhatamDist (x1,y1) (x2,y2) = abs(x1-x2) + abs(y1-y2)

setPriority [] _ answ env = answ
setPriority (u:us) currentPlaypen visited env
    | inList u currentPlaypen =
        let new_ady = us ++ disjoin (getAdy u env) (visited++us)
            new_visited = visited++[u]
        in setPriority new_ady currentPlaypen new_visited env
    | otherwise = setPriority us currentPlaypen visited env