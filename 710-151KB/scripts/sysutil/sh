#!/bin/bash

current_brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)
new_brightness=$((current_brightness + (max_brightness / 20)))  # Increase by 5% of max brightness

# Ensure we don't exceed max_brightness
if [[ $new_brightness -gt $max_brightness ]]; then
    new_brightness=$max_brightness
fi

echo $new_brightness | sudo tee /sys/class/backlight/intel_backlight/brightness > /dev/null

