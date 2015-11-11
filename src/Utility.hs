module Utility where
import Data.Char
import System.IO

-- | removes newlines from both ends of text
trim :: String -> String
trim = let f = reverse . dropWhile (=='\n') in f . f

-- | reads contents of a file
getFileContents :: String -> IO String
getFileContents fileName = do
                inh <- openFile fileName ReadMode
                hGetContents inh