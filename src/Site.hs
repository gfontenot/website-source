{-# LANGUAGE OverloadedStrings #-}

import Hakyll

import Site.Constants
import Site.Routes
import Site.Patterns
import Site.Contexts
import Site.Configurations
import Site.URLHelper
import Site.Compilers

main :: IO ()
main = hakyllWith hakyllConfig $ do
    match allPosts $ do
        route indexedPostRoute
        compile $ baseCompiler
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= replaceIndexLinks

    create ["index.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll allPosts
            let ctx = blogCtx posts

            makeItem ""
                >>= loadAndApplyTemplate "templates/blog.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= replaceIndexLinks

    create ["feed.xml"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAllSnapshots allPosts "content"

            renderAtom feedConfig feedItemCtx posts
                >>= replaceIndexURLs siteHost
                >>= repairExternalURLs siteHost
                >>= replaceRelativeURLs siteHost

    match "main/*.markdown" $ do
        route makeIndexed
        compile $ baseCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= replaceIndexLinks

    match "404.markdown" $ do
        route toHTML
        compile $ baseCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= replaceIndexLinks

    match "pgp/keybase.txt" $ do
        route wellKnown
        compile copyFileCompiler

    match "root/nojekyll" $ do
        route makeHidden
        compile copyFileCompiler

    compileTemplates $
             "templates/*"
        .||. "partials/*"

    copyInPlace $
             "images/*"
        .||. "css/*"
        .||. "javascript/*"
        .||. "font/*"
        .||. "pgp/*"

    match "root/*" $ do
        route makeRoot
        compile copyFileCompiler
