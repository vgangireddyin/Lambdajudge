module LambdajudgeSpec where

import Test.Hspec
import System.FilePath
import System.IO
import Control.Monad.State
import Control.Monad.Writer
import Control.Monad.Error
import Control.Monad.Identity

import Lambdajudge
import DataStructures
import Utility

main :: IO()
main = hspec spec

spec :: Spec
spec =  do
  describe "Lambdajudge.gradeSubmission" $
    it "returns the AC result of evaluating correct solution file on test cases" $ do
            prob1 <- LambdajudgeSpec.createContest
            Right ((xs, _), _) <- liftIO $ runLJMonad $ gradeSubmission prob1 "test/contest1/Q1/Solution/Solution.hs" 
            xs `shouldBe` [AC,AC]

  describe "Lambdajudge.gradeSubmission" $
    it "returns the WA result of evaluating wrong solution file on test cases" $ do
            prob1 <- LambdajudgeSpec.createContest
            Right ((xs, _), _) <- liftIO $ runLJMonad $ gradeSubmission prob1 "test/contest1/Q1/SolutionWA/Solution.hs" 
            xs `shouldBe` [WA,WA]

  describe "Lambdajudge.gradeSubmission" $
    it "returns the TLE result of evaluating recursive solution file on test cases" $ do
            prob1 <- LambdajudgeSpec.createContest
            Right ((xs, _), _) <- liftIO $ runLJMonad $ gradeSubmission prob1 "test/contest1/Q1/SolutionTLE/Solution.hs" 
            xs `shouldBe` [TLE,TLE]

-- | creating a sample Contest
createContest :: IO Problem
createContest = do
    let dir = "test/contest1/Q1/"
    t1 <- getFileContents (dir </> "input00.txt")
    s1 <- getFileContents (dir </> "output00.txt")
    t2 <- getFileContents (dir </> "input02.txt")
    s2 <- getFileContents (dir </> "output02.txt") 
    ps1 <- getFileContents (dir </> "ProblemStatement")
    sol1 <- getFileContents (dir </> "Solution" </> "Solution.hs")
    return $ Problem ps1 [(t1,s1),(t2,s2)] sol1 5
        
