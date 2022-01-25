{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Elements.Agent
where

import Elements.Robot (getStep, isCarryingChild, detectKid, dropKid, updateCarrying2, carryKidToPlaypen)
import Environment.Env (ENV(chld, carryingChld, centerPlayPen))
import Elements.Playpen (findEmptyPlace)
import Environment.Environment (ENV(playpen))


action pos env 0
    | isCarryingChild pos (carryingChld env) &&
        findEmptyPlace env == pos = dropKid pos env
    | isCarryingChild pos (carryingChld env) =
        carryKidToPlaypen pos (findEmptyPlace env) env
    | detectKid env = getStep pos env (chld env) False
    | otherwise = env

