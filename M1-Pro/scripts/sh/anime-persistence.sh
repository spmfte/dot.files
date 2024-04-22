#!/bin/bash

# Define the path to the ani-cli and the log file
ani_cli="/opt/homebrew/bin/ani-cli"
log_file="$HOME/anime_watch_log.txt"

# Function to log or update viewing in the log file
log_or_update_viewing() {
    local anime="$1"
    local episode="$2"
    local temp_file="$log_file.tmp"
    
    if grep -q "^$anime:" "$log_file"; then
        # Update existing entry for the anime
        awk -F ": " -v anime="$anime" -v episode="$episode" '{
            if ($1 == anime) 
                print anime ": Episode " episode
            else 
                print $0
        }' "$log_file" > "$temp_file" && mv "$temp_file" "$log_file"
    else
        # Add new entry to the log
        echo "$anime: Episode $episode" >> "$log_file"
    fi

    echo "Logged $anime: Episode $episode to $log_file"
}

# Function to continue watching the last anime
continue_watching() {
    if [ -s "$log_file" ]; then
        last_entry=$(tail -n 1 "$log_file")
        anime_name=$(echo "$last_entry" | cut -d':' -f1)
        episode_number=$(echo "$last_entry" | grep -oE 'Episode [0-9]+' | grep -oE '[0-9]+')
        next_episode=$((episode_number + 1))

        echo "Last watched: $anime_name Episode $episode_number"
        read -p "Do you want to continue watching this? (y/n): " answer
        answer=${answer:-y}  # Default to 'y' if no input is given

        if [[ "$answer" == "y" ]]; then
            echo "Continuing $anime_name from Episode $next_episode with dubbed version..."
            log_or_update_viewing "$anime_name" "$next_episode"
            $ani_cli -e $next_episode --dub "$anime_name"
        else
            ask_for_new_anime
        fi
    else
        echo "No history found in $log_file. Starting a new anime session."
        ask_for_new_anime
    fi
}

# Function to ask for a new anime
ask_for_new_anime() {
    echo "Enter anime name:"
    read new_anime
    echo "Enter starting episode number (default is 1):"
    read starting_episode
    starting_episode=${starting_episode:-1}
    log_or_update_viewing "$new_anime" "$starting_episode"
    $ani_cli -e "$starting_episode" --dub "$new_anime"
}

# Main logic to check if log file exists and is not empty
continue_watching
