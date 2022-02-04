{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Elements.Kids(moveKids,carriedKids)
where

import Utils.Utils (getAdy, filterCells, randomNumbers, pickRandom, inList, remove, inMatriz,getDir, disjoin)
import Environment.Environment (ENV, emptyCell, countKids, emptyCellToMess)
import System.Random (newStdGen, Random (randomR))

import Elements.Obstacle (moveObstc)
import Elements.Dirt
import System.Process (CreateProcess(env))
import Environment.Env


moveKids env gen =
    let binarySec = randomNumbers 2 gen
        selected_kids = selection binarySec (length (kids env))
        in simulateMoves selected_kids (kids env) gen env
 
selection _ 0 = []
selection (x:xs) n = x:selection xs (n-1)


findMoves pos env =
    let mov = filterCells emptyCell (getAdy pos env) env pos
    in if null mov then [pos] else mov

scanKids :: (Int, Int) -> ENV -> Int
scanKids pos env = countKids (getAdy pos env) env

carriedKids = length . filter id

computeKidsInGrid pos env gen =
    let
        cells_in_my_grid = getAdy pos env ++ [pos]
        (i,_) = randomR (0,(length cells_in_my_grid-1)::Int) gen
        center_cell_to_scan = cells_in_my_grid!!i
        new_grid = getAdy center_cell_to_scan env
    in (scanKids center_cell_to_scan env, new_grid)


makeMove o d env = remove o (kids env) ++ [d]

simulateMoves [] _ _ env = env

simulateMoves (0:xs) (x:restKidsPos) gen env =
    simulateMoves xs restKidsPos gen env

simulateMoves (1:xs) (o:restKidsPos) gen env =
     let (_,gen1) = randomR (0,1::Int) gen
         moves = findMoves o env
         dest = head (pickRandom moves 1 gen1)
         (kids_in_grid,grid) = computeKidsInGrid o env gen1
         grid2 = remove dest grid
         new_kids = makeMove o dest env
        in
            let poss_dirty_cells = emptyCellToMess grid2 env
                (_,gen2) = randomR (0,2::Int) gen
                (_,gen3) = randomR (0,3::Int) gen
                new_dirt = dirty env ++ generateDirt (scanKids o env) poss_dirty_cells gen2 gen3
            in if inList dest (obstc env)
                then
                let newObstc = moveObstc dest (getDir dest o) (obstc env)
                    new_env = ENV (rows env) (columns env) new_kids newObstc new_dirt (playpen env) (robots env) (carryingKid env) (playpenTaken env)
                in simulateMoves xs restKidsPos gen1 env
                else
                    let
                         new_env2 = ENV (rows env) (columns env) new_kids (obstc env) new_dirt (playpen env) (robots env) (carryingKid env) (playpenTaken env)
                    in simulateMoves xs restKidsPos gen1 new_env2


