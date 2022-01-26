module Environment.Env(ENV(..))
where

data ENV = ENV {rows :: Int, 
                columns :: Int,
                centerPlayPen :: (Int,Int),
                chld::[(Int,Int)],
                obstc::[(Int,Int)],
                dirty::[(Int,Int)],
                playpen::[(Int,Int)],
                robots::[(Int,Int)],
                carryingChld::[((Int,Int),Bool)],
                playpenTaken::[(Int,Int)]
                } deriving (Show)


-- TODO Hacer lista global para 1 todos los robots vean las celdas del corral tomadas