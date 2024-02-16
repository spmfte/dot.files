#!/bin/bash

# Check if an argument was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {language}/query+string or {core-util}-{operation}"
    exit 1
fi

# Perform the curl request to cht.sh with the provided argument
curl "cht.sh/$1"

