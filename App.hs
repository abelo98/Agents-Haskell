-- import System.Random(newStdGen)
module App
where
import Utils.Utils(randomNumbers, getAdy, filterCellsRbt)
import Environment.Environment (generateEnv, ENV (robots), emptyCellForRobot)
import System.Random (newStdGen)
import Elements.Children (moveKids)
import Elements.Robot (updatePi, bfs, nextStep)


main :: Int -> Int -> Int -> Int -> Int -> IO ()
main n m chldr rbts obstcs = do
    gen1 <- newStdGen
    gen2 <- newStdGen
    gen3 <- newStdGen 
    gen4 <- newStdGen 

    let rnds1 = randomNumbers n gen1
        rnds2 = randomNumbers m gen2
        env = generateEnv rnds1 rnds2 n m chldr rbts obstcs [] 
        -- on_Test
        -- new_env = makeMoves (robots env) [0,0] env
        -- End On Test
        -- in 
        --     let envAfterKidsMove = moveKids env chldr gen3 gen4
        --         in print(env, envAfterKidsMove)
        in print env
    


