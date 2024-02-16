#!/bin/bash

# File path to i3 config
I3_CONFIG="$HOME/.config/i3/config"

# Extract keybindings from the i3 config
keybinds=$(grep '^bindsym' "$I3_CONFIG" | awk '
{
    key = $2;
    cmd = substr($0, index($0,$3));
    printf "%s: %s\n", key, cmd;
}')

# Display keybindings with zenity in a simple list
echo "$keybinds" | zenity --text-info --title="i3 Keybindings" --width=600 --height=400

