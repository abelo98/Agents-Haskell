{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
-- {-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Environment.Environment(
    ENV(..),
    generateEnv,
    emptyCell,
    emptyCellForRobot)

where
import Utils.Utils (getAdy,setElement, randomNumbers, inList, inMatriz, disjoin)
import System.Random (newStdGen)
import Environment.Env (ENV(ENV, rows, columns, obstc, dirty, playpen, robots, chld))
import Elements.Obstacle (canMoveObstcs)
import Elements.Playpen(buildPlayPen)


-- modifyEnv (ENV n m chld obs drt plpen rbts carChld) l "children" = ENV n m l obs drt plpen rbts carChld
-- modifyEnv (ENV n m chld _ drt plpen rbts carChld) l "obstacles" = ENV n m chld l drt plpen rbts carChld
-- modifyEnv (ENV n m chld obs _ plpen rbts carChld) l "dirty" = ENV n m chld obs l plpen rbts carChld
-- modifyEnv (ENV n m chld obs drt _ rbts carChld) l "playpen" = ENV n m chld obs drt l rbts carChld
-- modifyEnv (ENV n m chld obs drt plpen _ carChld) l "robots" = ENV n m chld obs drt plpen l carChld
-- modifyEnv (ENV n m chld obs drt plpen rbts _) l "carrying" = ENV n m chld obs drt plpen rbts l


generateEnv rnds1 rnds2 n m chldr rbts obstcs _ =
    let start_x = head rnds1
        start_y = head rnds2
        env = ENV n m (start_x,start_y) [] [] [] [] [] [] []
        playpen = buildPlayPen (start_x,start_y) chldr env
        chld = setElement chldr rnds1 rnds2 playpen []
        rbt = setElement rbts rnds1 rnds2 (chld++playpen) []
        obstc = setElement obstcs rnds1 rnds2 (chld++rbt++playpen) []
        rbtWithChild = map (\x->(x,False)) rbt
        in ENV n m (start_x,start_y) chld obstc [] playpen rbt rbtWithChild []



emptyCell :: (Int, Int) -> (Int, Int) -> ENV -> Bool
emptyCell (p1,p2) (x, y) env
    | inList (x,y) (obstc env) && not (canMoveObstcs (x,y) (x-p1,y-p2) env) ||
      inList (x,y) (dirty env) ||
      inList (x,y) (playpen env) ||
      inList (x,y) (robots env)  = False
    | otherwise = True

emptyCellForRobot :: (Int, Int) -> ENV -> Bool -> Bool
emptyCellForRobot (x, y) env withChld
    | withChld && inList (x,y) (chld env) ||
      inList (x,y) (obstc env) ||
      inList (x,y) (playpen env) &&  inList (x,y) (chld env) ||
      inList (x,y) (robots env)  = False
    | otherwise = True

