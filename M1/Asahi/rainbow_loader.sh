#!/bin/sh
set -Cefu

usage() {
    printf '%s\n' 'rainbow.sh [speed] [char]'
    printf '%s\n' '  speed - Animation speed in seconds (default: 0.1)'
    printf '%s\n' '  char  - Character to display (default: #)'
    exit 1
} >&2

# Default values
SPEED="${1:-0.1}"
CHAR="${2:-#}"

# ANSI escape codes
ESC=$'\033'

# Rainbow colors
RAINBOW_COLORS=(31 33 32 36 34 35)

# Function to print a line of rainbow colors
print_rainbow_line() {
    for COLOR in "${RAINBOW_COLORS[@]}"; do
        printf "${ESC}[38;5;${COLOR}m%s${ESC}[0m" "$CHAR"
    done
    printf "\n"
}

# Function to animate the rainbow
animate_rainbow() {
    while true; do
        for ((i = 0; i < ${#RAINBOW_COLORS[@]}; i++)); do
            print_rainbow_line
            sleep "$SPEED"
            clear
            # Rotate colors
            RAINBOW_COLORS=("${RAINBOW_COLORS[@]:1}" "${RAINBOW_COLORS[0]}")
        done
    done
}

# Main function
main() {
    animate_rainbow
}

main
