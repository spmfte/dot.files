export MODULAR_HOME="$HOME/.modular"
export PATH="$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export PYTHON="/opt/homebrew/bin/python3"
export PATH="/opt/homebrew/bin:$PATH"
ZSH_THEME="robbyrussell"

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
