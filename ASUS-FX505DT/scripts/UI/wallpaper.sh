#!/bin/zsh

# Check if at least one argument (the wallpaper file name) is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <wallpaper_file>"
    exit 1
fi

wallpaper_file="$1"
wallpaper_dir="$HOME/wallpapers/"

# Function to set the correct file extension based on the file name
set_extension() {
    file_extension="${wallpaper_file##*.}"
    
    # If no extension found, try common image extensions
    if [ "$file_extension" = "$wallpaper_file" ]; then
        for ext in jpg jpeg png webp; do
            if [ -f "$wallpaper_dir$wallpaper_file.$ext" ]; then
                wallpaper_file="$wallpaper_file.$ext"
                return
            fi
        done
        echo "Unsupported file format for $wallpaper_file"
        exit 1
    fi
}

# Call the function to set the file extension
set_extension

feh --bg-scale "$wallpaper_dir$wallpaper_file"
wal -i "$wallpaper_dir$wallpaper_file"
