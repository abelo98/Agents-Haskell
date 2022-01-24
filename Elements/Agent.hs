{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Elements.Agent
where

import Elements.Robot (getStep, isCarryingChild, detectKid)
import Environment.Env (ENV(chld, carryingChld, centerPlayPen))
import Elements.Playpen (findEmptyPlace)
import Environment.Environment (ENV(playpen))

    
action pos env 0 

    --  | isCarryingChild pos (carryingChld env) &&
    --      atPlaypenDestiny pos  = -- TODO DropKid
    | isCarryingChild pos (carryingChld env) = 
        getStep pos env (findEmptyPlace (playpen env) 10000 (centerPlayPen env)) True -- and clean during journey
    | detectKid env = getStep pos env (chld env) False


s env = findEmptyPlace [] 1000 []