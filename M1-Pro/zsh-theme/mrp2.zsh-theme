
setopt PROMPT_SUBST

autoload -U add-zsh-hook
autoload -Uz vcs_info

# Custom colors.
oxide_red="%F{#ed8796}"
oxide_orange="%F{#f5a97f}"
oxide_yellow="%F{#eed49f}"
oxide_blue="%F{#7dc4e4}"
oxide_indigo="%F{#8aadf4}"
oxide_violet="%F{#c6a0f6}"

# Reset color.
oxide_reset_color="%f"

# VCS styles using '' with different colors for staged and unstaged changes.
FMT_UNSTAGED="%{$oxide_reset_color%} %{$oxide_orange%}"
FMT_STAGED="%{$oxide_reset_color%} %{$oxide_blue%}"
FMT_ACTION="(%{$oxide_indigo%}%a%{$oxide_reset_color%})"
FMT_VCS_STATUS="%{$oxide_violet%} on %b%u%c%{$oxide_reset_color%}"

zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr    "${FMT_UNSTAGED}"
zstyle ':vcs_info:*' stagedstr      "${FMT_STAGED}"
zstyle ':vcs_info:*' actionformats  "${FMT_ACTION}"
zstyle ':vcs_info:*' formats        "${FMT_VCS_STATUS}"
zstyle ':vcs_info:*' nvcsformats    ""
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

# Hook for untracked files.
+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
            git status --porcelain | grep --max-count=1 '^??' &> /dev/null; then
        hook_com[unstaged]+="%{$oxide_reset_color%} %{$oxide_red%}"
    fi
}

# Pre-command execution for VCS info update.
add-zsh-hook precmd vcs_info

# Function to dynamically color path segments.
colorize_path() {
  local path="${1/#$HOME/~}" # Shorten home directory to '~'
  local -a path_segments=("${(@s:/:)path}")
  local colored_path=""
  local colors=($oxide_orange $oxide_yellow $oxide_blue $oxide_indigo $oxide_violet)
  local color_index=1

  for segment in $path_segments; do
    # Apply color and reset afterwards
    colored_path+="%{$colors[$color_index]%}$segment%{$oxide_reset_color%}/"
    # Cycle through colors array
    (( color_index = color_index % $#colors + 1 ))
  done

  # Print path with trailing slash removed
  echo "${colored_path%/}"
}


# Corrected Prompt with dynamic path coloring.
PROMPT='
${$(colorize_path %~)} ${vcs_info_msg_0_}
%(?.%{%F{white}%}.%{$oxide_red%})%(!.#.❯)%{$oxide_reset_color%} '

