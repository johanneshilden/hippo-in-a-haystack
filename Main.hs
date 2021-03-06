{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Applicative
import Data.Maybe                ( catMaybes, fromMaybe, mapMaybe )
import Data.Text                 ( Text )
import Hippo.Core

import qualified Data.Map.Strict as M

graph :: Graph
graph = construct
    [ ("employee",
        [ (1,   [200, 111, 1, 2])
        , (35,  [200, 111, 5, 6])
        , (200, [1, 20,  3, 4])
        ])
    , ("department",
        [ (111, [200, 7])
        , (20,  [35,  8])
        ])
    ]

datastore :: DataStore
datastore = M.fromList
    [ (1, Str "Bob")
    , (2, Str "Curry")
    , (3, Str "Jake")
    , (4, Str "Styles")
    , (5, Str "Hercule")
    , (6, Str "Poirot")
    , (7, Str "Sales")
    , (8, Str "Administration") ]

constraints :: [(Text, Text)]
constraints =
    [ ("employee.manager.worksIn"     , "employee.worksIn")
    , ("department.secretary.worksIn" , "department")
    , ("employee.manager.manager"     , "employee.manager") ]

structure :: Schema
structure =
    [ ("employee",
        [ ("manager"   , "employee")
        , ("worksIn"   , "department")
        , ("firstName" , "@")
        , ("lastName"  , "@")
        ])
    , ("department",
        [ ("secretary" , "employee")
        , ("name"      , "@")
        ])
    ]

smallGraph :: Graph
smallGraph = construct
    [ ("department",
        [(20,  [35,  8])
      ])
    ]

main :: IO ()
main = do
--    let g = merge smallGraph graph structure
--    print g
    --let g = queryGraph graph [("employee", [1, 2, 35]), ("department", [20])]
    let g = exQuery graph [("employee", [1, 2, 35]), ("department", [20])] structure
    print g

