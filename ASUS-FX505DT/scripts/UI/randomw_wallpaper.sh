#!/bin/zsh

wallpaper_dir="$HOME/wallpapers/"
existing_script="$HOME/scripts/UI/wallpaper.sh"

# Select a random wallpaper
wallpaper_file=$(find "$wallpaper_dir" -type f | shuf -n 1)

# Extract just the file name
wallpaper_file=${wallpaper_file##*/}

# Call your existing wallpaper setting script
$existing_script "$wallpaper_file"
