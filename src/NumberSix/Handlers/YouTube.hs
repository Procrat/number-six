-- | Handler that allows looking up video's on YouTube
--
{-# LANGUAGE OverloadedStrings #-}
module NumberSix.Handlers.YouTube
    ( handler
    ) where

import Control.Applicative ((<$>))

import Data.ByteString (ByteString)
import Text.HTML.TagSoup
import qualified Data.ByteString.Char8 as B

import NumberSix.Irc
import NumberSix.Message
import NumberSix.Bang
import NumberSix.Util.Http
import NumberSix.Util.BitLy

youTube :: ByteString -> Irc ByteString
youTube query = do
    -- Find the first entry
    entry <- httpScrape url $ insideTag "entry"

    -- Find the title & URL in the entry
    let title = innerText $ insideTag "title" entry
        [TagOpen _ attrs] = take 1 $
            dropWhile (~/= TagOpen (B.pack "link") [("rel", "alternate")]) entry
        -- Also drop the '&feature...' part from the URL
        Just link = B.takeWhile (/= '&') <$> lookup "href" attrs

    -- Format and return
    textAndUrl title link
  where
    url = "http://gdata.youtube.com/feeds/api/videos?q=" <> urlEncode query

handler :: UninitiazedHandler
handler = makeBangHandler "youtube" ["!youtube", "!y"] youTube