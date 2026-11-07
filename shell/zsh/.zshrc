# ~/.zshrc for the minimal preset (also usable on macOS).

[[ -d /opt/homebrew/bin ]] && export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
command -v mise >/dev/null && eval "$(mise activate zsh)"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history hist_ignore_dups
bindkey -v

autoload -Uz compinit && compinit

export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
command -v carapace >/dev/null && source <(carapace _carapace zsh)
command -v starship >/dev/null && eval "$(starship init zsh)"

# Debian/Ubuntu paths; syntax highlighting must be sourced last.
for plugin in \
    /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
    [[ -r $plugin ]] && source "$plugin"
done
unset plugin
