{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
-- import System.Random(newStdGen)
module App(main)
where

import System.Random (newStdGen)
import Elements.Kids (moveKids, carriedKids)
import Elements.Robot (updatePi, bfs, nextStep)
import Elements.Agent (makeMoves)
import Environment.Statistics (calculateDirtPercent, finalState, victOrLoss, mean)
import GHC.IO (unsafePerformIO)
import Environment.Env
import Environment.Environment (generateEnv)


main :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int ->[IO Float]->Int->Int->Int-> (Float,Int,Int)
main _ _ _ _ _ _ _ _ allPercents vict loss 0 = (unsafePerformIO(mean allPercents),vict,loss)
main t rows columns kids rbts obstcs dirty rbtType allPercents vict loss noSim = do
    let
        rbts_types = buildList rbts rbtType
        perct = startSimulation t t 0 kids rbts obstcs dirty rbts_types (newEmptyEnv rows columns rbts)
        (v,l) = victOrLoss perct
        in main t rows columns kids rbts obstcs dirty rbtType (allPercents++[perct]) (vict+v) (loss+l) (noSim-1)


newEmptyEnv n m rbts = ENV n m [] [] [] [] [] (buildList rbts False) []

buildList 0 _ = []
buildList rbts value = value:buildList (rbts-1) value

startSimulation t counter globalCounter kids rbts obstcs dirt rbtType env
    | finalState env && globalCounter /= 0 = calculateDirtPercent env
    | globalCounter == t*100 = calculateDirtPercent env
    | counter == t = do
        gen1 <- newStdGen
        let
            n = rows env
            m = columns env
            new_kids = kids-carriedKids (carryingKid env)
            new_env = generateEnv n m new_kids kids rbts obstcs dirt (carryingKid env) gen1
            in startSimulation t 0 (globalCounter+1) kids rbts obstcs dirt rbtType new_env

    | otherwise = do
        gen <- newStdGen

        let
            moveAgents = makeMoves (robots env) rbtType 0 env
            envAfterKidsMove = moveKids moveAgents gen
            total_dirt = length (dirty envAfterKidsMove)

         in if t == counter+1
            then startSimulation t (counter+1) globalCounter kids rbts obstcs total_dirt rbtType envAfterKidsMove
            else startSimulation t (counter+1) (globalCounter+1) kids rbts obstcs total_dirt rbtType envAfterKidsMove
