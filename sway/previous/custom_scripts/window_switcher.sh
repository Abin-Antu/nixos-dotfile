#!/usr/bin/env bash
selection=$(
  wlrctl toplevel list |
    fuzzel --dmenu --no-icons --prompt="󱂬 Switch: "
)
[ -z "$selection" ] && exit 0

app_id="${selection%%: *}"
title="${selection#*: }"

if [ -n "$app_id" ] && [ "$app_id" != "null" ]; then
  wlrctl toplevel focus app_id:"$app_id"
else
  wlrctl toplevel focus title:"$title"
fi
