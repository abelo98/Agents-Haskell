{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
-- import System.Random(newStdGen)
module App
where
import Utils.Utils(randomNumbers, getAdy, filterCellsRbt)
import Environment.Environment (generateEnv, ENV (robots, ENV, carryingChld, rows, columns, dirty, chld), emptyCellForRobot)
import System.Random (newStdGen)
import Elements.Children (moveKids, carriedKids)
import Elements.Robot (updatePi, bfs, nextStep)
import Elements.Agent (makeMoves)


--En el main hay q chequear condiciones de factibilidad con obstc, ninos, basura y rbts
main :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> IO ()
main t rows columns kids rbts obstcs dirty = do
    gen1 <- newStdGen
    gen2 <- newStdGen
    let
        rnds1 = randomNumbers rows gen1
        rnds2 = randomNumbers columns gen2
        new_env = generateEnv rnds1 rnds2 rows columns kids kids rbts obstcs dirty [False]
        in startSimulation t t 0 kids rbts obstcs dirty new_env --(newEmptyEnv rows columns rbts)


newEmptyEnv n m rbts = ENV n m (-1,-1) [] [] [] [] [] (buildcarryingList rbts) []

buildcarryingList 0 = []
buildcarryingList rbts = False:buildcarryingList (rbts-1)

startSimulation t counter globalCounter kids rbts obstcs dirt env
    | globalCounter == t*6 = print env
    --  counter == t = do
    --     gen1 <- newStdGen
    --     gen2 <- newStdGen
    --     print env
    --     print kids
    --     print "cambiar"
    --     let
    --         n = rows env
    --         m = columns env
    --         rnds1 = randomNumbers n gen1
    --         rnds2 = randomNumbers m gen2
    --         new_kids = kids-carriedKids (carryingChld env)
    --         new_env = generateEnv rnds1 rnds2 n m new_kids kids rbts obstcs dirt (carryingChld env)
    --         in startSimulation t 0 (globalCounter+1) kids rbts obstcs dirt new_env

    | otherwise = do
        gen1 <- newStdGen
        gen2 <- newStdGen
        gen3 <- newStdGen 
        gen4 <- newStdGen 
        print env
        let
            -- moveAgents = makeMoves (robots env) [0] 0 env
            -- in print moveAgents
            envAfterKidsMove = moveKids env gen1 gen2 gen3 gen4
            total_dirt = length (dirty env)
            in startSimulation t (counter+1) (globalCounter+1) kids rbts obstcs total_dirt envAfterKidsMove
