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
        -- possibleMoves = findMoves selectedChld 0 (kids env) env (length (kids env))
        in simulateMoves2 selected_kids (kids env) gen env
 
selection _ 0 = []
selection (x:xs) n = x:selection xs (n-1)


findMoves :: [Int] -> Int -> [(Int, Int)] -> ENV -> Int ->[[(Int, Int)]]
findMoves _ _ _ _ 0 = []
findMoves (0:rest) indx  (x:xs) env totalChld = []:findMoves rest (indx+1) xs env (totalChld-1)
findMoves (1:rest) indx  (x:xs) env totalChld =
    filterCells emptyCell (getAdy x env) env x:
    findMoves rest (indx+1) xs env (totalChld-1)

findMoves2 pos env =
    let mov = filterCells emptyCell (getAdy pos env) env pos
    in if null mov then [pos] else mov

scanKids :: (Int, Int) -> ENV -> Int
scanKids pos env = countKids (getAdy pos env) env

carriedKids = length . filter id

-- simulateMoves [] _ _ taken obsMov newDirt env =
--     ENV (rows env)
--         (columns env)
--         taken
--         obsMov
--         newDirt
--         (playpen env)
--         (robots env)
--         (carryingKid env)
--         (playpenTaken env)

-- simulateMoves ([]:restPossMoves) (x:restOldPositions) gen taken obsMov newDirt env =
--     simulateMoves restPossMoves restOldPositions gen (taken++[x]) obsMov newDirt env

-- simulateMoves (x:restPossMoves) old@(o:restOldPositions) gen taken obsMov newDirt env =
--      let (_,gen1) = randomR (0,1::Int) gen
--          pos = head (pickRandom x 1 gen1)

--         in if not(inList pos taken) && not(inList pos restOldPositions) && not(inList pos newDirt)
--             then
--                 let poss_dirty_cells = disjoin (remove pos x) (obstc env)
--                     (_,gen2) = randomR (0,2::Int) gen
--                     (_,gen3) = randomR (0,3::Int) gen
--                     make_a_mess = newDirt ++ generateDirt (scanKids o env) poss_dirty_cells gen2 gen3
--                 in if inList pos (obstc env)
--                     then
--                     let newObstc = moveObstc pos (getDir pos o) (obstc env)
--                     in simulateMoves restPossMoves restOldPositions gen1 (taken++[pos]) newObstc make_a_mess env
--                     else
--                         simulateMoves restPossMoves restOldPositions gen1 (taken++[pos]) obsMov make_a_mess env
--             else
--                 let deletedPos = remove pos x
--                 in simulateMoves (deletedPos : restPossMoves) old gen1 taken obsMov newDirt env


simulateMoves2 [] _ _ env = env

simulateMoves2 (0:xs) (x:restKidsPos) gen env =
    let new_kids = makeMove x x env
        new_env = ENV (rows env) (columns env) new_kids (obstc env) (dirty env) (playpen env) (robots env) (carryingKid env) (playpenTaken env)
    in simulateMoves2 xs restKidsPos gen new_env

simulateMoves2 (1:xs) (o:restKidsPos) gen env =
     let (_,gen1) = randomR (0,1::Int) gen
         moves = findMoves2 o env
         dest = head (pickRandom moves 1 gen1)
         kids_in_grid = scanKids o env 
         grid = remove dest (getAdy o env)
         new_kids = makeMove o dest env
        in
            let poss_dirty_cells = emptyCellToMess grid env
                (_,gen2) = randomR (0,2::Int) gen
                (_,gen3) = randomR (0,3::Int) gen
                new_dirt = dirty env ++ generateDirt (scanKids o env) poss_dirty_cells gen2 gen3
            in if inList dest (obstc env)
                then
                let newObstc = moveObstc dest (getDir dest o) (obstc env)
                    new_env = ENV (rows env) (columns env) new_kids newObstc new_dirt (playpen env) (robots env) (carryingKid env) (playpenTaken env)
                in simulateMoves2 xs restKidsPos gen1 env
                else
                    let
                         new_env2 = ENV (rows env) (columns env) new_kids (obstc env) new_dirt (playpen env) (robots env) (carryingKid env) (playpenTaken env)
                    in simulateMoves2 xs restKidsPos gen1 new_env2


computeKidsInGrid pos env gen =
    let
        cells_in_my_grid = getAdy pos env ++ [pos]
        (i,_) = randomR (0,length cells_in_my_grid::Int) gen
        center_cell_to_scan = cells_in_my_grid!!i
        new_grid = getAdy center_cell_to_scan env
    in (scanKids center_cell_to_scan env, new_grid)


makeMove o d env = remove o (kids env) ++ [d]