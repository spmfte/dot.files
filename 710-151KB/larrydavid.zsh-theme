# Source the Pywal colors
. "${HOME}/.cache/wal/colors.sh"

# Define colors manually
r_color="%F{196}"  # Red
b_color="%F{33}"   # Blue
y_color="%F{226}"  # Yellow
g_color="%F{46}"   # Green
reset_color="%f"   # Reset color

# Function to colorize a string with alternating colors
colorize_alternate() {
    local str="$1"
    # Expand prompt sequences
    str="${(%)str}"
    local -a colors=("$r_color" "$b_color" "$y_color" "$g_color")
    local result=""
    local len=${#colors[@]}
    local c color
    local -a chars
    # Split the string into an array of characters
    chars=("${(s::)str}")
    for ((i = 1; i <= ${#chars[@]}; i++)); do
        c="${chars[i]}"
        color="${colors[$(( (i - 1) % len + 1 ))]}"
        result+="%{${color}%}${c}"
    done
    result+="%{$reset_color%}"
    echo -n "$result"
}

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

# Function to print the first line of the prompt
my_precmd() {
    vcs_info  # Update VCS information
    print -P "$(colorize_alternate "%n@%m") $(colorize_alternate "%") ${vcs_info_msg_0_}"
}

# Add the precmd hook
add-zsh-hook precmd my_precmd

# Define the second line as the actual prompt
PROMPT=' 󱞩%f '

# Options
setopt PROMPT_SUBST
