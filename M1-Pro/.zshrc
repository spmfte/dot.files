export MODULAR_HOME="$HOME/.modular"
export PATH="$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export PYTHON="/opt/homebrew/bin/python3"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/share/zsh/site-functions:$PATH"
export EDITOR=nvim
export FZF_DEFAULT_OPTS='--tmux center'
export PATH="Users/aidan/.local/lib/python3.11/site-packages:$PATH"
export PATH="/Users/aidan/.local/bin:$PATH"

export PS2=" "

ZSH_THEME="mrp"

plugins=(git)

source $ZSH/oh-my-zsh.sh
source $HOME/.alias
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
eval "$(zoxide init zsh)"

eval $(thefuck --alias)
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Tre command 
tre() { command tre "$@" -e && source "/tmp/tre_aliases_$USER" 2>/dev/null; }
source /tmp/tre_aliases_$USER

# Custom CAX cmd
cax() {
    cat "$1" | pbcopy
}

# calculate function
whats ()
{
    echo $(($1))
}
# walk function 
function lk {
    cd "$(walk "$@")"
}

bgtime() {
  # Trigger the start of a background task
  sketchybar --trigger bg_task_started

  # Run the given command
  "$@"
  exit_status=$?

  # When the command completes, trigger the finish event
  sketchybar --trigger bg_task_finished

  return $exit_status
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
 __conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
 if [ $? -eq 0 ]; then
     eval "$__conda_setup"
 else
     if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
         . "/opt/anaconda3/etc/profile.d/conda.sh"
     else
         export PATH="/opt/anaconda3/bin:$PATH"
     fi
 fi
 unset __conda_setup
# # <<< conda initialize <<<

# FZF Config

# Source .fzf.conf
if [ -f ~/.config/fzf/fzf.config ]; then
  source ~/.config/fzf/fzf.config
fi

export PATH="/opt/homebrew/opt/e2fsprogs/bin:$PATH"
export PATH="/opt/homebrew/opt/e2fsprogs/sbin:$PATH"

export MANPAGER='nvim +Man!'
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
# echo "Tasks for today:\n"
# glow $HOME/TODO.md
