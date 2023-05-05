#!/bin/bash

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
RESET="\033[0m"

notes_dir="$HOME/notes"
mkdir -p "$notes_dir"

# Function to list notes
list_notes() {
  echo -e "${CYAN}Your notes:${RESET}"
  ls -1 "$notes_dir"
}

if [ $# -eq 0 ]; then
  # Quickly create a note without any arguments
  timestamp=$(date +"%Y-%m-%d_%H-%M")
  note_file="$notes_dir/${timestamp}.txt"

  echo -e "${YELLOW}Enter your note (Press Enter followed by Ctrl+D to save):${RESET}"
  cat > "$note_file"
  echo -e "${GREEN}Note saved with timestamp: $timestamp in $notes_dir${RESET}"
  exit 0
fi

# Parse command line arguments
while getopts ":c::d:e:l" opt; do
  case $opt in
    c)
      note_title="${OPTARG}"
      timestamp=$(date +"%Y-%m-%d_%H-%M")

      if [[ -n "$note_title" ]]; then
        note_file="$notes_dir/${note_title}.txt"
      else
        note_file="$notes_dir/${timestamp}.txt"
      fi

      echo -e "${YELLOW}Enter your note (Press Enter followed by Ctrl+D to save):${RESET}"
      cat > "$note_file"

      if [[ -n "$note_title" ]]; then
        echo -e "${GREEN}Note saved as: $note_title in $notes_dir${RESET}"
      else
        echo -e "${GREEN}Note saved with timestamp: $timestamp in $notes_dir${RESET}"
      fi
      ;;
    d)
      delete_title="$OPTARG"
      delete_file="$notes_dir/${delete_title}.txt"
      if [[ -f "$delete_file" ]]; then
        rm "$delete_file"
        echo -e "${RED}Note deleted.${RESET}"
      else
        echo -e "${RED}Note not found.${RESET}"
      fi
      ;;
    e)
      edit_title="$OPTARG"
      edit_file="$notes_dir/${edit_title}.txt"
      if [[ -f "$edit_file" ]]; then
        echo -e "${YELLOW}Enter your updated note (Press Enter followed by Ctrl+D to save):${RESET}"
        cat > "$edit_file"
        echo -e "${GREEN}Note updated.${RESET}"
      else
        echo -e "${RED}Note not found.${RESET}"
      fi
      ;;
    l)
      list_notes
      ;;
    \?)
      echo -e "${RED}Invalid option: -$OPTARG${RESET}" >&2
      ;;
  esac
done

