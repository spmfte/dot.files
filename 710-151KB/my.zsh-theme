
# Define alternating colors: Red, Blue, Yellow, Green
r_color="%F{196}"  # Red
b_color="%F{33}"   # Blue
y_color="%F{226}"  # Yellow
g_color="%F{46}"   # Green
reset_color="%f"   # Reset color

# VCS style formats for Git
FMT_UNSTAGED="%{$reset_color%} %{$y_color%}●"
FMT_STAGED="%{$reset_color%} %{$g_color%}✚"
FMT_ACTION="(%{$g_color%}%a%{$reset_color%})"
FMT_VCS_STATUS="on %{$b_color%} %b%u%c%{$reset_color%}"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr    "${FMT_UNSTAGED}"
zstyle ':vcs_info:*' stagedstr      "${FMT_STAGED}"
zstyle ':vcs_info:*' actionformats  "${FMT_VCS_STATUS} ${FMT_ACTION}"
zstyle ':vcs_info:*' formats        "${FMT_VCS_STATUS}"
zstyle ':vcs_info:*' nvcsformats    ""

# Check for untracked files
+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
            git status --porcelain | grep --max-count=1 '^??' &> /dev/null; then
        hook_com[staged]+="%{$reset_color%} %{$r_color%}●"
    fi
}

# Executed before each prompt
add-zsh-hook precmd vcs_info

# Manually apply alternating colors for each element
PROMPT='%{$r_color%}%n%{$b_color%}@%m %{$y_color%}%~%{$reset_color%} ${vcs_info_msg_0_} %{$g_color%}❯%f '

# Options
setopt PROMPT_SUBST
