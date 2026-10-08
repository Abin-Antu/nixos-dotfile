#!/bin/bash

# Colors (RGBA)
WHITE='#ffffffff'
WHITE_DIM='#ffffff66'
CLEAR='#00000000'
RED='#b04a4aff'
VERIFY='#ffffff22'

i3lock \
--image=$HOME/Pictures/lock_wallpaper.png \
--blur 5 \
--clock \
--indicator \
\
--ind-pos="x+150:y+h-150" \
\
--time-str="%H:%M:%S" \
--time-color=$WHITE \
--time-size=30 \
--time-font="FiraCode Nerd Font:style=Bold" \
\
--date-str="%A, %d %b %Y" \
--date-color=$WHITE_DIM \
--date-size=12 \
--date-font="FiraCode Nerd Font" \
\
--ring-color=$WHITE_DIM \
--inside-color=$CLEAR \
--separator-color=$CLEAR \
\
--ringver-color=$WHITE \
--insidever-color=$VERIFY \
\
--ringwrong-color=$RED \
--insidewrong-color=$CLEAR \
\
--keyhl-color=$WHITE \
--bshl-color=$RED \
\
--verif-text="CHECKING" \
--wrong-text="FAILED" \
--radius=100 \
--ring-width=8 \
--verif-color=$WHITE \
--wrong-color=$RED \
--line-uses-inside \
--ignore-empty-password \
--screen 1 \
