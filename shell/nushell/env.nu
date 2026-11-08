# env.nu: loaded before config.nu. See https://www.nushell.sh/book/configuration.html
use std/util "path add"

# `path add` prepends, so entries added later take precedence.
if $nu.os-info.name == "macos" {
    let multipass = "/Library/Application Support/com.canonical.multipass/bin"
    if ($multipass | path exists) { path add $multipass }
    path add /opt/homebrew/sbin
    path add /opt/homebrew/bin
}

# mise shims: every tool from [tools] in ~/.config/mise.
let mise_shims = if $nu.os-info.name == "windows" {
    $env.LOCALAPPDATA | path join mise shims
} else {
    $nu.home-dir | path join .local share mise shims
}
path add ($nu.home-dir | path join .local bin)
path add $mise_shims

$env.EDITOR = "nvim"
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

# Bitwarden SSH agent. Git's SSH commit signing (ssh-keygen -Y sign) only
# reads SSH_AUTH_SOCK, not IdentityAgent from ~/.ssh/config.
let bitwarden_sock = $nu.home-dir | path join .bitwarden-ssh-agent.sock
if ($bitwarden_sock | path exists) {
    $env.SSH_AUTH_SOCK = $bitwarden_sock
}

# Regenerate shell integrations into the vendor autoload dir, which Nushell
# sources after config.nu. A missing tool is skipped instead of failing.
let autoload = $nu.data-dir | path join vendor autoload
mkdir $autoload
if (which starship | is-not-empty) {
    starship init nu | save -f ($autoload | path join starship.nu)
}
if (which carapace | is-not-empty) {
    carapace _carapace nushell | save -f ($autoload | path join carapace.nu)
}
if (which zoxide | is-not-empty) {
    zoxide init nushell | save -f ($autoload | path join zoxide.nu)
}
