-- File: .xmonad/xmonad.hs

-- Based on xmonad example config file for xmonad 0.9+
--
-- Run xmonad --recompile or enter Super/Meta-Q to compile this configuration
-- file.
--
import XMonad
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers (isFullscreen,doFullFloat)
import XMonad.Hooks.SetWMName
import XMonad.Util.EZConfig (additionalKeys)
import Graphics.X11.ExtraTypes.XF86
import Data.Ratio ((%))

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
        , className =? "Xmessage"       --> doFloat
        , className =? "Zenity"         --> doFloat
        , className =? "Pidgin"         --> doShift "5:chat"
        , resource =? "empathy"         --> doShift "5:chat"
        , className =? "Empathy"        --> doShift "5:chat"
        , className =? "Firefox"        --> doShift "2:web"
        , (className =? "Firefox" <&&> fmap (/= "Navigator") appName) --> doFloat
        , className =? "Thunderbird"    --> doShift "3:mail"
        , (className =? "Thunderbird" <&&> className =? "Dialog")    --> doFloat
	, stringProperty "WM_WINDOW_ROLE" =? "AlarmWindow"     --> doFloat
        , className =? "Amarok"         --> doShift "4:music"
        , className =? "rhythmbox"      --> doShift "4:music"
        , className =? "ario"           --> doShift "4:music"
        , resource  =? "desktop_window" --> doIgnore
        , resource  =? "kdesktop"       --> doIgnore 
        , isFullscreen                  --> doFullFloat
        ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayoutHook = onWorkspace "5:chat" imLayout $
               onWorkspace "2:web" webLayout $
               onWorkspace "6:gimp" gimpLayout $
               layoutHook defaultConfig
  where imLayout = withIM (1%5) imRoster Grid ||| Full
        imRoster = ClassName "Pidgin" `And` Role "buddy_list"
        webLayout = Full ||| Tall 1 (3%100) (1%2)
        gimpLayout = withIM (0.20) (Role "gimp-toolbox") $
                     reflectHoriz $
                     withIM (0.20) (Role "gimp-dock") Full

-- | Run xmonad with a status bar.
--
-- The binding uses the XMonad.Hooks.ManageDocks module to automatically
-- handle screen placement for xmobar, and enables 'mod-b' for toggling
-- the menu bar.
--
myXmobar conf = statusBar "xmobar" myPP toggleStrutsKey conf
  where
  toggleStrutsKey XConfig{modMask = modm} = (modm, xK_b)
  myPP = defaultPP { ppCurrent  = wrap "[" "]" . xmobarColor "#268BD2" ""
                   , ppVisible  = wrap "[" "]" . xmobarColor "#2AA198" ""
                   , ppHidden   = pad . xmobarColor "#93A1A1" ""
                   , ppHiddenNoWindows = const ""
                   , ppUrgent   = pad . xmobarColor "#DC322F" ""
                   , ppWsSep    = ""
                   , ppLayout   = xmobarColor "#CB4B16" "" .
                                  (\ x -> case x of
                                            "TilePrime Horizontal" -> "TTT"
                                            "TilePrime Vertical"   -> "[]="
                                            "Hinted Full"          -> "[ ]"
                                            _                      -> x
                                  )
                   , ppTitle    = xmobarColor "#268BD2" "" . shorten 60
                   }

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
main = xmonad =<< myXmobar myConfig
