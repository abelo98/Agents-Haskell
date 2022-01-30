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


action pos 0 idx env
    | isCarryingChild (carryingChld env) idx &&
        emptyPlace env == pos = dropKid pos idx env
    | isCarryingChild (carryingChld env) idx =
        carryKidToPlaypen pos (emptyPlace env) env
    | detectKid env = moveTowardsKid pos (chld env) idx env 
    | isDirty pos env = clean pos env
    | detectDirty env = moveTowardsDirty pos (dirty env) idx env 
    | otherwise = env

action pos 1 idx env
    | isDirty pos env = clean pos env
    | isCarryingChild (carryingChld env) idx &&
        emptyPlace env == pos = dropKid pos idx env
    | isCarryingChild (carryingChld env) idx =
        carryKidToPlaypen pos (emptyPlace env) env
    | detectDirty env = moveTowardsDirty pos (dirty env) idx env
    | detectKid env = moveTowardsKid pos (chld env) idx env 
    | otherwise = env


makeMoves [] _ _ env = env 
makeMoves (r:rs) (t:ts) idx env = 
    let new_env = action r t idx env 
    in makeMoves rs ts (idx+1) new_env 