{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
-- import System.Random(newStdGen)
module App
where
import Utils.Utils(randomNumbers, getAdy, filterCellsRbt)
import Environment.Environment (generateEnv, ENV (robots, ENV, carryingChld, rows, columns), emptyCellForRobot)
import System.Random (newStdGen)
import Elements.Children (moveKids)
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
        new_env = generateEnv rnds1 rnds2 rows columns kids rbts obstcs dirty [False]
        in startSimulation t t 0 kids rbts obstcs new_env --(newEmptyEnv rows columns rbts)


newEmptyEnv n m rbts = ENV n m (-1,-1) [] [] [] [] [] (buildcarryingList rbts) []

buildcarryingList 0 = []
buildcarryingList rbts = False:buildcarryingList (rbts-1)

startSimulation t counter globalCounter chldr rbts obstcs env
    | globalCounter == t*6 = print env
    --  counter == t = do
    --     gen1 <- newStdGen
    --     gen2 <- newStdGen
    --     print "cambiar"
    --     let
    --         n = rows env
    --         m = columns env
    --         rnds1 = randomNumbers n gen1
    --         rnds2 = randomNumbers m gen2
    --         new_env = generateEnv rnds1 rnds2 n m chldr rbts obstcs (carryingChld env)
    --         in startSimulation t 0 (globalCounter+1) chldr rbts obstcs new_env

    | otherwise = do 
                  gen1 <- newStdGen
                  gen2 <- newStdGen
                  print env
                  let   
                    moveAgents = makeMoves (robots env) [0] 0 env
                    -- in print moveAgents
                    -- envAfterKidsMove = moveKids moveAgents chldr gen1 gen2
                    in startSimulation t (counter+1) (globalCounter+1) chldr rbts obstcs moveAgents
