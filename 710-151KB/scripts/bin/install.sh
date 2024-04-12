#!/bin/bash

# Wrapper script for pacman that falls back to yay if a package is not found

# Run the original pacman command
sudo pacman "$@"

# Check if pacman failed to find the package
if [ $? -eq 1 ]; then
    # Extract the package name from the arguments
    # Assuming the command format is 'sudo pacman -S package'
    package=$(echo "$@" | awk '{print $NF}')

    # Try to install the package using yay
    echo "Pacman failed to find the package. Trying to install with yay..."
    yay -S "$package"
fi
