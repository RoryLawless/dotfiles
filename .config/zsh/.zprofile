# ~/.config/zsh/.zprofile

eval "$(brew shellenv zsh)"
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
