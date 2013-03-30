-- File: .xmonad/xmonad.hs

-- Based on xmonad example config file for xmonad-0.9
--
-- Run xmonad --recompile or enter Super/Meta-Q to compile this configuration
-- file.
--
import XMonad
import XMonad.Config.Desktop
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.LayoutModifier
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (manageDocks,avoidStruts,AvoidStruts)
import XMonad.Hooks.ManageHelpers (isFullscreen,doFullFloat)
import XMonad.Hooks.SetWMName
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Loggers
import XMonad.Util.Run
import Graphics.X11.ExtraTypes.XF86
import Control.Monad ((=<<))
import Data.Monoid
import Data.Ratio ((%))
import System.IO (hPutStrLn)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- mod1Mask is left-Alt, mod3Mask is right-Alt,
-- mod4Mask is Super (also referred to by a certain registered trademark)
myModMask    = mod4Mask

-- Workspaces.  Name workspaces by putting them in a list like this:
myWorkspaces = ["1:xterm", "2:web", "3:mail", "4:music", "5:chat", "6:gimp", "7", "8", "9"]
 
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
        , resource =? "empathy"         --> doShift "3:chat"
        , className =? "Empathy"        --> doShift "3:chat"
        , className =? "Firefox"        --> doShift "2:web"
        , (className =? "Firefox" <&&> fmap (/= "Navigator") appName) --> doFloat
        , className =? "Thunderbird"    --> doShift "5:mail"
        , (className =? "Thunderbird" <&&> className =? "Dialog")    --> doFloat
	, stringProperty "WM_WINDOW_ROLE" =? "AlarmWindow"     --> doFloat
        , className =? "Amarok"         --> doShift "4:music"
        , className =? "ario"         --> doShift "4:music"
        , resource  =? "desktop_window" --> doIgnore
        , resource  =? "kdesktop"       --> doIgnore 
        , isFullscreen                  --> doFullFloat
        ]

myLayoutHook = avoidStruts $ onWorkspace "5:chat" imLayout $
               onWorkspace "2:web" webLayout $
               onWorkspace "6:gimp" gimpLayout $
               layoutHook defaultConfig
  where imLayout = desktopLayoutModifiers $ withIM (1%5) imRoster Grid ||| Full
        imRoster = ClassName "Pidgin" `And` Role "buddy_list"
        webLayout = desktopLayoutModifiers $ Full ||| Tall 1 (3%100) (1%2)
        gimpLayout = desktopLayoutModifiers $ withIM (0.20) (Role "gimp-toolbox") $
                     reflectHoriz $
                     withIM (0.20) (Role "gimp-dock") Full


myConfig = defaultConfig
    { terminal           = "urxvt"
    , modMask            = myModMask
    , borderWidth        = 3
    , workspaces         = myWorkspaces
    , manageHook         = manageDocks <+> myManageHook <+> manageHook defaultConfig
    , normalBorderColor  = "#eee8d5"
    , focusedBorderColor = "#268BD2"
    , layoutHook         = myLayoutHook
    , startupHook        = startupHook defaultConfig >> setWMName "LG3D"
    } `additionalKeys`
    [ ((controlMask .|. mod1Mask, xK_l),
            spawn "/usr/bin/xscreensaver-command --lock")
    , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight -inc 20 -steps 1 -time 1")
    , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 20 -steps 1 -time 1")
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 3%+")
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 3%-")
    , ((0, xF86XK_AudioMute), spawn "amixer set Master toggle")
    ]

---------------------------------
-- Main function
main = xmonad =<< xmobar myConfig
