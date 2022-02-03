{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Elements.Agent(makeMoves)
where

import Elements.Robot (getStep,
 isCarryingChild,
 detectKid,
 dropKid,
 carryKidToPlaypen,
 moveTowardsObj,
 detectDirty,
 isDirty,
 clean)
import Elements.Playpen (emptyPlace)
import Utils.Utils (disjoin)
import Environment.Statistics (calculateDirtPercent)
import GHC.IO (unsafePerformIO)
import Environment.Env


action pos 0 idx env
    | isDirty pos env = clean pos env
    | isCarryingChild (carryingKid env) idx &&
        emptyPlace env == pos = dropKid pos idx env
    | isCarryingChild (carryingKid env) idx =
        carryKidToPlaypen pos (emptyPlace env) env
    | detectKid env = moveTowardsObj pos (kids env) idx env
    | detectDirty env = moveTowardsObj pos (dirty env) idx env
    | otherwise = env

action pos 1 idx env
    | isDirty pos env = clean pos env
    | isCarryingChild (carryingKid env) idx &&
        emptyPlace env == pos = dropKid pos idx env
    | isCarryingChild (carryingKid env) idx =
        carryKidToPlaypen pos (emptyPlace env) env
    | detectDirty env = moveTowardsObj pos (dirty env) idx env
    | detectKid env = moveTowardsObj pos (kids env) idx env
    | otherwise = env

action pos 2 idx env
    | isDirty pos env = clean pos env
    | detectDirty env = moveTowardsObj pos (dirty env) idx env
    | isCarryingChild (carryingKid env) idx &&
        emptyPlace env == pos = dropKid pos idx env
    | isCarryingChild (carryingKid env) idx =
        carryKidToPlaypen pos (emptyPlace env) env
    | detectKid env = moveTowardsObj pos (kids env) idx env
    | otherwise = env

action pos 3 idx env
    | unsafePerformIO(calculateDirtPercent env) > 30 = action pos 1 idx env
    | otherwise = action pos 0 idx env

makeMoves [] _ _ env = env
makeMoves (r:rs) (t:ts) idx env =
    let new_env = action r t idx env
    in makeMoves rs ts (idx+1) new_env