#!/bin/bash

echo "Your skhdrc key bindings:"
echo ""

cat /Users/aidan/.skhdrc | grep -v '^#' | grep -v '^\s*$' | awk -F '[:=]' '{ printf "\033[33m%-20s\033[0m => \033[32m%s\033[0m\n", $1, $2 }'

