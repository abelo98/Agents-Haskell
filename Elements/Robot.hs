{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Elements.Robot(bfs, 
updatePi,
nextStep, 
getStep, 
isCarryingChild, 
detectKid,
dropKid,
updateCarrying2,
carryKidToPlaypen)

where
import Utils.Utils (filterCellsRbt, disjoin, getAdy, inList, remove)
import Environment.Env (ENV(carryingChld, centerPlayPen))
import Environment.Environment

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

-- findSteps [] _ _ carrying = []
-- findSteps (x:xs) (t:ts) env carrying
--     | t==0 = getStep x env (chld env) carrying:findSteps xs ts env 
--     | otherwise = []-- do limpia caca


isCarryingChild pos (x:xs) | pos == fst x = snd x
                           | otherwise = isCarryingChild pos xs

-- makeMoves rbts typeRbt env =
--     let new_rbts_pos = findSteps rbts typeRbt env --nuevas pos de robots
--         new_rbt_with_chld = updateCarrying new_rbts_pos env -- actualiza la pos si un kid esta siendo cargado
--         carried_chld = updateCarriedChield new_rbt_with_chld --kids cargados
--         new_chld_pos = disjoin (chld env) carried_chld --se kitan los ninos cargados de la lista de kids
--     in 
--     ENV (rows env) 
--         (columns env) 
--         new_chld_pos 
--         (obstc env) 
--         (dirty env) 
--         (playpen env) 
--         new_rbts_pos 
--         new_rbt_with_chld


-- si un robot esta en la lista de los kids entonces lo toma
updateCarrying [] _ = []
updateCarrying (x:xs) env | inList x (chld env) = (x,True):updateCarrying xs env
                          | otherwise = (x,False):updateCarrying xs env

-- returns a list with the kids that need to be taken out from the chld list
updateCarriedChield []  = []
updateCarriedChield (x:xs) | snd x = fst x:updateCarriedChield xs
                           | otherwise = updateCarriedChield xs


isDirty pos env
    | inList pos (dirty env) = remove pos (dirty env)
    | otherwise = dirty env


detectKid env = not (null (chld env))

dropKid pos env =
    let new_playpen = remove pos (playpen env)
        new_carryind_chld = updateCarrying2 (carryingChld env) pos
        new_chld_pos = chld env++[pos]
    in ENV (rows env)
        (columns env)
        (centerPlayPen env)
        new_chld_pos
        (obstc env)
        (dirty env)
        new_playpen
        (robots env)
        new_carryind_chld

carryKidToPlaypen pos emptyPlace env = 
    let next_step = getStep pos env [emptyPlace] True
        new_rbts = remove pos (robots env)++[next_step]
        new_carryind_chld = updateCarrying2 (carryingChld env) pos
    in ENV (rows env)
        (columns env)
        (centerPlayPen env)
        (chld env)
        (obstc env)
        (dirty env)
        (playpen env)
        new_rbts
        new_carryind_chld 

updateCarrying2 (x:xs) pos | fst x == pos = (pos,False): updateCarrying2 xs pos
                           | otherwise = x:updateCarrying2 xs pos

                        