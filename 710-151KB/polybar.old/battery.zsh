#!/bin/zsh

battery_info=$(acpi -b)
battery_level=$(echo $battery_info | awk '{print $4}' | tr -d '%,')
battery_status=$(echo $battery_info | awk '{print $3}' | tr -d ',')
battery_icon=""

# ANSI color codes for Zsh
RED="%{F#FF0000}"
GREEN="%{F#00FF00}"
YELLOW="%{F#FFFF00}"
ORANGE="%{F#FFA500}"
WHITE="%{F#FFFFFF}"

# Initialize color as white
battery_color=$WHITE

if (( battery_level <= 24 )); then
  battery_icon=""
  battery_color=$RED
elif (( battery_level <= 49 )); then
  battery_icon=""
  battery_color=$ORANGE
elif (( battery_level <= 74 )); then
  battery_icon=""
  battery_color=$YELLOW
else
  battery_icon=""
  battery_color=$GREEN
fi

# Change icon if battery is charging
if [[ $battery_status == "Charging" ]]; then
  battery_icon=""
  battery_color=$WHITE
fi

# Output with color and icon
echo "$battery_color$battery_icon  $battery_level%"

