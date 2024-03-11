#!/bin/bash

# Check if 'bat' command is available
if ! command -v bat &> /dev/null; then
    echo "Error: 'bat' command not found. Please install 'bat' before running this script."
    exit 1
fi

# Function to run 'bat' command on files
run_bat_on_file() {
    local file="$1"
    bat --no-pager "$file"
}

# Function to traverse directories recursively
traverse_directories() {
    local dir="$1"
    for file in "$dir"/*; do
        if [ -f "$file" ]; then
            run_bat_on_file "$file"
        elif [ -d "$file" ]; then
            traverse_directories "$file"
        fi
    done
}

# Start traversing from the current directory
traverse_directories "$(pwd)"
