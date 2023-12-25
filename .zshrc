autoload -Uz +X compinit && compinit

# Case insensitive tab completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# auto-fill the first viable candidate for tab completion
setopt menucomplete

bindkey -v

# Fix zsh bug where tab completion hangs on git commands
# https://superuser.com/a/459057
__git_files() {
    _wanted files expl 'local files' _files
}

# Only allow unique entries in path
typeset -U PATH

export PATH=$PATH:/opt/homebrew/bin

# shellcheck source=~/.fzf.zsh
[ -f ~/.fzf.zsh ] && source "~/.fzf.zsh"

unsetopt beep
