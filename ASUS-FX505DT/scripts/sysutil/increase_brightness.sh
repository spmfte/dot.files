#!/bin/zsh
max=$(cat /sys/class/backlight/amdgpu_bl1/max_brightness)
current=$(cat /sys/class/backlight/amdgpu_bl1/brightness)
new=$((current + max / 10))
[ $new -gt $max ] && new=$max
echo $new | sudo tee /sys/class/backlight/amdgpu_bl1/brightness
