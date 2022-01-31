{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Elements.Children(moveKids,carriedKids)
where

import Utils.Utils (getAdy, filterCells, randomNumbers, pickRandom, inList, remove, inMatriz,getDir, disjoin)
import Environment.Environment (ENV, emptyCell, countKids)
import System.Random (newStdGen)
import Environment.Env
    ( ENV(chld, carryingChld, playpenTaken, monitor),
      ENV(obstc),
      ENV(rows),
      ENV(ENV),
      ENV(columns),
      ENV(dirty),
      ENV(playpen),
      ENV(robots) )
import Elements.Obstacle (moveObstc)
import Elements.Dirt
import System.Process (CreateProcess(env))


moveKids env binaryGen natGen genToPick genToMess =
    let selectedChld = randomNumbers 2 natGen
        possibleMoves = findMoves selectedChld 0 (chld env) env (length (chld env))
        in simulateMoves possibleMoves (chld env) natGen genToPick genToMess [] (obstc env) [] env


findMoves :: [Int] -> Int -> [(Int, Int)] -> ENV -> Int ->[[(Int, Int)]]
findMoves _ _ _ _ 0 = []
findMoves (0:rest) indx  (x:xs) env totalChld = []:findMoves rest (indx+1) xs env (totalChld-1)
findMoves (1:rest) indx  (x:xs) env totalChld =
    filterCells emptyCell (getAdy x env) env x:
    findMoves rest (indx+1) xs env (totalChld-1)


scanKids :: (Int, Int) -> ENV -> Int
scanKids pos env = countKids (getAdy pos env) env

simulateMoves [] _ _ _ _ taken obsMov newDirt env =
    ENV (rows env)
        (columns env)
        (monitor env)
        taken
        obsMov
        (dirty env ++ newDirt)
        (playpen env)
        (robots env)
        (carryingChld env)
        (playpenTaken env)

simulateMoves ([]:restPossMoves) (x:restOldMoves) gen1 gen2 gen3 taken obsMov newDirt env =
    simulateMoves restPossMoves restOldMoves gen1 gen2 gen3 (taken++[x]) obsMov newDirt env

simulateMoves (x:restPossMoves) old@(o:restOldMoves) gen1 gen2 gen3 taken obsMov newDirt env =
     let pos = head (pickRandom x 1 gen1)
        in if not(inList pos taken) && not(inList pos restOldMoves)
            then
                let poss_dirty_cells = disjoin (remove pos x) (obstc env)
                    make_a_mess = generateDirt (scanKids o env) poss_dirty_cells gen2 gen3
                in if inList pos (obstc env)
                    then
                    let newObstc = moveObstc pos (getDir pos o) (obstc env)
                    in simulateMoves restPossMoves restOldMoves gen1 gen2 gen3 (taken++[pos]) newObstc make_a_mess env
                    else
                        simulateMoves restPossMoves restOldMoves gen1 gen2 gen3 (taken++[pos]) obsMov make_a_mess env
            else
                let deletedPos = remove pos x
                in simulateMoves (deletedPos : restPossMoves) old gen1 gen2 gen3 taken obsMov newDirt env

carriedKids = length . filter id