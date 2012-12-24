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
import XMonad.Hooks.ManageDocks (avoidStruts,AvoidStruts)
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
myWorkspaces = ["1:xterm", "2:web", "3:mail", "4:music", "5:chat", "6:gimp", "7", "8", "9"]

------------------------------------------------------------------------
-- Additional key bindings. Add, modify or remove key bindings here.
--
myKeys = [ ((controlMask .|. mod1Mask, xK_l),
            spawn "/usr/bin/xscreensaver-command --lock") ]
 
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
	, stringProperty "WM_WINDOW_ROLE" =? "AlarmWindow"     --> doFloat
        , className =? "Amarok"         --> doShift "4:music"
        , className =? "ario"         --> doShift "4:music"
        , resource  =? "desktop_window" --> doIgnore
        , resource  =? "kdesktop"       --> doIgnore 
        , isFullscreen                  --> doFullFloat
        ]

myLayoutHook = onWorkspace "5:chat" imLayout $
               onWorkspace "2:web" webLayout $
               onWorkspace "6:gimp" gimpLayout $
               layoutHook defaultConfig
  where imLayout = desktopLayoutModifiers $ withIM (1%5) imRoster Grid ||| Full
        imRoster = ClassName "Pidgin" `And` Role "buddy_list"
        webLayout = desktopLayoutModifiers $ Full ||| Tall 1 (3%100) (1%2)
        gimpLayout = desktopLayoutModifiers $ withIM (0.20) (Role "gimp-toolbox") $
                     reflectHoriz $
                     withIM (0.20) (Role "gimp-dock") Full

-- | Run xmonad with a dzen status bar set to some nice defaults.
--
-- > main = xmonad =<< dzen myConfig
-- >
-- > myConfig = defaultConfig { ... }
--
-- The intent is that the above config file should provide a nice
-- status bar with minimal effort.
--
-- If you wish to customize the status bar format at all, you'll have to
-- use the 'statusBar' function instead.
--
-- The binding uses the XMonad.Hooks.ManageDocks module to automatically
-- handle screen placement for dzen, and enables 'mod-b' for toggling
-- the menu bar.
--
myDzen conf = statusBar ("dzen2 " ++ flags) myDzenPP toggleStrutsKey conf
 where
    fg      = "'#657b83'" -- n.b quoting
    bg      = "'#073642'"
    flags   = "-e 'onstart=lower' -w 600 -ta l -fg " ++ fg ++ " -bg " ++ bg

-- | Settings to emulate dwm's statusbar, dzen only.
myDzenPP :: PP
myDzenPP = defaultPP { ppCurrent  = dzenColor "#268BD2" "#073642" . pad
                   , ppVisible  = dzenColor "#2AA198" "#073642" . pad
                   , ppHidden   = dzenColor "#93A1A1" "#073642" . pad
                   , ppHiddenNoWindows = const ""
                   , ppUrgent   = dzenColor "#DC322F" "#073642" . pad
                   , ppWsSep    = ""
                   , ppSep      = ""
                   , ppLayout   = dzenColor "#CB4B16" "#073642" .
                                  (\ x -> pad $ case x of
                                            "TilePrime Horizontal" -> "TTT"
                                            "TilePrime Vertical"   -> "[]="
                                            "Hinted Full"          -> "[ ]"
                                            _                      -> x
                                  )
                   , ppTitle    = ("^fg(#268BD2) " ++) . dzenEscape
                   }

-- |
-- Helper function which provides ToggleStruts keybinding
--
toggleStrutsKey :: XConfig t -> (KeyMask, KeySym)
toggleStrutsKey XConfig{modMask = modm} = (modm, xK_b )

myConfig = defaultConfig
    { terminal           = "urxvt"
    , modMask            = myModMask
    , borderWidth        = 3
    , workspaces         = myWorkspaces
    , manageHook         = myManageHook <+> manageHook defaultConfig
    , normalBorderColor  = "#eee8d5"
    , focusedBorderColor = "#268BD2"
    , layoutHook         = myLayoutHook
    , startupHook        = startupHook defaultConfig >> setWMName "LG3D"
    } `additionalKeys` myKeys

---------------------------------
-- Main function
main = xmonad =<< myDzen myConfig

