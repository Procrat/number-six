-- | Allow a god to set the topic
--
{-# LANGUAGE OverloadedStrings #-}
module NumberSix.Handlers.Topic
    ( handler
    ) where

import NumberSix.Irc
import NumberSix.Bang

import Data.ByteString (ByteString)

handler :: Handler ByteString
handler = makeHandler "topic" $ return $
    onBangCommand "!topic" $ onGod $ do
        channel <- getChannel
        topic <- getBangCommandText
        writeMessage "TOPIC" [channel, topic]
