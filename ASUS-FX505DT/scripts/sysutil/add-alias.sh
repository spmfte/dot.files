#!/bin/zsh

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

bold=$(tput bold)
normal=$(tput sgr0)
# Check for correct number of arguments
if [ "$#" -ne 2 ]; then
  echo -e "${RED}Usage: add-alias <alias_name> <command>${RESET}"
  exit 1
fi

# Variables
alias_name=$1
alias_command=$2
alias_file="$HOME/.alias"

# Check if alias already exists
if grep -q "alias $alias_name=" $alias_file; then
  echo -e "${YELLOW}Alias \"$alias_name\" already exists. Do you want to overwrite it? (y/n)${RESET}"
  read -q overwrite
  echo # move to a new line
  if [[ $overwrite != 'y' ]]; then
    echo -e "${GREEN}Exiting without adding alias.${RESET}"
    exit 0
  else
    sed -i "/alias $alias_name=/d" $alias_file
  fi
fi

# Add the alias
echo "alias $alias_name=\"$alias_command\"" >> $alias_file
echo -e "${GREEN}Alias \"$alias_name\" added successfully.${RESET}"
