#!/usr/bin/bash
# See, Arch Wiki, bspwm
#   https://wiki.archlinux.org/index.php/Bspwm#Using_class_name

if [ -z $1 ]; then
	echo "Usage: $0 <name of hidden scratchpad window>"
	exit 1
fi

pids=$(xdotool search --class ${1})
for pid in $pids; do
	echo "Toggle $pid"
	bspc node $pid --flag hidden -f
done
