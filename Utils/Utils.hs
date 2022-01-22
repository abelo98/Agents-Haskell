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
    filterCellsRbt
)

where
import System.Random (Random(randomIO, randomRIO, randomRs), StdGen, newStdGen)
import Environment.Env (ENV(rows, columns))

idR :: Int -> Int
idR x = x


rnd :: [(Int,Int)]-> Int ->Int -> Int -> IO ()
rnd l x n m = do
    num1 <- randomRIO (1,n)
    num2 <- randomRIO (1,n)
    print num1

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


setElement :: Int -> [Int] -> [Int] -> [(Int,Int)] -> [(Int,Int)] -> [(Int,Int)]
setElement 0 _ _ l r = r
setElement n (x:xs) (y:ys) occupated answ
    | inList (x,y) occupated = setElement n xs ys occupated answ
    | otherwise =
    let ret = answ++[(x,y)]
        newElementSet = occupated++[(x,y)]
        in setElement (n-1) xs ys newElementSet ret


filterCells _ [] env (p1,p2) = []
filterCells f2 (x:xs) env (p1,p2)
    | f2 (p1,p2) x env = x:filterCells f2 xs env (p1,p2)
    | otherwise = filterCells f2 xs env (p1,p2)

filterCellsRbt _ [] env withChld = []
filterCellsRbt f2 (x:xs) env withChld
    | f2  x env withChld = x:filterCellsRbt f2 xs env withChld
    | otherwise = filterCellsRbt f2 xs env withChld

pickRandom l gen = let i = head (randomNumbers (length l) gen)
                    in l!!i

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


