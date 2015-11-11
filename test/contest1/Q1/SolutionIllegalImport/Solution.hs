-- | Main entry point to the application.
module Solution where
import Data.List
import System.Process
import System.IO.Unsafe

f' qs xs = map (\q-> show $ if last xs < q then -1 else (+1) $ length $ takeWhile (<q) xs) qs

recur n = recur n+1

solution str = undefined