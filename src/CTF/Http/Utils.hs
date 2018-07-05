module CTF.Http.Utils (hexdigest, replyJson) where

import Crypto.Hash.Algorithms (SHA3_512)
import Crypto.MAC.HMAC (hmac, HMAC)
import Data.ByteArray (unpack)
import Data.ByteString (ByteString)
import Data.ByteString.Lazy (length)
import Data.Text.Encoding (encodeUtf8)
import Data.Text (pack, Text)
import Text.Bytedump (dumpRaw)
import Data.Aeson (ToJSON, encode)
import Network.Wai (Response, responseLBS)
import Network.HTTP.Types.Status (Status)
import Network.HTTP.Types.Header (hContentType, hContentLength)


key :: ByteString
key = encodeUtf8 "this is very secret so that nobody can steal it"


hexdigest :: Text -> Text
hexdigest message =
    let d = encodeUtf8 message
        h = hmac key d :: HMAC SHA3_512
        w = unpack h
    in
        pack $ dumpRaw w


replyJson :: ToJSON a => Status -> a -> Response
replyJson status val =
  let dat     = encode val
      hLength = pack . show . Data.ByteString.Lazy.length $ dat
      headers = [ (hContentType, encodeUtf8 "application/json")
                , (hContentLength, encodeUtf8 hLength)
                ]
  in responseLBS status headers dat
