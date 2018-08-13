module Main (main) where

import Bouzuya.HTTP.Client (fetch, url)
import Data.Options ((:=))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log, logShow)
import Prelude (Unit, bind, discard)

main :: Effect Unit
main = launchAff_ do
  liftEffect (log "Hello")
  let options = url := "https://bouzuya.net/"
  { body, status } <- fetch options
  liftEffect (logShow body)
  liftEffect (logShow status)
