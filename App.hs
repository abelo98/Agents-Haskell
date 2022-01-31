{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
-- import System.Random(newStdGen)
module App
where
import Utils.Utils(randomNumbers, getAdy, filterCellsRbt)
import Environment.Environment (generateEnv, ENV (robots, ENV, carryingChld, rows, columns, dirty, chld), emptyCellForRobot, finalState)
import System.Random (newStdGen)
import Elements.Children (moveKids, carriedKids)
import Elements.Robot (updatePi, bfs, nextStep)
import Elements.Agent (makeMoves)
import Environment.Statistics (calculateDirtPercent)


--En el main hay q chequear condiciones de factibilidad con obstc, ninos, basura y rbts
main :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> IO ()
main t rows columns kids rbts obstcs dirty rbtType = do
    gen1 <- newStdGen
    gen2 <- newStdGen
    let
        -- rnds1 = randomNumbers rows gen1
        -- rnds2 = randomNumbers columns gen2
        -- new_env = generateEnv rnds1 rnds2 rows columns kids kids rbts obstcs dirty (buildList rbts False)
        rbts_types = buildList rbts rbtType
        in startSimulation t t 0 kids rbts obstcs dirty rbts_types (newEmptyEnv rows columns rbts)


newEmptyEnv n m rbts = ENV n m [] [] [] [] [] (buildList rbts False) []

buildList 0 _ = []
buildList rbts value = value:buildList (rbts-1) value

startSimulation t counter globalCounter kids rbts obstcs dirt rbtType env
    | finalState env && globalCounter /= 0 = print ("final",env)
    | globalCounter == t*6 = print (env, calculateDirtPercent env)
    | counter == t = do
        gen1 <- newStdGen
        gen2 <- newStdGen
        print env
        print kids
        print "cambiar"
        let
            n = rows env
            m = columns env
            rnds1 = randomNumbers n gen1
            rnds2 = randomNumbers m gen2
            new_kids = kids-carriedKids (carryingChld env)
            new_env = generateEnv rnds1 rnds2 n m new_kids kids rbts obstcs dirt (carryingChld env)
            in startSimulation t 0 (globalCounter+1) kids rbts obstcs dirt rbtType new_env

    | otherwise = do
        gen1 <- newStdGen
        gen2 <- newStdGen
        gen3 <- newStdGen
        gen4 <- newStdGen
        print env
        print rbtType
        let
            moveAgents = makeMoves (robots env) rbtType 0 env
            envAfterKidsMove = moveKids moveAgents gen1 gen2 gen3 gen4
            total_dirt = length (dirty envAfterKidsMove)

         in if t == counter+1
            then startSimulation t (counter+1) globalCounter kids rbts obstcs total_dirt rbtType envAfterKidsMove
            else startSimulation t (counter+1) (globalCounter+1) kids rbts obstcs total_dirt rbtType envAfterKidsMove


