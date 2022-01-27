{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Elements.Agent(makeMoves)
where

import Elements.Robot (getStep,
 isCarryingChild, 
 detectKid, 
 dropKid,
 carryKidToPlaypen,
 moveTowardsKid, 
 moveTowardsDirty, 
 detectDirty, 
 isDirty, 
 clean)

import Environment.Env (ENV(chld, carryingChld, centerPlayPen, playpenTaken, dirty))
import Elements.Playpen (emptyPlace)
import Environment.Environment (ENV(playpen))
import Utils.Utils (disjoin)
import Environment.Env (ENV(ENV))
import Environment.Env (ENV(rows))
import Environment.Env


action pos 0 env
    | isCarryingChild pos (carryingChld env) &&
        emptyPlace env == pos = dropKid pos env
    | isCarryingChild pos (carryingChld env) =
        carryKidToPlaypen pos (emptyPlace env) env
    | detectKid env = moveTowardsKid pos (chld env) env 
    | isDirty pos env = clean pos env
    | detectDirty env = moveTowardsDirty pos (dirty env) env 
    | otherwise = env

makeMoves [] _ env = env 
makeMoves (r:rs) (t:ts) env = 
    let new_env = action r t env 
    in makeMoves rs ts new_env 