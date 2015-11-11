module Paths_Lambdajudge (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/gangireddy/.cabal/bin"
libdir     = "/home/gangireddy/.cabal/lib/x86_64-linux-ghc-7.8.4/Lambdajudge-0.1.0.0"
datadir    = "/home/gangireddy/.cabal/share/x86_64-linux-ghc-7.8.4/Lambdajudge-0.1.0.0"
libexecdir = "/home/gangireddy/.cabal/libexec"
sysconfdir = "/home/gangireddy/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Lambdajudge_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Lambdajudge_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "Lambdajudge_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Lambdajudge_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Lambdajudge_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
