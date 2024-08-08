#!/bin/sh
set -Cefu

usage() {
    printf '%s\n' 'gradient.sh [bg | fg]'
    exit 1
} >&2

set_sh() {
    brace_e=false

    # shellcheck disable=SC2059
    sprint() {
        printf "$@"
    }

    sprintln() {
        printf '\n'
    }

    if [ -n "${BASH_VERSION+x}" ] || [ -n "${ZSH_VERSION+x}" ]; then
        brace_e=true
    elif [ -n "${KSH_VERSION+x}" ]; then
        case "$KSH_VERSION" in
        *'AJM'*) # ksh93
            brace_e=true
            ;;
        *'MIRBSD'*|*'PD'*) # mksh, pdksh, oksh
            sprint() {
                print -nr -- "$@"
            }

            sprintln() {
                print -r --
            }
            ;;
        esac
    fi
}

color_gradient_bg() {
    for i in {0..255}; do
        sprint "${esc}[48;5;${i}m  "
    done
    sprintln "${esc}[0m"
}

color_gradient_fg() {
    for i in {0..255}; do
        sprint "${esc}[38;5;${i}m\u2588" # Full block character
    done
    sprintln "${esc}[0m"
}

main() {
    [ $# -ne 1 ] && usage

    # shellcheck disable=SC3003
    esc=$'\033' && [ ${#esc} = 1 ] || esc=$(printf '\033')

    set_sh

    case "${1:-}" in
    bg)
        color_gradient_bg ;;
    fg)
        color_gradient_fg ;;
    *)
        usage ;;
    esac
}

main ${1+"$@"}
