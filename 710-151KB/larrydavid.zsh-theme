
# Source the Pywal colors
. "${HOME}/.cache/wal/colors.sh"

# Define hardcoded colors for username and hostname
r_color="%F{196}"  # Red
b_color="%F{33}"   # Blue
y_color="%F{226}"  # Yellow
g_color="%F{46}"   # Green
reset_color="%f"   # Reset color

# Define Pywal colors for the current working directory
pw_color1="%F{$color1}"
pw_color2="%F{$color2}"
pw_color3="%F{$color3}"
pw_color4="%F{$color4}"

# Function to colorize a string with alternating colors
colorize_alternate() {
    local str="$1"
    shift
    local -a colors=("$@")
    # Expand prompt sequences
    str="${(%)str}"
    local result=""
    local len=${#colors[@]}
    if (( len == 0 )); then
        echo -n "$str"
        return
    fi
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
FMT_UNSTAGED="%{$reset_color%} %{$y_color%}●"   # Unstaged changes
FMT_STAGED="%{$reset_color%} %{$g_color%}✚"     # Staged changes
FMT_UNTRACKED="%{$reset_color%} %{$r_color%}●"  # Untracked files
FMT_CLEAN="%{$reset_color%}"                    # Clean repository
FMT_AHEAD="%{$b_color%}↑%{$reset_color%}"       # Ahead of remote
FMT_BEHIND="%{$b_color%}↓%{$reset_color%}"      # Behind remote

# VCS info settings
autoload -Uz vcs_info   # Load vcs_info module
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr    "${FMT_UNSTAGED}"
zstyle ':vcs_info:*' stagedstr      "${FMT_STAGED}"
zstyle ':vcs_info:*' formats        "on %{$b_color%} %b%a%m%u%c%{$reset_color%}"
zstyle ':vcs_info:*' actionformats  "on %{$b_color%} %b%a%m%u%c%{$reset_color%} (%{$g_color%}%a%{$reset_color%})"
zstyle ':vcs_info:*' nvcsformats    ""
zstyle ':vcs_info:*' hooks git-untracked git-aheadbehind

# Define the untracked files hook
+vi-git-untracked() {
    if [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
        # Append untracked files indicator
        hook_com[untracked]+="${FMT_UNTRACKED}"
    fi
}

# Define the ahead/behind hook
+vi-git-aheadbehind() {
    local ahead behind
    ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
    behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo 0)

    if [[ $ahead -gt 0 ]]; then
        hook_com[aheadbehind]+="${FMT_AHEAD}$ahead"
    fi
    if [[ $behind -gt 0 ]]; then
        hook_com[aheadbehind]+="${FMT_BEHIND}$behind"
    fi
}

# Function to update vcs_info and print the first line of the prompt
my_precmd() {
    vcs_info  # Update VCS information
    # Colorize username@hostname with hardcoded colors
    local user_host="$(colorize_alternate "%n@%m" "$r_color" "$b_color" "$y_color" "$g_color")"
    # Colorize current working directory with Pywal colors
    local cwd="$(colorize_alternate "" "$pw_color1" "$pw_color2" "$pw_color3" "$pw_color4")"
    # Now print the first line of the prompt
    print -P "\n${user_host} ${cwd} ${vcs_info_msg_0_}"
}

# Add the precmd hook
add-zsh-hook precmd my_precmd

# Define the second line as the actual prompt
PROMPT='  󱞪%f '

# Options
setopt PROMPT_SUBST
