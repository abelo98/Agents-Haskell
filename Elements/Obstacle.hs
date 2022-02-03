{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Elements.Obstacle(canMoveObstcs, moveObstc)
where
import Utils.Utils (inList, inMatriz)
import System.Process (CreateProcess(env))
import Environment.Env (ENV(obstc, robots, kids, dirty, playpen,playpenTaken))

canMoveObstcs (x,y) (x1,y1) env 
    | not(inMatriz (x+x1,y+y1) env) = False 
    | inList (x+x1,y+y1) (robots env) ||
      inList (x+x1,y+y1) (kids env) ||
      inList (x+x1,y+y1) (dirty env) ||
      inList (x+x1,y+y1) (playpen env)||
      inList (x+x1,y+y1) (playpenTaken env) = False 
    | inList (x+x1,y+y1) (obstc env)= canMoveObstcs (x+x1,y+y1) (x1,y1) env
    | otherwise = True


moveObstc _ _ [] = []
moveObstc (p1,p2) (x1,y1) (x:xs) 
    | (p1,p2) /= x = x:moveObstc (p1,p2) (x1,y1) xs 
    | otherwise = (p1+x1,p2+y1):moveObstc (p1+x1,p2+y1) (x1,y1) xs