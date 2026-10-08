#!/usr/bin/env bash

# 1. Define Aliases
declare -A FAVS=(
    ["yt"]="youtube.com"
    ["gh"]="github.com"
    ["sb"]="supabase.com"
    ["gpt"]="chatgpt.com"
    ["gemini"]="gemini.google.com"
    ["aw"]="wiki.archlinux.org"
    ["red"]="reddit.com"
    ["ym"]="music.youtube.com"
    ["google"]="www.google.com"
    ["duck"]="duckduckgo.com"
)

# 2. STAGE 1: Provide list for dmenu
if [ -z "$1" ]; then
    echo ":d <query> ➜ DuckDuckGo"
    for alias in "${!FAVS[@]}"; do
        echo "$alias ➜ ${FAVS[$alias]}"
    done
    exit 0
fi

INPUT="$1"

# Strip " ➜ ..." suffix
CLEAN_INPUT=$(echo "$INPUT" | awk '{print $1}')

# 3. ROUTING LOGIC
if [[ -n "${FAVS[$CLEAN_INPUT]}" ]]; then
    TARGET="https://${FAVS[$CLEAN_INPUT]}"
elif [[ "$INPUT" =~ ^([0-9]+)$ ]]; then
    PORT="${BASH_REMATCH[1]}"
    TARGET="http://localhost:$PORT"
elif [[ "$INPUT" =~ ^:d\  ]]; then
    QUERY=$(echo "$INPUT" | sed 's/^:d //; s/ /+/g')
    TARGET="https://duckduckgo.com/?q=$QUERY"
elif [[ "$INPUT" =~ ^(s\ |\?\ ) ]]; then
    QUERY=$(echo "$INPUT" | sed 's/^[s?] //; s/ /+/g')
    TARGET="https://www.google.com/search?q=$QUERY"
elif [[ "$INPUT" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}(/.*)?$ ]]; then
    TARGET="$INPUT"
    [[ "$TARGET" != http* ]] && TARGET="https://$TARGET"
else
    QUERY=$(echo "$INPUT" | sed 's/ /+/g')
    TARGET="https://www.google.com/search?q=$QUERY"
fi

# 4. EXECUTION
# wlrctl 'find' exits with 0 (success) if a window matches the criteria.
# We check if there is an 'active' (focused) window matching the specific app_id.

if wlrctl window find state:active app_id:firefox 2>/dev/null; then
    # Firefox is currently active
    (setsid firefox --new-tab "$TARGET" &) > /dev/null 2>&1

elif wlrctl window find state:active app_id:librewolf 2>/dev/null; then
    # Librewolf is currently active
    (setsid librewolf -new-tab "$TARGET" &) > /dev/null 2>&1

else
    # Fallback: if dmenu/rofi/terminal is focused instead, 
    # or the app_id doesn't match perfectly.
    (setsid firefox "$TARGET" &) > /dev/null 2>&1
fi

exit 0
