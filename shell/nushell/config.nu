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
