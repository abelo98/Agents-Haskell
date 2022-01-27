-- import System.Random(newStdGen)
module App
where
import Utils.Utils(randomNumbers, getAdy, filterCellsRbt)
import Environment.Environment (generateEnv, ENV (robots, ENV, carryingChld, rows, columns), emptyCellForRobot)
import System.Random (newStdGen)
import Elements.Children (moveKids)
import Elements.Robot (updatePi, bfs, nextStep)
import Elements.Agent (makeMoves)


main :: Int -> Int -> Int -> ENV -> IO ()
main chldr rbts obstcs env = do
    gen1 <- newStdGen
    gen2 <- newStdGen
    gen3 <- newStdGen
    gen4 <- newStdGen

    let
        n = rows env
        m = columns env
        rnds1 = randomNumbers n gen1
        rnds2 = randomNumbers m gen2
        new_env = generateEnv rnds1 rnds2 n m chldr rbts obstcs (carryingChld env)
        -- on_Test
        new_env2 = makeMoves (robots new_env) [0,0] new_env
        -- End On Test
        -- in 
        --     let envAfterKidsMove = moveKids env chldr gen3 gen4
        --         in print(env, envAfterKidsMove)
        in print (new_env,new_env2)




newEmptyEnv n m = ENV n m (-1,-1) [] [] [] [] [] [] []



