# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export EDITOR="nvim"
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/bin:$PATH"
export PATH=$PATH:$(go env GOPATH)/bin
export MANPAGER="sh -c 'col -bx | bat -l man -p'"


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="maza-theme" 
 ZSH_THEME="lambda-gitster" 
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
 ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "cloud" "suvash" "apple" "agnoster" "crunch" "fletcherm" "mgutz" "minimal" "norm" "pygmalion" "re5et" "refined" "superjarin" "" )
# "daveeverwer" "dpoggi" "dstufft" "half-life" "obraun" "pi" 'lambda-gitseter'

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-iterm-touchbar)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias c='clear'
alias C='clear && neofetch | lolcat -a -d 1 -s 100'
alias update='brew update && brew upgrade && brew cleanup | lolcat -a -d 1 -s 100'
alias i='brew install'
alias tbm='tb -t @Mac'
alias conf='nvim ~/.zshrc'
alias conf!='source ~/.zshrc'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
eval $(thefuck --alias)
#>>> conda initialize >>>
##!! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/Users/aidan/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/Users/aidan/opt/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "/Users/aidan/opt/anaconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/aidan/opt/anaconda3/bin:$PATH"
#     fi
# # fi
# unset __conda_setup
# # <<< conda initialize <<<

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias ls='command lsd --color=auto'
export PATH="$HOME/.local/bin:$PATH"
# Man page colors - Blue, Yellow, Red, Green theme
export LESS_TERMCAP_mb=$(printf '\e[1;34m')       # begin blinking - Blue
export LESS_TERMCAP_md=$(printf '\e[1;33m')       # begin bold - Yellow
export LESS_TERMCAP_me=$(printf '\e[0m')          # end mode
export LESS_TERMCAP_se=$(printf '\e[0m')          # end standout-mode
export LESS_TERMCAP_so=$(printf '\e[1;41;37m')    # begin standout-mode (info box) - White text on Red background
export LESS_TERMCAP_ue=$(printf '\e[0m')          # end underline
export LESS_TERMCAP_us=$(printf '\e[1;32m')       # begin underline - Green

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# General
alias q='exit'
alias ..="cd .."

# Navigation
alias pyproj='cd /Users/aidan/coding/py'
alias cdc='cd && c'

# Editing
alias vim='nvim'
alias vi='nvim'

# Configuration files
alias tmconf='vim ~/.tmux/.tmux.conf'
alias yconf='vim ~/.yabairc'
alias skconf="vi ~/.skhdrc"
alias mini='vim ~/zshmini/.zshrc'
alias mini!='source ~/zshmini/.zshrc'

# Restart services
alias yconf!="brew services restart koekeishiya/formulae/yabai"
alias skconf!="brew services restart skhd"

# Task management
alias tbd='tb -d'
alias csit='tb -t @CSIT'
alias tfin='tb -t @FINAL-CSIT'
alias nvconf='cd /Users/aidan/.config/nvim/lua/custom/ && vim'
# Applications
alias py='python3'
alias code='codium'
alias safari='rifle /Applications/Safari.app'

# Scripts and utilities
alias idea="eureka"
alias aliasman='alias_manager'
alias lights='~/bin/visualizer'
alias bonsai='echo -n "Enter message: " && vared -p "" -c message && cbonsai -S -m "$message"'
alias myalias='clear; echo -e "\033[1;36mAlias Manager\033[0m"; echo ""; grep "^alias " ~/.zshrc | awk -F "[ =\047]" '"'"'{printf "\033[1;33m%-15s\033[0m %s\n", $2, $4}'"'"'; echo ""; read -n 1 -s -r -p "Press any key to continue..."; clear'
alias bonclock='while true; do clear && cbonsai -S -m "$(date '+%H:%M:%S')"; sleep 1; done'
alias note='cd ~/bin && ./notes.sh && cd ~'
alias jot='cd ~/proj/shells/JotTerm && ./jotterm.sh && cd ~'
alias trec='terminalizer'
alias sherlock='cd ~/sherlock && python3 sherlock'
alias pipes='pipes.sh'

# IP addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias myip="ifconfig en0 | grep inet | grep -v inet6 | cut -d ' ' -f2"

# Desktop icons
alias hideicons="defaults write com.apple.finder CreateDesktop false && killall Finder"
alias showicons="defaults write com.apple.finder CreateDesktop true && killall Finder"

# Fun and humor
alias whichtheme="echo $RANDOM_THEME"
alias joke='curl -s https://official-joke-api.appspot.com/jokes/programming/random | jq ".[0] | .setup, .punchline"'


# Tmux
alias tks='tmux kill-server'

# Applications
# # alias mail='open -a "Mail"'
# alias editor='open -a "Visual Studio Code"'
alias browser='open -a "Safari"'
alias itunes='open -a "Spotify"'
alias photos='open -a "Photos"'
alias imessage='open -a "Messages"'
alias facetime='open -a "FaceTime"'
alias calendar='open -a "Calendar"'
alias youtube='yt() { open -a "Safari" "https://www.youtube.com/results?search_query=$*"; }; yt'
alias launch='lapp() { osascript -e "tell application \"$1\" to activate"; }; lapp'


# Terminal utilities
alias calc='bc -l'
alias weather='curl wttr.in'
alias qr='qrcode() { qrencode -o - -s 10 -t UTF8 "$1" | less -RS; }; qrcode'

# File management
alias trash='mv -t ~/.Trash'
alias emptytrash='rm -rf ~/.Trash/*'

# System commands
alias update='brew update && brew upgrade'
alias cleanup='brew cleanup'
alias tmpdir='td() { dir=$(mktemp -d); echo "Created temporary directory $dir"; cd "$dir"; trap "echo Removing temporary directory: $dir; rm -r \"$dir\"" EXIT; }; td'
alias del='rm -rf'
# Kali Linux
alias wifiscan='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport scan'

