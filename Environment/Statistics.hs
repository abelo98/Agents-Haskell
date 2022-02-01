module Environment.Statistics

where
import Environment.Environment (rows, ENV (columns, obstc, chld, playpen, robots, dirty))
import Utils.Utils (disjoin)
import GHC.IO (unsafePerformIO)

calculateDirtPercent :: ENV -> IO Float
calculateDirtPercent env =
    let total_cells = rows env * columns env
        coverd_cells = (length (obstc env) + length (chld env) + length(playpen env) + length (robots env))
        dirty_cells = length (disjoin (dirty env) (robots env))
        clean_and_dirty_cells = total_cells - coverd_cells
    in percent dirty_cells clean_and_dirty_cells

percent :: Int -> Int -> IO Float
percent x y = do
    return (100 * ( a / b ))
    where a = fromIntegral x :: Float
          b = fromIntegral y :: Float

finalState env =  (null (dirty env) && null (chld env)) || (unsafePerformIO(calculateDirtPercent env) > 60)

victOrLoss perc | unsafePerformIO perc > 60 = (0,1)
                | otherwise = (1,0)