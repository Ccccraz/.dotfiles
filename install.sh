#!/usr/bin/env bash
# Bootstrap these dotfiles on macOS or Linux with mise.
#
#   curl -fsSL https://raw.githubusercontent.com/Ccccraz/.dotfiles/main/install.sh | bash -s -- --preset full
#
# Options:
#   --preset full|minimal   full: dev machine (macOS/Linux); minimal: basic Linux box with zsh
#   --dry-run               preview what mise bootstrap would change
set -euo pipefail

REPO="https://github.com/Ccccraz/.dotfiles.git"
DOTFILES="$HOME/.dotfiles"
MIN_MISE="2026.10.15"

usage() {
    echo "usage: install.sh --preset full|minimal [--dry-run]"
}

version_ge() {
    [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]
}

# Everything runs inside main so `curl | bash` reads the whole script before any
# command can consume stdin.
main() {
    local preset="" dry_run=""
    while [ $# -gt 0 ]; do
        case "$1" in
            --preset) preset="${2:-}"; shift 2 ;;
            --dry-run) dry_run="--dry-run"; shift ;;
            -h|--help) usage; return 0 ;;
            *) echo "unknown argument: $1" >&2; usage >&2; return 1 ;;
        esac
    done
    case "$preset" in
        full|minimal) ;;
        *) echo "--preset full|minimal is required" >&2; return 1 ;;
    esac
    if [ "$preset" = minimal ] && [ "$(uname -s)" != Linux ]; then
        echo "the minimal preset is Linux only" >&2
        return 1
    fi

    export PATH="$HOME/.local/bin:$PATH"
    if ! command -v mise >/dev/null; then
        curl -fsSL https://mise.run | sh
    fi
    local version
    version="$(mise --version | awk '{print $1}')"
    if ! version_ge "$version" "$MIN_MISE"; then
        echo "mise $version is older than $MIN_MISE; updating"
        mise self-update -y
    fi

    # mise links ~/.config/mise to $DOTFILES/mise; the path must be free.
    local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/mise"
    if [ -e "$config_dir" ] && [ ! -L "$config_dir" ]; then
        local backup
        backup="$config_dir.bak.$(date +%Y%m%d%H%M%S)"
        echo "moving $config_dir to $backup"
        [ -n "$dry_run" ] || mv "$config_dir" "$backup"
    fi

    local confirm="--yes"
    [ -z "$dry_run" ] || confirm=""
    # On macOS, the aerospace cask comes from a third-party tap whose Ruby
    # definition mise needs Ruby >= 3 to read (keep in sync with mise/config.full.toml).
    if [ "$(uname -s)" = Darwin ]; then
        mise install ruby@4.0.9
        PATH="$(mise where ruby@4.0.9)/bin:$PATH"
    fi
    # shellcheck disable=SC2086
    mise -E "$preset" bootstrap \
        --from "$REPO" --from-dir "$DOTFILES" --config-dir mise \
        --save-env $confirm $dry_run
}

main "$@"
