#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 <duration in minutes> or --test for a 5-second timer"
    exit 1
}

# Check if --test argument is provided
if [ "$1" == "--test" ]; then
    duration=5
else
    # Check if duration is provided and is a number
    if [ "$#" -ne 1 ] || ! [[ $1 =~ ^[0-9]+$ ]]; then
        usage
    fi
    # Convert minutes to seconds
    duration=$(( $1 * 60 ))
fi

# Define the sound file path
SOUND_FILE="/home/aidan/sounds/mixkit-clear-announce-tones-2861.wav"

# Check if the sound file exists
if [ ! -f "$SOUND_FILE" ]; then
    echo "Error: Sound file not found at $SOUND_FILE"
    exit 1
fi

total_duration=$duration


# Log start time
echo "Timer started at $(date)" >> timer_log.txt

# Function to draw the progress bar
draw_progress_bar() {
    local progress=$(( ($1 * 100) / $2 ))
    local filled=$(( ($progress * 40) / 100 ))
    local empty=$(( 40 - filled ))
    printf "\r["
    printf "%0.s#" $(seq 1 $filled)
    printf "$%0.s-" $(seq 1 $empty)
    printf "$] %d%%" $progress
}

# Countdown loop with loading animation
start_time=$(date +%s)
while [ $duration -gt 0 ]; do
    current_time=$(date +%s)
    elapsed=$(( current_time - start_time ))
    remaining=$(( duration - elapsed ))

    draw_progress_bar $elapsed $total_duration

    sleep 0.1
    duration=$((duration - 1))
done
echo -e "\nTime's up!"

# Sound notification
aplay "$SOUND_FILE" > /dev/null 2>&1

# Visual notification
notify-send "Timer" "Time's up!"

# Log end time
echo "Timer ended at $(date)" >> timer_log.txt
