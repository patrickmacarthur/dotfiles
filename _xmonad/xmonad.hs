-- File: .xmonad/xmonad.hs

-- Based on xmonad example config file for xmonad-0.9
--
import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers (isFullscreen,doFullFloat)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Loggers
import Data.Monoid

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
    [ ((myModMask .|. shiftMask, xK_q), spawn "gnome-session-save --gui --logout-dialog")
 
    -- Lock Screen
    , ((myModMask .|. shiftMask, xK_l), spawn "gnome-screensaver-command -l")
    -- Logout
    , ((myModMask .|. mod1Mask .|. shiftMask, xK_l), spawn "gnome-session-save --gui --kill")
    -- Sleep
    --, ((mod1Mask, xK_apostrophe), spawn "gnome-power-cmd.sh suspend")
    -- Reboot
    , ((mod1Mask .|. shiftMask, xK_comma), spawn "gnome-power-cmd.sh reboot")
    -- Deep Sleep
    , ((mod1Mask .|. shiftMask, xK_period), spawn "gnome-power-cmd.sh hibernate")
    -- Shut down
    , ((mod1Mask .|. shiftMask, xK_p), spawn "gnome-power-cmd.sh shutdown")
    ]
 
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
        , className =? "Amarokapp"      --> doFloat
        , className =? "Xmessage"       --> doFloat
        , className =? "Zenity"         --> doFloat
        , className =? "Pidgin"         --> doShift "3:chat"
        , className =? "Empathy"        --> doShift "3:chat"
        , className =? "Firefox"        --> doShift "2:web"
        , (className =? "Firefox" <&&> resource =? "Dialog") --> doFloat
        , className =? "Amarok"         --> doShift "4:music"
        , className =? "Kontact"        --> doShift "5:mail"
        , className =? "Evolution"      --> doShift "5:mail"
        , resource  =? "desktop_window" --> doIgnore
        , resource  =? "kdesktop"       --> doIgnore 
        , isFullscreen                  --> doFullFloat
        ]

---------------------------------
-- Main function
main = xmonad $ gnomeConfig
    { terminal           = "gnome-terminal"
    , modMask            = myModMask
    , borderWidth        = 3
    , workspaces         = myWorkspaces
    , manageHook         = myManageHook <+> manageHook gnomeConfig
    , normalBorderColor  = "#888A85"
    , focusedBorderColor = "#0000BF"
    } `additionalKeys` myKeys

