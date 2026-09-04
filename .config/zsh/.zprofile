# ~/.config/zsh/.zprofile

# Homebrew is normally added by macOS path_helper; standard prefixes also cover
# minimal login environments. Only evaluate shellenv when it succeeds.
brew_command=""
if (( $+commands[brew] )); then
  brew_command=${commands[brew]}
elif [[ -x /opt/homebrew/bin/brew ]]; then
  brew_command=/opt/homebrew/bin/brew
elif [[ -x /usr/local/bin/brew ]]; then
  brew_command=/usr/local/bin/brew
fi
if [[ -n $brew_command ]]; then
  brew_shellenv="$("$brew_command" shellenv zsh)" && eval "$brew_shellenv"
fi
unset brew_command brew_shellenv
export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/homebrew/Brewfile"

# PATH: keep unique, user tool dirs ahead of system paths
typeset -U path
path=(
  "$HOME/.pixi/bin"
  "$HOME/.cargo/bin"
  "$HOME/.local/bin"
  $path
)

# XDG homes for tools that only honor an environment variable
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export MPLCONFIGDIR="$XDG_CONFIG_HOME/matplotlib"
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_repl_history"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export COOKIECUTTER_CONFIG="$XDG_CONFIG_HOME/cookiecutter/config.yaml"
