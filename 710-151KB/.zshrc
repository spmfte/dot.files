export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nvim
export VISUAL=nvim
PATH=/home/aidan/.local/bin:$PATH
export PATH=$PATH:/snap/bin
export NOTES_DIR="$notes"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting colored-man-pages)

source $ZSH/oh-my-zsh.sh

(cat ~/.cache/wal/colors.sh &>/dev/null) && source ~/.cache/wal/colors.sh

eval $(thefuck --alias)

source /home/aidan/.config/broot/launcher/bash/br

# Following line was automatically added by arttime installer
export PATH=/home/aidan/.local/bin:$PATH

wal -R

source $HOME/.alias
eval "$(zoxide init zsh)"
