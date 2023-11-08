export EDITOR="nvim"
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/bin:$PATH"
export PATH=$PATH:$(go env GOPATH)/bin
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export PATH="/opt/homebrew/bin:$PATH"


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="maza-theme" 
 ZSH_THEME="cloud" 
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
 ZSH_THEME_RANDOM_CANDIDATES=( "gozilla" "lambda-gitster" "robbyrussell" "cloud" "suvash" "apple" "agnoster" "crunch" "fletcherm" "mgutz" "minimal" "norm" "pygmalion" "re5et" "refined" "superjarin" )
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-iterm-touchbar)

source $ZSH/oh-my-zsh.sh
alias c='clear'
alias i='brew install'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
eval $(thefuck --alias)


#------------------------------------------------------------------------------------#-----------------------#----------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------[CUSTOM ALIAS/FUNCTION]-----------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------#-----------------------#----------------------------------------------------------------------------------------

# General
alias q='exit'
alias ..="cd .."
alias gcm='git commit -m "$(gum input)" -m "$(gum write)"'


# Navigation
alias cdc='cd && c'

# Editing
alias vim='nvim'
alias vi='nvim'


# Configuration files
alias tmconf='vi ~/.tmux.conf'
alias yconf='vi ~/.yabairc'
alias skconf="vi ~/.skhdrc"
alias zshconf='vi ~/.zshrc'
alias zshconf!='source ~/.zshrc'


# Scripting yabai and skhd
alias ysa="sudo yabai --load-sa"


# Task management
alias tbd='tb -d'
alias nvconf="cd ${HOME}/.config/nvim/lua/custom/ && vim"


# Applications
alias py='python3'
alias code='codium'


# Scripts and utilities
alias idea="eureka"
alias aliasman='alias_manager'
alias myalias='clear; echo -e "\033[1;36mAlias Manager\033[0m"; echo ""; grep "^alias " ~/.zshrc | awk -F "[ =\047]" '"'"'{printf "\033[1;33m%-15s\033[0m %s\n", $2, $4}'"'"'; echo ""; read -n 1 -s -r -p "Press any key to continue..."; clear'
alias pipes='pipes.sh'


# IP addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias myip="ifconfig en0 | grep inet | grep -v inet6 | cut -d ' ' -f2"

# Desktop icons
alias hideicons="defaults write com.apple.finder CreateDesktop false && killall Finder"
alias showicons="defaults write com.apple.finder CreateDesktop true && killall Finder"

# If random theme 
alias whichtheme="echo $RANDOM_THEME"

# Tmux
alias tks='tmux kill-server'

# Applications
alias web='open -a "Safari"'
alias spotify='open -a "Spotify"'
alias photos='open -a "Photos"'
alias sms='open -a "Messages"'
alias yt='yt() { open -a "Safari" "https://www.youtube.com/results?search_query=$*"; }; yt'
alias launch='lapp() { osascript -e "tell application \"$1\" to activate"; }; lapp'
alias chatgpt='oc() { open -a "Safari" "https://chat.openai.com"; }; oc'


# Terminal utilities
alias calc='bc -l'
alias weather='curl wttr.in'


# Generates a qr code from a given input
alias qr='qrcode() { qrencode -o - -s 10 -t UTF8 "$1" | less -RS; }; qrcode'
alias pbc='pbcopy'


# File management
alias trash='mv -t ~/.Trash'
alias emptytrash='rm -rf ~/.Trash/*'


# System commands
alias update='brew update && brew upgrade'
alias tmpdir='td() { dir=$(mktemp -d); echo "Created temporary directory $dir"; cd "$dir"; trap "echo Removing temporary directory: $dir; rm -r \"$dir\"" EXIT; }; td'
alias del='rm -rf'


# Network util
alias wifiscan='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport scan'


# fuckit
alias fuckit='m shutdown --force'


# open github
alias github='open https://github.com/spmfte'
alias pycopyall='for file in *.py; do echo "$file"; echo "----------------"; cat "$file"; echo; echo; done | pbcopy'


# SSh
alias {DEVICENAME}-on="wakeonlan 0:0:0:0:0"
alias {DEVICENAME}-connect="ssh user@host"

