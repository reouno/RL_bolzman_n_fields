module Paths_RL004bolzman (
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

bindir     = "/Users/reo/hsproject/RL_bolzman_n_fields/.stack-work/install/x86_64-osx/lts-4.1/7.10.3/bin"
libdir     = "/Users/reo/hsproject/RL_bolzman_n_fields/.stack-work/install/x86_64-osx/lts-4.1/7.10.3/lib/x86_64-osx-ghc-7.10.3/RL004bolzman-0.1.0.0-9OBL1ycyF5WITh50i1ROSZ"
datadir    = "/Users/reo/hsproject/RL_bolzman_n_fields/.stack-work/install/x86_64-osx/lts-4.1/7.10.3/share/x86_64-osx-ghc-7.10.3/RL004bolzman-0.1.0.0"
libexecdir = "/Users/reo/hsproject/RL_bolzman_n_fields/.stack-work/install/x86_64-osx/lts-4.1/7.10.3/libexec"
sysconfdir = "/Users/reo/hsproject/RL_bolzman_n_fields/.stack-work/install/x86_64-osx/lts-4.1/7.10.3/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "RL004bolzman_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "RL004bolzman_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "RL004bolzman_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "RL004bolzman_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "RL004bolzman_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
