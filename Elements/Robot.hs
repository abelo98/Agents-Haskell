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
import Environment.Env (ENV(carryingChld, centerPlayPen, playpenTaken))
import Environment.Environment
import GHC.Exts.Heap (GenClosure(value))

bfs [] pi visited env virtualPos withChld objList = ([],virtualPos)
bfs (u:us) pi visited env virtualPos withChld objList =
    if not(inList virtualPos objList)
        then
            let adys_u = disjoin (getAdy u env) (visited++us) --adyacentes de u q no estan en la lista de ady por visitar ni los visitados
                free_ady_u = filterCellsRbt emptyCellForRobot adys_u env withChld
                new_ady = us ++ free_ady_u
                newPi = pi++updatePi u free_ady_u
                new_visited = visited++[u]
            in bfs new_ady newPi new_visited env u withChld objList
        else
            (pi,virtualPos)

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
    let pi = updatePi pos (getAdy pos env)
        free_ady_rbtPos = filterCellsRbt emptyCellForRobot (getAdy pos env) env carrying
        pi_posKid = bfs free_ady_rbtPos pi [pos] env pos carrying objList
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
        (centerPlayPen env)
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
        (centerPlayPen env)
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
        (centerPlayPen env)
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
            (centerPlayPen env)
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
        (centerPlayPen env)
        (fst new_kids_new_carrying)
        (obstc env)
        (dirty env)
        (playpen env)
        new_robots
        (snd new_kids_new_carrying)
        (playpenTaken env)

