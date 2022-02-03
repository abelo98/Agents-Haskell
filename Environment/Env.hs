module Environment.Env(ENV(..))
where

data ENV = ENV {rows :: Int, 
                columns :: Int,
                kids::[(Int,Int)],
                obstc::[(Int,Int)],
                dirty::[(Int,Int)],
                playpen::[(Int,Int)],
                robots::[(Int,Int)],
                carryingKid::[Bool],
                playpenTaken::[(Int,Int)]
                } deriving (Show)


-- TODO Hacer lista global para 1 todos los robots vean las celdas del corral tomadas