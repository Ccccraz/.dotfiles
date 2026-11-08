# config.nu: loaded after env.nu. See https://www.nushell.sh/book/configuration.html
# starship, carapace, and zoxide are loaded from the vendor autoload dir (see env.nu).

$env.config.show_banner = false
$env.config.buffer_editor = "code"

# Update mise, the tools it manages (to the newest release),
# the [bootstrap.packages], Homebrew, and uv tools.
def update [] {
    if $nu.os-info.name == "windows" {
        ^winget upgrade --id jdx.mise --exact --silent
    } else {
        ^mise self-update --yes
    }
    ^mise upgrade --yes
    ^mise bootstrap packages upgrade --yes
    if (which brew | is-not-empty) {
        ^brew update
        ^brew upgrade
        ^brew cleanup
    }
    if (which uv | is-not-empty) {
        ^uv tool upgrade --all
    }
}

# Remove package caches and unused versions left by mise, the system
# package managers, and language package managers.
def clean [] {
    ^mise prune --yes
    ^mise cache clear
    if (which brew | is-not-empty) {
        ^brew autoremove
        ^brew cleanup --prune=all --scrub
    }
    if (which apt-get | is-not-empty) {
        ^sudo apt-get autoremove --purge -y
        ^sudo apt-get clean
    }
    if (which scoop | is-not-empty) { ^scoop cleanup --all --cache }
    if (which uv | is-not-empty) { ^uv cache clean }
    if (which npm | is-not-empty) { ^npm cache clean --force }
    if (which pnpm | is-not-empty) { ^pnpm store prune }
    if (which bun | is-not-empty) { ^bun pm cache rm }
    if (which pixi | is-not-empty) { ^pixi clean cache --yes }
}
