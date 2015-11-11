{-# LANGUAGE FlexibleContexts #-}

module DataStructures where

import Control.Monad.State
import Control.Monad.Writer
import Control.Monad.Error

-- | counts number of times code has been evaluated against test cases
type ProcCount = Int

-- | Require logging, state and need to throw exceptions during computation
type LJMonad a = WriterT String (StateT ProcCount (ErrorT String IO)) a

-- | Content of the input file
type TestCase = String

-- | Content of the output file
type Answer = String

-- | group together a problem atatement, its input and outputs and max allowed time limit
data Problem = Problem {
    problemStatement :: String,
    testCases :: [(TestCase,Answer)],
    problemSetterCode :: String,
    timeLimit :: Int
}

-- | Contest is a list of problems
data Contest = Contest {
    problems :: [Problem]
}

-- | Status code determines the result of evaluation of the submitted code
data StatusCode  =  AC   -- Accepted
                  | WA   -- Wrong Answer
                  | TLE  -- Time Limit Exceeded
                  | NZEC -- Non zero exit code
                    deriving (Eq,Show)

type SubmissionResult = [ (TestCase , StatusCode) ]

-- | All that is required to run a mueval command
data MuevalCommand = MuevalCommand {
  expression :: String,
  testData :: String,
  ansData :: String,
  solutionFile :: String,
  maxRunTime :: Int
} deriving Show
