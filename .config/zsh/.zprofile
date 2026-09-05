# ~/.config/zsh/.zprofile

# Homebrew. macOS does not put Homebrew on PATH by itself, and only
# brew shellenv sets HOMEBREW_PREFIX and MANPATH. Guarded so a shell opened
# before Homebrew is installed still starts cleanly.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"   # Apple Silicon
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv zsh)"      # Intel
fi
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
export COOKIECUTTER_CONFIG="$XDG_CONFIG_HOME/cookiecutter/config.yaml"
