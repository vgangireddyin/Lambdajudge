# Lambdajudge [![Build Status](https://travis-ci.org/venugangireddy/Lambdajudge.svg?branch=master)](https://travis-ci.org/venugangireddy/Lambdajudge)

Lambdajudge is a library to easily host programming contests in haskell. This work is done as a project in [Functional Programming course](http://cse.iitk.ac.in/users/ppk/teaching/Functional-Programming/index.html).

#### Team members
- [Ankit Kumar](https://github.com/ankitku) (15111010)
- [Venugopal Reddy](https://github.com/venugangireddy) (14111043)
- [Safal Pandita](https://github.com/imhobo) (15111040)

### How to use
```haskell
import Lambdajudge

-- | Check if mueval is present, as lambdajudge needs mueval executable to run
check = muevalAvlbl --should return true. Only then can proceed using other functions.

-- | creating a sample Contest. input and output files are in the project directory
createContest :: IO Problem
createContest = do
    let dir = "test/contest1/Q1/"
    --Creating first problem of contest
    testCase1_1 <- getFileContents (dir </> "input00.txt")
    output1_1 <- getFileContents (dir </> "output00.txt")
    testCase2_2 <- getFileContents (dir </> "input02.txt")
    output2_2 <- getFileContents (dir </> "output02.txt")
    problemStatement1 <- getFileContents (dir </> "ProblemStatement1")
    problemSetterCode1 <- getFileContents (dir </> "Solution1/Solution.hs")
    --Creating second problem of contest
    testCase2_1 <- getFileContents (dir </> "input10.txt")
    output2_1 <- getFileContents (dir </> "output10.txt")
    testCase2_1 <- getFileContents (dir </> "input12.txt")
    output2_1 <- getFileContents (dir </> "output12.txt")
    problemStatement2 <- getFileContents (dir </> "ProblemStatement2")
    problemSetterCode2 <- getFileContents (dir </> "Solution2/Solution.hs")
    -- can further repeat to include more problems.
    let contest = [Problem problemStatement1 [(testCase1_1,output1_1),(testCase1_2,output1_2)] problemSetterCode1 5, 
                   Problem problemStatement2 [(testCase2_1,output2_1),(testCase2_2,output2_2)] problemSetterCode2 3]
    return contest
    
---run submitted solution on problem testcase
evaluate = do
            prob1 <- createContest!!1 -- evaluating on first problem of the contest
            runLJMonad $ gradeSubmission prob1 "SubmittedSolution.hs"
```

### Features
- Submitted code is run in mueval, which avoids attacks like unsafePerformIO etc..
- Only runs the "solution" function of type  String -> String. Hence, code has to be pure. So Type safety ensures     safety of execution.
- provides logging and error handling for debugging purposes

###Install from Hackage:
```shell
    $ cabal install Lambdajudge
```
###Install from unpacked release tarball or source repo:
```shell
    $ cd Lambdajudge
    $ cabal install
```
###Just play with it without installing:
```shell
    $ cabal build
    $ cabal repl
```
