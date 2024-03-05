#!/bin/bash
touchscreen_id=$(xinput list | grep 'SYNA7501:00 06CB:16D2' | grep -oP 'id=\K\d+')
xrandr --output eDP1 --rotate inverted
xinput set-prop $touchscreen_id 'Coordinate Transformation Matrix' -1 0 1 0 -1 1 0 0 1
