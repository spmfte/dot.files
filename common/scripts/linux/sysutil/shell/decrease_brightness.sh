#!/bin/bash

current_brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)
new_brightness=$((current_brightness - (max_brightness / 20)))  # Decrease by 5% of max brightness

# Ensure we don't go below 0
if [[ $new_brightness -lt 0 ]]; then
    new_brightness=0
fi

echo $new_brightness | sudo tee /sys/class/backlight/intel_backlight/brightness > /dev/null


