{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Elements.Robot(bfs,
updatePi,
nextStep,
getStep,
isCarryingChild,
detectKid,
dropKid,
carryKidToPlaypen,
moveTowardsKid,
moveTowardsDirty,
detectDirty,
isDirty,
clean
)

where
import Utils.Utils (filterCellsRbt, disjoin, getAdy, inList, remove, updateElement)
import Environment.Env (ENV(carryingChld, playpenTaken))
import Environment.Environment

-- newEmptyEnv2 n m rbts = ENV n m (-6,-6) [(0,0)] [] [] [] [] (buildList rbts False) []
-- buildList 0 _ = []
-- buildList rbts value = value:buildList (rbts-1) value

bfs [] pi visited env withChld objList = ([],(-1,-1))
bfs (u:us) pi visited env withChld objList =
    if not(inList u objList)
        then
            let adys_u = disjoin (getAdy u env) (visited++us) --adyacentes de u q no estan en la lista de ady por visitar ni los visitados
                free_ady_u = filterCellsRbt emptyCellForRobot adys_u env withChld
                new_ady = us ++ free_ady_u
                newPi = pi++updatePi u free_ady_u
                new_visited = visited++[u]
            in bfs new_ady newPi new_visited env withChld objList
        else
            (pi,u)


-- bfs2 [] pi visited env virtualPos withChld objList = print "Vacio"
-- bfs2 (u:us) pi visited env virtualPos withChld objList = do
--     print virtualPos
--     if not(inList u objList)
--         then
--             let adys_u = disjoin (getAdy u env) (visited++us) --adyacentes de u q no estan en la lista de ady por visitar ni los visitados
--                 free_ady_u = filterCellsRbt emptyCellForRobot adys_u env withChld
--                 new_ady = us ++ free_ady_u
--                 newPi = pi++updatePi u free_ady_u
--                 new_visited = visited++[u]
--             in bfs2 new_ady newPi new_visited env u withChld objList
--         else
--             print visited
-- test = 
--      let free_ady_rbtPos = filterCellsRbt emptyCellForRobot (getAdy (0,4) (newEmptyEnv2 5 5 1)) (newEmptyEnv2 5 5 1) False
--          pi = updatePi (0,4) free_ady_rbtPos
--          pi_posKid = bfs2 free_ady_rbtPos pi [(0,4)] (newEmptyEnv2 5 5 1) (0,4) False [(0,0)]
--         --  poskid = snd pi_posKid
--         --  newpi = fst pi_posKid
         
--         in free_ady_rbtPos
-- test2 = 
--  bfs2 [(1,4),(1,3),(0,3)] [((0,3),(0,4)),((1,3),(0,4)),((1,4),(0,4))] [(0,4)] (newEmptyEnv2 5 5 1) (0,4) False [(0,0)]

-- father of x(ady to u) is u
updatePi :: b -> [a] -> [(a, b)]
updatePi u = map (\ x -> (x, u))


nextStep [] start _ = [start]
nextStep road start final = let parent = findParent road final
                            in if parent == start
                                then [final]
                                else final:nextStep road start parent


findParent (x:xs) child | child == fst x = snd x
                        | otherwise = findParent xs child

getStep pos env objList carrying =
    let free_ady_rbtPos = filterCellsRbt emptyCellForRobot (getAdy pos env) env carrying
        pi = updatePi pos free_ady_rbtPos
        pi_posKid = bfs free_ady_rbtPos pi [pos] env carrying objList
        poskid = snd pi_posKid
        newpi = fst pi_posKid
        steps = reverse (nextStep newpi pos poskid)
    in if carrying && length steps > 1
        then steps!!1
        else head steps

isCarryingChild carrying idx =  carrying!!idx

grabKid pos idx env
    | inList pos (chld env) = (remove pos (chld env),updateElement (carryingChld env) idx True)
    | otherwise = (chld env,carryingChld env)

isDirty pos env = inList pos (dirty env)

detectKid env = not (null (chld env))

detectDirty env = not (null (dirty env))

clean pos env =
    let new_dirty = remove pos (dirty env)
    in ENV (rows env)
        (columns env)
        (-2,-2)
        (chld env)
        (obstc env)
        new_dirty
        (playpen env)
        (robots env)
        (carryingChld env)
        (playpenTaken env)

dropKid pos idx env =
    let new_playpenTaken = playpenTaken env ++ [pos]
        new_carrying_kids = updateElement (carryingChld env) idx False
        -- new_chld_pos = chld env++[pos]
        new_playpen = remove (head (playpen env)) (playpen env)
    in ENV (rows env)
        (columns env)
        (-1,-1)
        (chld env) --new_chld_pos
        (obstc env)
        (dirty env)
        new_playpen
        (robots env)
        new_carrying_kids
        new_playpenTaken


carryKidToPlaypen pos emptySpot env =
    let next_step = getStep pos env [emptySpot] True
        new_rbts = remove pos (robots env)++[next_step]--se puede cambia por updateElement
    in ENV (rows env)
        (columns env)
        next_step
        (chld env)
        (obstc env)
        (dirty env)
        (playpen env)
        new_rbts
        (carryingChld env)
        (playpenTaken env)

moveTowardsKid pos objectives idx env = 
    let step = getStep pos env objectives False
        new_kids_new_carrying = grabKid step idx env
        new_robots = remove pos (robots env)++[step]
        in ENV (rows env)
            (columns env)
            step
            (fst new_kids_new_carrying)
            (obstc env)
            (dirty env)
            (playpen env)
            new_robots
            (snd new_kids_new_carrying)
            (playpenTaken env)

moveTowardsDirty pos objectives idx env =
    let step = getStep pos env objectives False
        new_kids_new_carrying = grabKid step idx env--si se quita esto entonces va a obviar a un kid en su celda
        new_robots = remove pos (robots env)++[step]
    in ENV (rows env)
        (columns env)
        step
        (fst new_kids_new_carrying)
        (obstc env)
        (dirty env)
        (playpen env)
        new_robots
        (snd new_kids_new_carrying)
        (playpenTaken env)

