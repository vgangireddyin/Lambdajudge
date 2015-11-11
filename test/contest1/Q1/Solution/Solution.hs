module Solution where
import Data.List
import Data.Ord
import Data.Array

readInt :: String -> Int
readInt = read

data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Show, Read, Eq)

singleton :: a -> Tree a
singleton x = Node x EmptyTree EmptyTree

treeInsert x EmptyTree = singleton x
treeInsert x (Node a left right)
    | snd x == snd a = Node x left right
    | snd x < snd a  = Node a (treeInsert x left) right
    | snd x > snd a  = Node a left (treeInsert x right)

treeElemPos x EmptyTree = -1
treeElemPos x (Node a left right)
    | x == snd a = fst a
    | x < snd a = if left == EmptyTree then fst a else treeElemPos x left
    | x > snd a = if right == EmptyTree then (+1) $ fst a else treeElemPos x right

f qs btree n = map (\q-> g q btree n) qs

g q btree n = show $ if pos > n then -1 else pos
                where pos = treeElemPos q btree

insertInBalancedTree [] = EmptyTree
insertInBalancedTree xs = Node m (insertInBalancedTree (filter (\(x,y)-> x < fst m) xs)) (insertInBalancedTree (filter (\(x,y)-> x > fst m) xs))
                 where m = xs !! div (length xs) 2

main :: IO ()
main = do
         txt <- getLine
         txt <- getLine
         let xs =  scanl1 (+).reverse.sort.map (\x->read x::Int) $ words txt --subse
         let binTree = insertInBalancedTree $ zip [1..length xs] xs
         txt <- getLine
         queryStrings <- fmap lines getContents
         let qs = map (\x-> read x::Int) queryStrings
         --putStrLn $ show binTree
         mapM_ putStrLn (f qs binTree (length xs))

solution :: String -> String
solution str =  unlines $ f qs binTree (length xs)
          where strs = lines str
                qs = map read $ drop 3 strs
                xs = scanl1 (+).reverse.sort.map read $ words $ strs!!1
                binTree = insertInBalancedTree $ zip [1..length xs] xs
