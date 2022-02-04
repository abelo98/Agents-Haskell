{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
-- {-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Environment.Environment(
    ENV(..),
    generateEnv,
    emptyCellForKid,
    emptyCellForRobot,
    countKids,generateEnv2,emptyCellToMess)

where
import Utils.Utils (getAdy,setElement, randomNumbers, inList, inMatriz, disjoin, allCells, pickRandom)
import System.Random (newStdGen, Random (randomR))

import Elements.Obstacle (canMoveObstcs)
import Elements.Playpen(buildPlayPen)
import Environment.Env ( ENV(..) )


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

generateEnv2 n m kids playpen_size rbts obstcs drty carryingKids gen =
    let (start_x,gen1) = randomR (0,n-1::Int) gen
        (start_y,gen2) = randomR (0,m-1::Int) gen1
        (_,gen3) = randomR (2,3::Int) gen1
        (_,gen4) = randomR (3,4::Int) gen1
        (_,gen5) = randomR (4,5::Int) gen1
        env = ENV n m [] [] [] [] [] [] []

        empty_cells = allCells n m 

        playpen = buildPlayPen (start_x,start_y) playpen_size env
        empty_cells2 = disjoin empty_cells playpen

        chld = pickRandom empty_cells2 kids gen2
        empty_cells3 = disjoin empty_cells2 chld

        rbt = pickRandom empty_cells3 rbts gen3
        empty_cells4 = disjoin empty_cells3 rbt

        obstc = pickRandom empty_cells4 obstcs gen4
        empty_cells5 = disjoin empty_cells4 obstc

        dirty = pickRandom empty_cells5 drty gen5
        in ENV n m chld obstc dirty playpen rbt carryingKids []
      
emptyCellToMess [] _ = [] 
emptyCellToMess (pos:xs) env 
  | inList pos (obstc env) ||
    inList pos (dirty env) ||
    inList pos (playpen env) ||
    inList pos (kids env) ||
    inList pos (playpenTaken env) ||
    inList pos (robots env)  = emptyCellToMess xs env
  | otherwise = pos:emptyCellToMess xs env

emptyCellForKid _ [] _ = [] 
emptyCellForKid (p1,p2) ((x, y):xs) env
    | inList (x,y) (obstc env) && not (canMoveObstcs (x,y) (x-p1,y-p2) env) ||
      inList (x,y) (dirty env) ||
      inList (x,y) (kids env) ||
      inList (x,y) (playpen env) ||
      inList (x,y) (playpenTaken env) ||
      inList (x,y) (robots env)  = emptyCellForKid (p1,p2) xs env
    | otherwise = (x, y):emptyCellForKid (p1,p2) xs env

emptyCellForRobot :: [(Int, Int)] -> ENV -> Bool -> [(Int,Int)]
emptyCellForRobot [] _ _ = [] 
emptyCellForRobot (pos:xs) env withChld
    | withChld && inList pos (kids env) ||
      inList pos (obstc env) ||
      inList pos (playpenTaken env) ||
      inList pos (robots env)  = emptyCellForRobot xs env withChld
    | otherwise = pos:emptyCellForRobot xs env withChld

countKids [] _= 0
countKids (x:xs) env
  | inList x (kids env) = 1 + countKids xs env
  | otherwise = countKids xs env

