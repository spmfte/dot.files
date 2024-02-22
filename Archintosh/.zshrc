export PATH="$PATH:/sbin/yarn"
export PATH="/opt/lazar:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nvim
# ------------------------------------------
ZSH_THEME="awesomepanda"
# ----------
plugins=(git)
# ------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# ------------------------------------------
eval $(thefuck --alias)
eval "$(zoxide init zsh)"
# ------------------------------------------
source $ZSH/oh-my-zsh.sh
source $HOME/.alias
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
