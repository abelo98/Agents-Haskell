module Environment.Statistics

where

import Utils.Utils (disjoin)
import GHC.IO (unsafePerformIO)
import Environment.Env

calculateDirtPercent :: ENV -> IO Float
calculateDirtPercent env =
    let total_cells = rows env * columns env
        coverd_cells = (length (obstc env) + length (kids env) + length(playpen env) + length (robots env))
        dirty_cells = length (disjoin (dirty env) (robots env))
        clean_and_dirty_cells = total_cells - coverd_cells
    in percent dirty_cells clean_and_dirty_cells

percent :: Int -> Int -> IO Float
percent x y = do
    return (100 * ( a / b ))
    where a = fromIntegral x :: Float
          b = fromIntegral y :: Float
          
mean :: [IO Float]  -> IO Float
mean l = do
    s <- sum <$> sequence l
    return (s / t)
    where t = fromIntegral (length l) :: Float

finalState env =  (null (dirty env) && null (playpen env)) || (unsafePerformIO(calculateDirtPercent env) > 60)

victOrLoss perc | unsafePerformIO perc > 60 = (0,1)
                | otherwise = (1,0)