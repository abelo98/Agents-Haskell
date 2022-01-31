{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
-- {-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Environment.Environment(
    ENV(..),
    generateEnv,
    emptyCell,
    emptyCellForRobot,
    countKids)

where
import Utils.Utils (getAdy,setElement, randomNumbers, inList, inMatriz, disjoin)
import System.Random (newStdGen)
import Environment.Env (ENV(ENV, rows, columns, obstc, dirty, playpen, robots, chld, carryingChld, playpenTaken))
import Elements.Obstacle (canMoveObstcs)
import Elements.Playpen(buildPlayPen)


generateEnv rnds1 rnds2 n m kids playpen_size rbts obstcs drty carryingKids =
    let start_x = head rnds1
        start_y = head rnds2
        env = ENV n m [] [] [] [] [] [] []
        playpen = buildPlayPen (start_x,start_y) playpen_size env
        chld = setElement kids rnds1 rnds2 playpen
        rbt = setElement rbts rnds1 rnds2 (chld++playpen)
        obstc = setElement obstcs rnds1 rnds2 (chld++rbt++playpen)
        dirty = setElement drty rnds1 rnds2 (chld++rbt++playpen++obstc)
        in ENV n m chld obstc dirty playpen rbt carryingKids []

emptyCell :: (Int, Int) -> (Int, Int) -> ENV -> Bool
emptyCell (p1,p2) (x, y) env
    | inList (x,y) (obstc env) && not (canMoveObstcs (x,y) (x-p1,y-p2) env) ||
      inList (x,y) (dirty env) ||
      inList (x,y) (playpen env) ||
      inList (x,y) (robots env)  = False
    | otherwise = True

emptyCellForRobot :: (Int, Int) -> ENV -> Bool -> Bool
emptyCellForRobot pos env withChld
    | withChld && inList pos (chld env) ||
      inList pos (obstc env) ||
      inList pos (playpenTaken env) ||
      inList pos (robots env)  = False
    | otherwise = True

countKids [] _= 0
countKids (x:xs) env
  | inList x (chld env) = 1 + countKids xs env
  | otherwise = countKids xs env

finalState env = null (dirty env) && null (chld env)