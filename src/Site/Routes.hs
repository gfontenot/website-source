module Site.Routes
    ( indexedPostRoute
    , makeIndexed
    , wellKnown
    , makeHidden
    , makeRoot
    , toHTML
    , cssRoute
    ) where

import Hakyll
import System.FilePath
import Data.Monoid ((<>))

indexedPostRoute :: Routes
indexedPostRoute = customRoute $ \i ->
    let (path, name) = splitFileName $ toFilePath i
    in blogPath path </> postName name </> "index.html"

  where
    blogPath = flip replaceDirectory "blog"
    postName = takeBaseName . dropDatePrefix
    dropDatePrefix = drop 11

makeIndexed :: Routes
makeIndexed = customRoute $ \i ->
    let pathName = takeBaseName $ toFilePath i
    in pathName </> "index.html"

wellKnown :: Routes
wellKnown = customRoute $ \i ->
    ".well-known" </> fileName i

makeHidden :: Routes
makeHidden = customRoute $ \i ->
    "." <> fileName i

makeRoot :: Routes
makeRoot = customRoute fileName

toHTML :: Routes
toHTML = setExtension ".html"

cssRoute :: Routes
cssRoute = customRoute $ \i ->
    (flip replaceDirectory "css") $ (flip replaceExtension ".css") $ toFilePath i

fileName :: Identifier -> FilePath
fileName = takeFileName . toFilePath
