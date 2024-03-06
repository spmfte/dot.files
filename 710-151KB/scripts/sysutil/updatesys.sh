#!/bin/zsh

# Check if the script is run as root
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root or using sudo"
    exit 1
fi

# Temporary file for storing command outputs
temp_file=$(mktemp)

# Function to run pacman update
run_pacup() {
    sudo pacman -Syu &> "$temp_file"
}

# Function to run yay update
run_yayup() {
    yay -Syu &> "$temp_file"
}

# Function to run snap update
run_snapup() {
    sudo snap refresh &> "$temp_file"
}

# Function to display loading animation
loading_animation() {
    local message=$1
    local colors=("\e[31m" "\e[32m" "\e[34m") # Red, Green, Blue
    local dots=("." ".." "...")
    local color_index=0

    for i in {1..10}; do # Adjust the loop for longer animation
        echo -ne "\033[2K\r" # Clear the line
        echo -ne "${colors[$color_index]}$message${dots[$((i % 3))]}"
        sleep 1
        ((color_index = (color_index + 1) % 3))
    done

    echo -ne "\e[0m\r" # Reset color and clear line
}

# Function to display the output and parse it
display_output() {
    local message=$1
    echo "$message"
    cat "$temp_file"
    echo ""
}

# Prompt for sudo password upfront to avoid being overwritten
echo "This operation requires sudo"
sudo -v

# Keep sudo session alive
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# Run and display pacman updates
run_pacup &
loading_animation "Updating pacman packages"
wait
display_output "Pacman update output:"

# Run and display yay updates
run_yayup &
loading_animation "Updating yay packages"
wait
display_output "Yay update output:"

# Run and display snap updates
run_snapup &
loading_animation "Updating snap packages"
wait
display_output "Snap update output:"

# Clean up
rm "$temp_file"

