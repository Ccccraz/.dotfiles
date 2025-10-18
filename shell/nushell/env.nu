# env.nu
#
# Installed by:
# version = "0.104.1"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.
use std "path add"

path add "/Users/ccccr/.local/bin"
path add "/Users/ccccr/.volta/bin"

if $nu.os-info.name == "macos" {
    path add "/opt/homebrew/bin"
} else if $nu.os-info.name == "windows" {
} else {
    path add "/home/linuxbrew/.linuxbrew/bin/brew"
}

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

let cache_dir = if $nu.os-info.name == "windows" {
    $"($env.USERPROFILE)\\.cache\\carapace"
} else {
    $"($env.HOME)/.cache/carapace"
}

mkdir $cache_dir
carapace _carapace nushell | save --force $"($cache_dir)/init.nu"
