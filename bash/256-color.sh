#!/usr/bin/env bash

# Writes out the colours available in a 256 colour terminal.
#
# http://unix.stackexchange.com/a/124409/88207

color=16;

while [ $color -lt 245 ]; do
    echo -e "$color: \\033[38;5;${color}mhello\\033[48;5;${color}mworld\\033[0m"
    ((color++));
done 
