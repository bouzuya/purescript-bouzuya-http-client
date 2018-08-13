module Bouzuya.HTTP.Client
  ( FetchOptions
  , body
  , defaults
  , fetch
  , headers
  , method
  , url
  ) where

import Bouzuya.HTTP.Method (Method)
import Bouzuya.HTTP.Method as Method
import Bouzuya.HTTP.StatusCode (StatusCode, status204)
import Bouzuya.HTTP.StatusCode as StatusCode
import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Functor.Contravariant (cmap)
import Data.Maybe (Maybe(..), fromJust)
import Data.Options (Option, Options, defaultToOptions, opt, options)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Foreign (Foreign)
import Foreign.Object (Object)
import Partial.Unsafe (unsafePartial)
import Prelude (append, bind, eq, pure, show)

data FetchOptions
data FetchResponse

foreign import fetchImpl :: Foreign -> Effect (Promise FetchResponse)

foreign import textImpl :: FetchResponse -> String

foreign import statusImpl :: FetchResponse -> Int

body :: Option FetchOptions String
body = opt "body"

defaults :: Options FetchOptions
defaults = defaultToOptions "method" (show Method.GET)

headers :: Option FetchOptions (Object String)
headers = opt "headers"

method :: Option FetchOptions Method
method = cmap show (opt "method")

url :: Option FetchOptions String
url = opt "url"

fetch :: Options FetchOptions -> Aff { body :: Maybe String, status :: StatusCode }
fetch opts = do
  promise <- liftEffect (fetchImpl (options (append defaults opts)))
  response <- Promise.toAff promise
  let
    statusCodeAsInt = statusImpl response
    status = unsafePartial (fromJust (StatusCode.fromInt statusCodeAsInt))
  pure
    { body:
        if eq status status204
          then Nothing
          else Just (textImpl response)
    , status
    }
