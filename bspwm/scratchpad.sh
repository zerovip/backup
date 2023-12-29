#!/usr/bin/bash
# See, Arch Wiki, bspwm
#   https://wiki.archlinux.org/index.php/Bspwm#Using_class_name

if [ -z $1 ]
then
	echo "Usage: $0 <name of hidden scratchpad window>"
	exit 1
fi

# The usage of xdotool, see, https://man.archlinux.org/man/xdotool.1.en
# `search --class`: supposed to be the `general class`
# `search --classname`: supposed to be the `particular instance class`
# See, https://unix.stackexchange.com/a/494170
#       and, https://www.x.org/docs/ICCCM/icccm.pdf
#
# All the changes here is because alacritty swaped the class’ general and instance
#   See, https://github.com/alacritty/alacritty/pull/6282
pids=$(xdotool search --classname ${1})
if [ -z ${pids} ]
then
    alacritty --class Alacritty,scratchpad \
        --config-file ${HOME}/.config/alacritty/alacritty_scratch.toml
else
    for pid in ${pids}
    do
	    echo "Toggle ${pid}"
	    bspc node ${pid} --flag hidden -f
    done
fi
