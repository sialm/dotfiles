#!/bin/bash
#
# autostart

## GNOME PolicyKit and Keyring
eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg) &

## Set root window colour
hsetroot -solid "#2E3436" &

## Group start:
## 1. nitrogen - restores wallpaper
## 2. compositor - start
## 3. sleep - give compositor time to start
## 4. tint2 panel
(\
nitrogen --restore && \
cb-compositor --start \
) &

## sleep 2s && \
## tint2 \

## Volume control for systray
(sleep 2s && pnmixer) &

## Volume keys daemon
xfce4-volumed &

## Enable power management
xfce4-power-manager &

## Network widget
nm-applet &

## Start Thunar Daemon
thunar --daemon &

## Detect and configure touchpad. See 'man synclient' for more info.
if egrep -iq 'appletouch' /proc/bus/input/devices; then
    synclient FingerHigh=29 &
    synclient HorizTwoFingerScroll=1 &
    synclient CircularScrolling=1 CircScrollDelta=0.5 &
    #synclient TapButton1=1 TapButton2=3 TabButton3=2 &
    synclient VertScrollDelta=-26 HorizScrollDelta=-26 &
fi

## Start xscreensaver
xscreensaver -no-splash &

## Start Clipboard manager
(sleep 3s && clipit) &

## Set keyboard settings - 250 ms delay and 25 cps (characters per second) repeat rate.
## Adjust the values according to your preferances.
xset r rate 250 30 &

## Turn on/off system beep
xset b off &

## cb-fortune - have Waldorf say a little adage
#(sleep 120s && cb-fortune) &

## Run the conky
conky -q &

## Set up custom keybindings
xmodmap ~/.Xmodmap

## Start dropbox
~/.dropbox-dist/dropboxd &
