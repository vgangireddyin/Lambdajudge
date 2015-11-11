{-|
Module      : Lambdajudge
Description : Easily host haskell based coding competitions using Lambdajudge library
Copyright   : (c) Ankit Kumar, 2015
License     : MIT
Maintainer  : ankitkumar.itbhu@gmail.com
Stability   : experimental
Portability : POSIX

-}


{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE FlexibleContexts #-}

module Lambdajudge 
(
  muevalAvlbl,
  gradeSubmission,
  runLJMonad
) where

import System.Environment
import System.FilePath
import System.Timeout
import System.Process
import System.Exit
import System.IO
import Data.List

import Control.Monad.State
import Control.Monad.Writer
import Control.Monad.Error
import Control.Monad.Identity
import Control.Exception

import DataStructures
import Utility

-- TODO : export functions finalize, check if mueval present, parallelize, count threads, loading, logging

-- | runs "solution" function loaded from the Submitted solution file within mueval. The expression is provided contents of test cases as input
runSubmission :: MuevalCommand -> LJMonad StatusCode
runSubmission mue = do
         let options = ["-t", show $ maxRunTime mue] ++
                       ["-e", "lines (" ++ expression mue ++ " " ++ show (testData mue) ++ ") == lines (" ++ (trim . show) (ansData mue) ++ ")"] ++
                       ["-l", solutionFile mue]
         (status,out,err) <- liftIO $ readProcessWithExitCode "mueval" options ""
         tell $ show (status,out,err)
         liftIO $ print (status,out,err)
         modify succ
         case status of
          ExitSuccess -> case err of
            "" -> if (read out :: Bool)
                   then return AC
                   else return WA
          ExitFailure a -> if "Time limit exceeded" `isInfixOf` err
                   then return TLE
                   else error err

-- | maps evaluation of solution file to each test case of the problem. Effectively we are sequencing the runs corresponding to each test case
gradeSubmission :: Problem -> FilePath -> LJMonad [StatusCode]
gradeSubmission prob solutionFile = do
         let computations = map (\i -> uncurry (MuevalCommand "solution") (testCases prob!!i) solutionFile (timeLimit prob)) [0..length (testCases prob) - 1]
         mapM runSubmission computations

-- | runs submitted code on problem testcases
runLJMonad :: Num s => WriterT w (StateT s (ErrorT e m)) a -> m (Either e ((a, w), s))
runLJMonad = runErrorT . flip runStateT 0 . runWriterT


-- | Idiom to catch any type of exception thrown
catchAny :: IO a -> (SomeException -> IO a) -> IO a
catchAny = Control.Exception.catch


-- | Check if mueval is installed on this system
muevalAvlbl :: IO Bool
muevalAvlbl = do
       res <- liftIO $ catchAny (readProcessWithExitCode "mueval1" ["-e","1+1"] "") $ \e -> do
              putStrLn "Got an exception."
              return (ExitFailure 1,"","")
       case res of
         (ExitSuccess,out,err) -> return True
         otherwise -> return False



-- | creating a sample Contest
createContest :: IO Problem
createContest = do
    let dir = "test/contest1/Q1/"
    t1 <- getFileContents (dir </> "input00.txt")
    s1 <- getFileContents (dir </> "output00.txt")
    t2 <- getFileContents (dir </> "input02.txt")
    s2 <- getFileContents (dir </> "output02.txt")
    ps1 <- getFileContents (dir </> "ProblemStatement")
    sol1 <- getFileContents (dir </> "Solution/Solution.hs")
    return $ Problem ps1 [(t1,s1),(t2,s2)] sol1 5

test = do
        prob1 <- Lambdajudge.createContest
        runLJMonad $ gradeSubmission prob1 "test/contest1/Q1/SolutionIllegalImport/Solution.hs"
