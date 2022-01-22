-- {-# OPTIONS_GHC -Wno-incomplete-patterns #-}
-- module Playpen.Playpen(buildPlayPen)
-- where 
    
-- import Environment.Env (ENV)
-- import Utils.Utils(getAdy,inList)

-- -- startx,starty,total_children,stack_ady,env ,taken_ady -> answer
-- buildPlayPen :: Int -> Int -> Int -> [(Int,Int)]-> ENV -> [(Int,Int)] -> [(Int,Int)]
-- buildPlayPen x y 0 ady env taken = []
-- buildPlayPen x y n_cldr ady@(e:rest) env taken | inMatriz x y env && not (inList (x,y) taken)  =
--                               let next_x = fst e
--                                   next_y = snd e
--                                   new_adys = ady ++ getAdy next_x next_y
--                                 in (x,y):buildPlayPen next_x next_y (n_cldr-1) new_adys env (taken++[(x,y)])
--                                          | otherwise =
--                                            uncurry buildPlayPen (head rest) n_cldr rest env taken