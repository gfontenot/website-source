module Site.Contexts
    ( blogCtx
    , postCtx
    , feedItemCtx
    ) where

import Hakyll

import Site.Constants

blogCtx :: [Item String] -> Tags -> Context String
blogCtx posts tags = mconcat
    [ listField "posts" (postCtx tags) (return posts)
    , constField "title" siteTitle
    , defaultContext
    ]

postCtx :: Tags -> Context String
postCtx tags = mconcat
    [ dateField "date" "%b %d, %Y"
    , tagsField "tags" tags
    , defaultContext
    ]

feedItemCtx :: Context String
feedItemCtx = mconcat
    [ dateField "date" "%a, %d %b %Y %H:%M:%S %z"
    , bodyField "description"
    , defaultContext
    ]
