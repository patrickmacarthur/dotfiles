-- File: .xmonad/xmonad.hs

-- Based on xmonad example config file for xmonad-0.9
--
-- Run xmonad --recompile or enter Super/Meta-Q to compile this configuration
-- file.
--
import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import Control.OldException(catchDyn,try)
import DBus
import DBus.Connection
import DBus.Message
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (avoidStruts)
import XMonad.Hooks.ManageHelpers (isFullscreen,doFullFloat)
import XMonad.Hooks.SetWMName
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Loggers
import Data.Monoid
import Data.Ratio ((%))

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- mod1Mask is left-Alt, mod3Mask is right-Alt,
-- mod4Mask is Super (also referred to by a certain registered trademark)
myModMask    = mod4Mask

-- Workspaces.  Name workspaces by putting them in a list like this:
--    workspaces = ["1:web", "2:irc", "3:code"] ++ map show [4..9]
myWorkspaces = ["1:xterm", "2:web", "3:chat", "4:music", "5:mail"] ++ map show [6..9]

------------------------------------------------------------------------
-- Additional key bindings. Add, modify or remove key bindings here.
--
myKeys =
    -- Quit xmonad
    [ ((myModMask .|. shiftMask, xK_q), spawn "gnome-session-save --gui --logout-dialog") ]
 
------------------------------------------------------------------------
-- Window rules:
 
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll $
        [ className =? "MPlayer"        --> doFloat
        , className =? "Gimp"           --> doFloat
        , className =? "Xmessage"       --> doFloat
        , className =? "Zenity"         --> doFloat
        , className =? "Pidgin"         --> doShift "3:chat"
        , className =? "Empathy"        --> doShift "3:chat"
        , className =? "Firefox"        --> doShift "2:web"
        , (className =? "Firefox" <&&> fmap (/= "Navigator") appName) --> doFloat
        , className =? "Amarok"         --> doShift "4:music"
        , className =? "Kontact"        --> doShift "5:mail"
        , className =? "Evolution"      --> doShift "5:mail"
        , resource  =? "desktop_window" --> doIgnore
        , resource  =? "kdesktop"       --> doIgnore 
        , isFullscreen                  --> doFullFloat
        ]

myLayoutHook = onWorkspace "3:chat" imLayout $
               onWorkspace "2:web" webLayout $
               layoutHook gnomeConfig
  where imLayout = avoidStruts $ withIM (1%5) imRoster Grid ||| Full
        imRoster = ClassName "Empathy" `And` Role "contact_list"
        webLayout = avoidStruts $ Full ||| Tall 1 (3%100) (1%2)

myPrettyPrinter :: Connection -> PP
myPrettyPrinter dbus = defaultPP 
  { ppOutput  = outputThroughDBus dbus
  , ppTitle   = pangoColor "#003366" . shorten 50 . pangoSanitize
  , ppCurrent = pangoColor "#006666" . wrap "[" "]" . pangoSanitize
  , ppVisible = pangoColor "#663366" . wrap "(" ")" . pangoSanitize
  , ppHidden  = wrap " " " "
  , ppUrgent  = pangoColor "red"
  }

---------------------------------
-- Main function
main = withConnection Session $ \ dbus -> do
  getWellKnownName dbus
  xmonad $ gnomeConfig
    { terminal           = "gnome-terminal"
    , modMask            = myModMask
    , borderWidth        = 3
    , workspaces         = myWorkspaces
    , manageHook         = myManageHook <+> manageHook gnomeConfig
    , normalBorderColor  = "#888A85"
    , focusedBorderColor = "#0000BF"
    , layoutHook         = myLayoutHook
    , startupHook        = startupHook gnomeConfig >> setWMName "LG3D"
    , logHook            = dynamicLogWithPP (myPrettyPrinter dbus)
    } `additionalKeys` myKeys

--
-- Support Functions courtesy of
-- http://git.uhsure.com/?p=xmonad.git;a=blob;f=xmonad.hs
--

-- This retry is really awkward, but sometimes DBus won't let us get our
-- name unless we retry a couple times.
getWellKnownName :: Connection -> IO ()
getWellKnownName dbus = tryGetName `catchDyn` (\ (DBus.Error _ _) ->
                                                getWellKnownName dbus)
 where
  tryGetName = do
    namereq <- newMethodCall serviceDBus pathDBus interfaceDBus "RequestName"
    addArgs namereq [String "org.xmonad.Log", Word32 5]
    sendWithReplyAndBlock dbus namereq 0
    return ()

outputThroughDBus :: Connection -> String -> IO ()
outputThroughDBus dbus str = do
  let str' = "<span font=\"Terminus 9 Bold\">" ++ str ++ "</span>"
  msg <- newSignal "/org/xmonad/Log" "org.xmonad.Log" "Update"
  addArgs msg [String str']
  send dbus msg 0 `catchDyn` (\ (DBus.Error _ _ ) -> return 0)
  return ()

pangoColor :: String -> String -> String
pangoColor fg = wrap left right
 where
  left  = "<span foreground=\"" ++ fg ++ "\">"
  right = "</span>"

pangoSanitize :: String -> String
pangoSanitize = foldr sanitize ""
 where
  sanitize '>'  acc = "&gt;" ++ acc
  sanitize '<'  acc = "&lt;" ++ acc
  sanitize '\"' acc = "&quot;" ++ acc
  sanitize '&'  acc = "&amp;" ++ acc
  sanitize x    acc = x:acc

