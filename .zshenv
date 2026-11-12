# ~/.zshenv
# The only zsh file left in $HOME. Everything else lives in $ZDOTDIR.

# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export PIXI_HOME="$XDG_CONFIG_HOME/pixi"
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"
