{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances #-}

-- import XMonad.Util.Ungrab
-- import XMonad.Operations (unGrab)

import Graphics.X11.ExtraTypes.XF86
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.GroupNavigation
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.ToggleLayouts
import XMonad.StackSet
import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce (spawnOnce)

main :: IO ()
main =
  xmonad
    . ewmhFullscreen
    . ewmh
    . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) toggleStrutsKey
    $ myConfig
  where
    toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
    toggleStrutsKey XConfig {modMask = m} = (m, xK_End)

-- data SPACING = SPACING deriving (Read, Show, Eq)
--
-- instance Transformer SPACING Window where
--   transform _ x k = spacingWithEdge 3

myConfig =
  let terminal = "kitty tmux attach-session"
      browser = "zen"
      modm = mod4Mask -- super/meta
   in def
        { modMask = modm,
          terminal = terminal,
          startupHook = myStartupHook,
          layoutHook = toggleLayouts myLayout $ spacingWithEdge 3 myLayout,
          logHook = historyHook
        }
        `additionalKeysP` [ ("M-b", spawn browser),
                            -- , ("M-t", spawn terminal)
                            -- , ("M-S-Enter", spawn terminal)
                            -- , ("<Print>", spawn "scrot ~/Pictures/Screenshots/%b-%d::%H-%M-%S.png")
                            ("<Print>", spawn "/home/fredrikr/.scrot.sh")
                            -- , ("<M-S-s>", unGrab *> spawn "scrot -s ~/Pictures/Screenshots/%b-%d::%H-%M-%S.png")
                          ]
        `additionalKeys` [ ((mod1Mask, xK_Tab), nextMatch History (return True)),
                           ((modm, xK_Escape), spawn "dm-tool lock"),
                           ((modm, xK_Down), nextWS),
                           ((modm, xK_Up), prevWS),
                           ((modm .|. shiftMask, xK_Down), shiftToNext),
                           ((modm .|. shiftMask, xK_Up), shiftToPrev),
                           ((modm, xK_z), spawn "zathura"),
                           ((modm, xK_y), withFocused $ windows . sink), -- %! Push window back into tiling
                           ((modm, xK_i), sendMessage Shrink), -- %! Shrink the master area
                           ((modm, xK_o), sendMessage Expand), -- %! Expand the master area
                           ((modm, xK_r), withFocused $ windows . sink), -- %! Resize viewed windows to the correct size
                           ((modm, xK_a), sequence_ [sendMessage ToggleStruts, sendMessage ToggleLayout]),
                           ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 2%-"),
                           ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 2%+"),
                           ((0, xF86XK_AudioMute), spawn "amixer set Master toggle"),
                           ((0, xF86XK_MonBrightnessUp), spawn "brightnessctl set 5%+"),
                           ((0, xF86XK_MonBrightnessDown), spawn "brightnessctl set 5%-"),
                           ((modm .|. shiftMask, xK_Return), spawn terminal)
                           -- ((modm, xK_e), spawn "emacsclient -c -a emacs")
                         ]
        ++ [ ((m .|. modm, k), windows $ f i)
             | (i, k) <- zip myWorkspaces numPadKeys,
               (f, m) <- [(greedyView, 0), (shift, shiftMask)]
           ]
        ++ [ ((m .|. modm, k), windows $ f i)
             | (i, k) <- zip myWorkspaces myWSKeys,
               (f, m) <- [(greedyView, 0), (shift, shiftMask)]
           ]
  where
    myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    -- Non-numeric num pad keys, sorted by number
    numPadKeys =
      [ xK_KP_End,
        xK_KP_Down,
        xK_KP_Page_Down, -- 1, 2, 3
        xK_KP_Left,
        xK_KP_Begin,
        xK_KP_Right, -- 4, 5, 6
        xK_KP_Home,
        xK_KP_Up,
        xK_KP_Page_Up, -- 7, 8, 9
        xK_KP_Insert -- 0
      ]
    myWSKeys = [xK_h, xK_t, xK_n, xK_s] ++ [xK_5 .. xK_9]

myXmobarPP :: PP
myXmobarPP =
  def
    { ppSep = purple " • ",
      ppTitleSanitize = xmobarStrip,
      ppCurrent = wrap "" "" . xmobarBorder "Top" "#8be9fd" 2,
      ppHidden = white . wrap "" "",
      ppHiddenNoWindows = white . wrap "" "",
      ppUrgent = red . wrap (yellow "!") (yellow "!"),
      ppOrder = \[ws, l, _, wins] -> [ws, l, wins],
      ppExtras = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused = wrap (white "[") (white "]") . purple . ppWindow
    formatUnfocused = wrap (white "[") (white "]") . blue . ppWindow

    -- \| Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    purple = xmobarColor "#bd93f9" ""
    green = xmobarColor "#50fa7b" ""
    blue = xmobarColor "#8be9fd" ""
    yellow = xmobarColor "#f1fa8c" ""
    white = xmobarColor "#f8f8f2" ""
    black = xmobarColor "#282a36" ""
    gray = xmobarColor "#44475a" ""
    comment = xmobarColor "#6272a4" ""
    red = xmobarColor "#ff5555" ""
    orange = xmobarColor "#ffb86c" ""

myStartupHook :: X ()
myStartupHook = do
  spawnOnce
    "trayer --edge bottom --align right --SetDockType true \
    \--SetPartialStrut true --expand false --width 5 --transparent true \
    \--alpha 0 --tint 0x000000 --height 18 --distance 0"
  spawnOnce "feh --bg-fill --no-fehbg /usr/share/nix.png"

myLayout = avoidStruts $ smartBorders tiled ||| smartBorders (Mirror tiled) ||| smartBorders Full
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1 -- Default number of windows in the master pane
    ratio = 3 / 5 -- Default proportion of screen occupied by master pane
    delta = 2 / 100 -- Percent of screen to increment by when resizing panes

-- toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_a)
