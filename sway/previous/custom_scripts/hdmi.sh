#!/usr/bin/env bash

# ═════════════════════════════════════════════════════════════════════════════
# ~/.config/custom_scripts/hdmi.sh
# Native Wayland Display Switcher for UWM + Rofi
# Uses wlr-randr for output management
# ═════════════════════════════════════════════════════════════════════════════

LAPTOP="eDP-1"

if ! command -v wlr-randr &>/dev/null; then
    echo "wlr-randr not found" >&2
    exit 1
fi

# Auto-detect any connected non-laptop output
HDMI=$(wlr-randr | grep -E '^[A-Z]' | grep -v "$LAPTOP" | awk '{print $1}' | head -1)
if [ -z "$HDMI" ]; then
    echo "No external display detected" >&2
    exit 1
fi

chosen=$(printf "󰹑 Mirror\n󰍺 Extend\n󰑓 Reset" | \
    fuzzel --dmenu --no-icons --prompt="󰍹 Display: ")

[ -z "$chosen" ] && exit 0

case "$chosen" in
    *"Mirror"*)
        # Same resolution on both (projector supports 1366x768)
        wlr-randr --output "$LAPTOP" --mode 1366x768 --pos 0,0 \
                  --output "$HDMI" --mode 1366x768 --pos 0,0
        ;;
        
    *"Extend"*)
        # Laptop left, external right
        wlr-randr --output "$LAPTOP" --mode 1366x768 --pos 0,0 \
                  --output "$HDMI" --auto --pos 1366,0
        ;;
        
    *"Reset"*)
        # Laptop only
        wlr-randr --output "$HDMI" --off \
                  --output "$LAPTOP" --mode 1366x768 --pos 0,0
        ;;
esac
