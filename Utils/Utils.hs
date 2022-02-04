{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Utils.Utils(
    randomNumbers,
    getAdy,
    inList,
    pickRandom,
    remove,
    inMatriz,
    getDir,
    disjoin,
    updateElement,
    allCells
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


allCells n m= [(x,y)| x <- [0..n-1], y <- [0..m-1]]

