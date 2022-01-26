{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Elements.Children(moveKids)
where

import Utils.Utils (getAdy, filterCells, randomNumbers, pickRandom, inList, remove, inMatriz,getDir, disjoin)
import Environment.Environment (ENV, emptyCell)
import System.Random (newStdGen)
import Environment.Env
    ( ENV(chld, carryingChld, centerPlayPen, playpenTaken),
      ENV(obstc),
      ENV(rows),
      ENV(ENV),
      ENV(columns),
      ENV(dirty),
      ENV(playpen),
      ENV(robots) )
import Elements.Obstacle (moveObstc)


moveKids env totalChld binaryGen natGen =
    let selectedChld = randomNumbers 2 binaryGen
        possibleMoves = findMoves selectedChld 0 (chld env) env totalChld
        kids_to_move = disjoin (chld env) (playpenTaken env)
        in simulateMoves possibleMoves kids_to_move natGen [] (obstc env) env


findMoves :: [Int] -> Int -> [(Int, Int)] -> ENV -> Int ->[[(Int, Int)]]
findMoves _ _ _ _ 0 = []
findMoves (0:rest) indx  (x:xs) env totalChld = []:findMoves rest (indx+1) xs env (totalChld-1)
findMoves (1:rest) indx  (x:xs) env totalChld =
    filterCells emptyCell (getAdy x env) env x:
    findMoves rest (indx+1) xs env (totalChld-1)




simulateMoves [] _ _ taken obsMov env = 
    ENV (rows env) 
        (columns env) 
        (centerPlayPen env) 
        taken obsMov 
        (dirty env) 
        (playpen env) 
        (robots env) 
        (carryingChld env) 
        (playpenTaken env)
simulateMoves ([]:restPossMoves) (x:restOldMoves) gen taken obsMov env =
    simulateMoves restPossMoves restOldMoves gen (taken++[x]) obsMov env
simulateMoves (x:restPossMoves) old@(o:restOldMoves) gen taken obsMov env =
     let pos = pickRandom x gen
        in if not(inList pos taken) && not(inList pos restOldMoves)
            then
                if inList pos (obstc env)
                    then
                    let newObstc = moveObstc pos (getDir pos o) (obstc env)
                    in simulateMoves restPossMoves restOldMoves gen (taken++[pos]) newObstc env
                    else
                        simulateMoves restPossMoves restOldMoves gen (taken++[pos]) obsMov env
            else
                let deletedPos = remove pos x
                in simulateMoves ([deletedPos]++restPossMoves) old gen taken obsMov env
