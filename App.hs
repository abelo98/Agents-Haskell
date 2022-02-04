{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
-- import System.Random(newStdGen)
module App
where
import Utils.Utils(randomNumbers, getAdy, filterCellsRbt)

import System.Random (newStdGen)
import Elements.Kids (moveKids, carriedKids)
import Elements.Robot (updatePi, bfs, nextStep)
import Elements.Agent (makeMoves)
import Environment.Statistics (calculateDirtPercent, finalState, victOrLoss, mean)
import GHC.IO (unsafePerformIO)
import Environment.Env
import Environment.Environment (generateEnv, generateEnv2)


--En el main hay q chequear condiciones de factibilidad con obstc, ninos, basura y rbts
main :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int ->[IO Float]->Int->Int->Int-> IO ()
main _ _ _ _ _ _ _ _ allPercents vict loss 0 = print (unsafePerformIO(mean allPercents),vict,loss)
main t rows columns kids rbts obstcs dirty rbtType allPercents vict loss noSim = do
    let
        rbts_types = buildList rbts rbtType
        perct = startSimulation t t 0 kids rbts obstcs dirty rbts_types (newEmptyEnv rows columns rbts)
        (v,l) = victOrLoss perct
        in main t rows columns kids rbts obstcs dirty rbtType (allPercents++[perct]) (vict+v) (loss+l) (noSim-1)

main2 :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> IO ()
main2 t rows columns kids rbts obstcs dirty rbtType = do
    let
        rbts_types = buildList rbts rbtType
        z = startSimulation2 t t 0 kids rbts obstcs dirty rbts_types (newEmptyEnv rows columns rbts)
        in z




newEmptyEnv n m rbts = ENV n m [] [] [] [] [] (buildList rbts False) []

buildList 0 _ = []
buildList rbts value = value:buildList (rbts-1) value

startSimulation t counter globalCounter kids rbts obstcs dirt rbtType env
    | finalState env && globalCounter /= 0 = calculateDirtPercent env
    | globalCounter == t*100 = calculateDirtPercent env
    | counter == t = do
        gen1 <- newStdGen
        gen2 <- newStdGen
        let
            n = rows env
            m = columns env
            rnds1 = randomNumbers n gen1
            rnds2 = randomNumbers m gen2
            new_kids = kids-carriedKids (carryingKid env)
            new_env = generateEnv rnds1 rnds2 n m new_kids kids rbts obstcs dirt (carryingKid env)
            in startSimulation t 0 (globalCounter+1) kids rbts obstcs dirt rbtType new_env

    | otherwise = do
        gen <- newStdGen
        -- print env
        -- print rbtType
        let
            moveAgents = makeMoves (robots env) rbtType 0 env
            envAfterKidsMove = moveKids moveAgents gen 
            total_dirt = length (dirty envAfterKidsMove)

         in if t == counter+1
            then startSimulation t (counter+1) globalCounter kids rbts obstcs total_dirt rbtType envAfterKidsMove
            else startSimulation t (counter+1) (globalCounter+1) kids rbts obstcs total_dirt rbtType envAfterKidsMove


startSimulation2 t counter globalCounter kids rbts obstcs dirt rbtType env
    | finalState env && globalCounter /= 0 = print(unsafePerformIO(calculateDirtPercent env), env,1)
    | globalCounter == t*10 = print(unsafePerformIO(calculateDirtPercent env), env,2)
    | counter == t = do
        print env
        print "cambio"
        gen1 <- newStdGen
        gen2 <- newStdGen
        let
            n = rows env
            m = columns env
            rnds1 = randomNumbers n gen1
            rnds2 = randomNumbers m gen2
            new_kids = kids-carriedKids (carryingKid env)
            new_env = generateEnv rnds1 rnds2 n m new_kids kids rbts obstcs dirt (carryingKid env) 
            in startSimulation2 t 0 (globalCounter+1) kids rbts obstcs dirt rbtType new_env

    | otherwise = do
        gen <- newStdGen
        print env
        -- print rbtType
        let
            moveAgents = makeMoves (robots env) rbtType 0 env
            envAfterKidsMove = moveKids moveAgents gen
            total_dirt = length (dirty envAfterKidsMove)

         in if t == counter+1
            then startSimulation2 t (counter+1) globalCounter kids rbts obstcs total_dirt rbtType envAfterKidsMove
            else startSimulation2 t (counter+1) (globalCounter+1) kids rbts obstcs total_dirt rbtType envAfterKidsMove