{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Elements.Kids(moveKids,carriedKids)
where

import Utils.Utils (getAdy, filterCells, randomNumbers, pickRandom, inList, remove, inMatriz,getDir, disjoin)
import Environment.Environment (ENV, emptyCell, countKids)
import System.Random (newStdGen, Random (randomR))

import Elements.Obstacle (moveObstc)
import Elements.Dirt
import System.Process (CreateProcess(env))
import Environment.Env


moveKids env gen =
    let selectedChld = randomNumbers 2 gen
        possibleMoves = findMoves selectedChld 0 (kids env) env (length (kids env))
        in simulateMoves possibleMoves (kids env) gen [] (obstc env) (dirty env) env


findMoves :: [Int] -> Int -> [(Int, Int)] -> ENV -> Int ->[[(Int, Int)]]
findMoves _ _ _ _ 0 = []
findMoves (0:rest) indx  (x:xs) env totalChld = []:findMoves rest (indx+1) xs env (totalChld-1)
findMoves (1:rest) indx  (x:xs) env totalChld =
    filterCells emptyCell (getAdy x env) env x:
    findMoves rest (indx+1) xs env (totalChld-1)


scanKids :: (Int, Int) -> ENV -> Int
scanKids pos env = countKids (getAdy pos env) env

carriedKids = length . filter id

simulateMoves [] _ _ taken obsMov newDirt env =
    ENV (rows env)
        (columns env)
        taken
        obsMov
        newDirt
        (playpen env)
        (robots env)
        (carryingKid env)
        (playpenTaken env)

simulateMoves ([]:restPossMoves) (x:restOldPositions) gen taken obsMov newDirt env =
    simulateMoves restPossMoves restOldPositions gen (taken++[x]) obsMov newDirt env

simulateMoves (x:restPossMoves) old@(o:restOldPositions) gen taken obsMov newDirt env =
     let (_,gen1) = randomR (0,1::Int) gen
         pos = head (pickRandom x 1 gen1)

        in if not(inList pos taken) && not(inList pos restOldPositions)
            then
                let poss_dirty_cells = disjoin (remove pos x) (obstc env)
                    (_,gen2) = randomR (0,2::Int) gen
                    (_,gen3) = randomR (0,3::Int) gen
                    make_a_mess = newDirt ++ generateDirt (scanKids o env) poss_dirty_cells gen2 gen3
                in if inList pos (obstc env)
                    then
                    let newObstc = moveObstc pos (getDir pos o) (obstc env)
                    in simulateMoves restPossMoves restOldPositions gen1 (taken++[pos]) newObstc make_a_mess env
                    else
                        simulateMoves restPossMoves restOldPositions gen1 (taken++[pos]) obsMov make_a_mess env
            else
                let deletedPos = remove pos x
                in simulateMoves (deletedPos : restPossMoves) old gen1 taken obsMov newDirt env

