#!/usr/bin/env bash

SCRIPT="$HOME/.config/custom_scripts/actions.sh"

choice=$("$SCRIPT" | fuzzel --dmenu --no-icons --prompt="󰖟 Search: ")

if [ -n "$choice" ]; then
    "$SCRIPT" "$choice"
fi
