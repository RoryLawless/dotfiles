#!/bin/sh
# ~/.config/dotfiles/windows-sync.sh
#
# Copy tracked config files to the locations their Windows programs read.
# Run automatically by the post-merge and post-checkout hooks once
# core.hooksPath points at ~/.config/dotfiles/hooks, and by hand after a
# local edit:  sh ~/.config/dotfiles/windows-sync.sh
#
# Copies, never moves. Moving a file out of the work tree makes git see it
# as deleted, and the next pull that touches that file is refused.
# Does nothing on macOS.

case $(uname -s) in
  MINGW*|MSYS*|CYGWIN*) ;;
  *) exit 0 ;;
esac

set -eu

home=$HOME                          # Git Bash sets HOME to %USERPROFILE%, the work tree
appdata=$(cygpath -u "$APPDATA")    # %APPDATA% as a /c/Users/... path

place() {  # place <path relative to home> <destination>
  src="$home/$1"
  dst=$2
  [ -f "$src" ] || return 0                              # not in this checkout
  if [ -f "$dst" ] && cmp -s "$src" "$dst"; then return 0; fi
  if [ -f "$dst" ] && [ "$dst" -nt "$src" ]; then
    printf 'dotfiles: %s is newer than the repo copy; left alone. Copy it back into the repo or delete it.\n' "$dst" >&2
    return 0
  fi
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  printf 'dotfiles: updated %s\n' "$dst"
}

# Files whose Windows location differs from the checked-out path.
# Git config, attributes and ignore are read from ~/.config/git as-is,
# and .Rprofile is read from ~ once HOME is set (see README).
place .config/air/air.toml    "$appdata/air/air.toml"
place .config/jarl/jarl.toml  "$appdata/jarl/jarl.toml"
place "Library/Application Support/Positron/User/settings.json" \
      "$appdata/Positron/User/settings.json"

# If HOME cannot be set system-wide, R reads its profile from Documents instead.
# Find the exact folder with:  Rscript -e 'cat(path.expand("~"))'
# place .Rprofile "$(cygpath -u "$USERPROFILE")/Documents/.Rprofile"
