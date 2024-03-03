#!/bin/zsh
max=$(cat /sys/class/backlight/amdgpu_bl1/max_brightness)
current=$(cat /sys/class/backlight/amdgpu_bl1/brightness)
new=$((current - max / 10))
[ $new -lt 0 ] && new=0
echo $new | sudo tee /sys/class/backlight/amdgpu_bl1/brightness
