module CTF.Http where

import Network.Wai (Application, Response)
import Network.Wai.Routing (Routes, route, prepare, get, continue)
import Data.Predicate (true)

import CTF.Http.Utils


app :: Application
app = route (prepare start)


start :: Routes a IO ()
start = do
  get "/" (continue getHome) true


getHome :: () -> IO Response
getHome =
