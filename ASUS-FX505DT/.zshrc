export ZSH="$HOME/.oh-my-zsh"
export PATH="$PATH:/home/aidan/scripts/UI"
export PATH="$PATH:/snap/bin"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh


cat /home/aidan/.cache/wal/sequences
source /home/aidan/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/aidan/.alias

aa() {
    /home/aidan/scripts/sysutil/add-alias.sh "$@"
    source /home/aidan/.alias
    python3 /home/aidan/scripts/sysutil/python/./alias-sort.py 
}

chvb() {
    /home/aidan/scripts/UI/wallpaper.sh "$@"
}
eval $(thefuck --alias)

# Following line was automatically added by arttime installer
export MANPATH=/home/aidan/.local/share/man:$MANPATH

# Following line was automatically added by arttime installer
export PATH=/home/aidan/.local/bin:$PATH

export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:${XDG_DATA_DIRS}"
export XDG_DATA_DIRS="/home/aidan/.local/share/flatpak/exports/share:${XDG_DATA_DIRS}"



fpath=(~/.zsh/completion $fpath)
autoload -Uz _chvb
compdef _chvb chvb

eval "$(zoxide init zsh)"
source /home/aidan/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
