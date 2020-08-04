#!/usr/bin/env sh

# See, Arch Wiki: Polybar for the rules

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar, using default config location
# ~/.config/polybar/config
polybar zerobar &
