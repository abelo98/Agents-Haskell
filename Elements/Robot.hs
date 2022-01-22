{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Elements.Robot(bfs, updatePi, nextStep, makeMoves)
where
import Utils.Utils (filterCellsRbt, disjoin, getAdy, inList)
import Environment.Env (ENV(carryingChld))
import Environment.Environment

bfs rbtPos [] pi visited env virtualPos = ([],virtualPos)
bfs rbtPos (u:us) pi visited env virtualPos =
    if not(inList virtualPos (chld env))
        then
            let withChld = inList rbtPos (chld env)
                adys_u = disjoin (getAdy u env) (visited++us) --adyacentes de u q no estan en la lista de ady por visitar ni los visitados
                free_ady_u = filterCellsRbt emptyCellForRobot adys_u env withChld
                new_ady = us ++ free_ady_u
                newPi = pi++updatePi u free_ady_u
                new_visited = visited++[u]
            in bfs rbtPos new_ady newPi new_visited env u
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

getStep pos env =
    let pi = updatePi pos (getAdy pos env)
        withkid = isCarryingChild pos (carryingChld env)
        free_ady_rbtPos = filterCellsRbt emptyCellForRobot (getAdy pos env) env withkid
        pi_posKid = bfs pos free_ady_rbtPos pi [pos] env pos
        poskid = snd pi_posKid
        newpi = fst pi_posKid
        steps = reverse (nextStep newpi pos poskid)
    in if withkid && length steps > 1
        then steps!!1
        else head steps

findSteps [] nanyKind env = []
findSteps (x:xs) (t:ts) env
    | t==0 = getStep x env:findSteps xs ts env
    | otherwise = []-- do limpia caca


isCarryingChild pos (x:xs) | pos == fst x = snd x
                           | otherwise = isCarryingChild pos xs

makeMoves rbts typeRbt env =
    let new_rbts_pos = findSteps rbts typeRbt env --nuevas pos de robots
        new_rbt_with_chld = updateCarrying new_rbts_pos env -- actualiza la pos si un kid esta siendo cargado
        carried_chld = updateCarriedChield new_rbt_with_chld --kids cargados
        new_chld_pos = disjoin (chld env) carried_chld --se kitan los ninos cargados de la lista de kids
    in 
    ENV (rows env) 
        (columns env) 
        new_chld_pos 
        (obstc env) 
        (dirty env) 
        (playpen env) 
        new_rbts_pos 
        new_rbt_with_chld


-- si un robot esta en la lista de los kids entonces lo toma
updateCarrying [] _ = []
updateCarrying (x:xs) env | inList x (chld env) = (x,True):updateCarrying xs env
                          | otherwise = (x,False):updateCarrying xs env

updateCarriedChield []  = []
updateCarriedChield (x:xs) | snd x = fst x:updateCarriedChield xs
                           | otherwise = updateCarriedChield xs