{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Utils.Utils(
    randomNumbers,
    getAdy,
    setElement,
    inList,
    filterCells,
    pickRandom,
    remove,
    inMatriz,
    getDir,
    disjoin,
    filterCellsRbt,
    updateElement
)

where
import System.Random (Random(randomIO, randomRIO, randomRs), StdGen, newStdGen)
import Environment.Env (ENV(rows, columns))


inList e [] = False
inList e (x:xs) | e == x = True
                | otherwise = inList e xs


randomNumbers :: Int -> StdGen -> [Int]
randomNumbers x = randomRs(0,x-1)

getAdy :: (Int, Int) -> ENV -> [(Int, Int)]
getAdy (x,y) = filterAdy [(x-1,y),(x-1,y+1),
              (x,y+1),(x+1,y+1),
              (x+1,y),(x+1,y-1),
              (x,y-1),(x-1,y-1)]


setElement :: Int -> [Int] -> [Int] -> [(Int,Int)] -> [(Int,Int)]
setElement 0 _ _ l  = []
setElement n (x:xs) (y:ys) occupated
    | inList (x,y) occupated = setElement n xs ys occupated
    | otherwise = (x,y):setElement (n-1) xs ys (occupated++[(x,y)])
        


filterCells _ [] env (p1,p2) = []
filterCells f2 (x:xs) env (p1,p2)
    | f2 (p1,p2) x env = x:filterCells f2 xs env (p1,p2)
    | otherwise = filterCells f2 xs env (p1,p2)

filterCellsRbt _ [] env withChld = []
filterCellsRbt f2 (x:xs) env withChld
    | f2 x env withChld = x:filterCellsRbt f2 xs env withChld
    | otherwise = filterCellsRbt f2 xs env withChld

pickRandom [] _ _ = []
pickRandom l 0 gen = []
pickRandom l n gen = let i = head (randomNumbers (length l) gen)
                         x = l!!i
                    in x:pickRandom (remove x l) (n-1) gen

remove x [] = []
remove x (e:es) |  x == e = remove x es
                | otherwise = e:remove x es

inMatriz (x,y) env = (0 <= x && x < rows env) && 0 <= y && y < columns env


getDir (x1,y1) (x2,y2) = (x1-x2,y1-y2)

disjoin [] _ = []
disjoin (x:xs) found | not(inList x found) = x:disjoin xs found
                     | otherwise = disjoin xs found

filterAdy [] _ = []
filterAdy (x:xs) env | inMatriz x env = x:filterAdy xs env
                     | otherwise = filterAdy xs env


updateElement (x:xs) idx value | idx == 0 = value:xs
                                | otherwise = x:updateElement xs (idx-1) value


-- allCells _ _ 0  = []
-- allCells 0 m total = [(0,m)]
-- allCells n 0 total = [(n,0)]
-- allCells n m total =  
--     (n,m):allCells (n-1) m (total-1) ++ allCells n (m-1) (total-1) ++ allCells (n-1) (m-1) (total-1)

