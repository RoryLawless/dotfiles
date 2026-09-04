#!/bin/zsh
# Bootstrap these dotfiles on a new Mac.
#
#   zsh -c "$(curl -fsSL https://raw.githubusercontent.com/RoryLawless/dotfiles/main/.config/dotfiles/install.sh)"
#
# Idempotent: safe to rerun. Existing files that would be overwritten by the
# checkout are moved to ~/.cfg-backup/ first.

set -euo pipefail

REPO="git@github.com:RoryLawless/dotfiles.git"
GIT_DIR="$HOME/.cfg"
config() { git --git-dir="$GIT_DIR" --work-tree="$HOME" "$@"; }

# 1. Command Line Tools (git lives here until Homebrew's git is installed)
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools; rerun this script when the installer finishes."
  xcode-select --install
  exit 1
fi

# 2. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# 3. Bare repo clone
if [[ ! -d $GIT_DIR ]]; then
  git clone --bare "$REPO" "$GIT_DIR"
fi
config config status.showUntrackedFiles no

# 4. Checkout, backing up anything it would clobber
if ! config checkout 2>/dev/null; then
  mkdir -p "$HOME/.cfg-backup"
  config checkout 2>&1 | grep -E '^\s+' | awk '{print $1}' | while read -r f; do
    mkdir -p "$HOME/.cfg-backup/$(dirname "$f")"
    mv "$HOME/$f" "$HOME/.cfg-backup/$f"
  done
  config checkout
  echo "Pre-existing files moved to ~/.cfg-backup/"
fi

# 5. Untracked, machine-specific files
cat > "$GIT_DIR/info/exclude" <<'EXCL'
.config/zsh/local.zsh
.config/git/config.local
.config/git/allowed_signers
.config/karabiner/automatic_backups/
.config/karabiner/assets/
.config/emacs/elpa/
EXCL

# 6. Packages
brew bundle install --file="$HOME/.config/homebrew/Brewfile"

# 7. Directories the shell config expects
mkdir -p "$HOME/.local/state/zsh" "$HOME/Library/Caches/zsh" "$HOME/.local/share/emacs/backups"

# 8. Templates for the untracked files, only if absent
[[ -f $HOME/.config/zsh/local.zsh ]] || cat > "$HOME/.config/zsh/local.zsh" <<'LOCAL'
# Machine-specific zsh settings. Not tracked. Sourced at the end of .zshrc.
LOCAL

[[ -f $HOME/.config/git/config.local ]] || cat > "$HOME/.config/git/config.local" <<'GITLOCAL'
[user]
    name = Rory Lawless
    email =
    signingkey = ssh-ed25519 ...

[gpg "ssh"]
    program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign
GITLOCAL

cat <<'DONE'

Done. Remaining manual steps:
  - Fill in ~/.config/git/config.local (email, signingkey) and create
    ~/.config/git/allowed_signers ("<email> <public key>" per line).
  - Enable the 1Password SSH agent and add the signing key.
  - Restore ~/.Renviron (API keys), ~/.daily-backup/ (borgmatic.yaml, borg-exclude)
    and ~/Library/LaunchAgents/com.borg.backup.plist.
  - Open a new terminal.
DONE
