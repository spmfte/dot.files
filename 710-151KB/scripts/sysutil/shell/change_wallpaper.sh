#!/bin/bash

# Get the current hour
hour=$(date +%H)

# Define wallpaper directories
morning_dir="/path/to/morning/wallpapers"
afternoon_dir="/path/to/afternoon/wallpapers"
evening_dir="/path/to/evening/wallpapers"
night_dir="/path/to/night/wallpapers"

# Select the wallpaper directory based on the time of day
if (( 6 <= hour && hour < 12 )); then
    wallpaper_dir=$morning_dir
elif (( 12 <= hour && hour < 18 )); then
    wallpaper_dir=$afternoon_dir
elif (( 18 <= hour && hour < 22 )); then
    wallpaper_dir=$evening_dir
else
    wallpaper_dir=$night_dir
fi

# Select a random wallpaper from the chosen directory
wallpaper=$(find $wallpaper_dir -type f | shuf -n 1)

# Set the wallpaper and theme using wal and feh
wal -i $wallpaper
feh --bg-scale $wallpaper

