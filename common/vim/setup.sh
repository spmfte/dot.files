#!/bin/bash

# Check for Git, Python, and npm
command -v git >/dev/null 2>&1 || { echo >&2 "Git is required but not installed. Aborting."; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo >&2 "Python 3 is required but not installed. Aborting."; exit 1; }
command -v npm >/dev/null 2>&1 || { echo >&2 "npm is required but not installed. Aborting."; exit 1; }

# Install Vim with Python3 support (adjust for your preferred package manager)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update && sudo apt-get install vim-gtk3 -y
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install vim --with-python3
fi

# Set up Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Copy the .vimrc file to the user's home directory
cp .vimrc ~/

# Install plugins via Vundle
vim +PluginInstall +qall

# Compile coc.nvim
cd ~/.vim/bundle/coc.nvim
npm install
npm run build

echo "Vim setup completed successfully."
