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
