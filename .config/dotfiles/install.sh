#!/bin/zsh
# Bootstrap these dotfiles on a new Mac. Safe to rerun.
#
#   zsh <(curl -fsSL https://raw.githubusercontent.com/RoryLawless/dotfiles/main/.config/dotfiles/install.sh)
#
# Files that the first checkout would overwrite are moved to ~/.cfg-backup.

set -euo pipefail

repo=https://github.com/RoryLawless/dotfiles.git
git_dir="$HOME/.cfg"
config() { git --git-dir="$git_dir" --work-tree="$HOME" "$@"; }

# 1. Command Line Tools provide git until Homebrew's git is installed.
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools; rerun this script when the installer finishes."
  xcode-select --install
  exit 1
fi

# 2. Clone over HTTPS so no SSH key is needed yet. A bare clone has no fetch
#    refspec and no upstream, and `config pull` fails without them.
if [[ ! -d $git_dir ]]; then
  git clone --bare "$repo" "$git_dir"
  config config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
  config fetch origin
  config branch --set-upstream-to=origin/main main

  # Move aside anything the checkout would overwrite, then check out.
  backup="$HOME/.cfg-backup"
  config ls-tree -rz --name-only HEAD | while IFS= read -r -d '' f; do
    [[ -e $HOME/$f || -L $HOME/$f ]] || continue
    mkdir -p "$backup/${f:h}"
    mv "$HOME/$f" "$backup/$f"
  done
  [[ ! -d $backup ]] || echo "Pre-existing files moved to $backup"
  config checkout
fi
config config status.showUntrackedFiles no

# 3. Machine-specific files that git should ignore. Append only what is missing.
exclude="$git_dir/info/exclude"
for rule in \
  .config/zsh/local.zsh \
  .config/git/config.local \
  .config/karabiner/automatic_backups/ \
  .config/karabiner/assets/ \
  .config/emacs/elpa/ \
  .config/emacs/opam-user-setup.el \
  .config/emacs/auto-save-list/ \
  .config/emacs/eln-cache/ \
  .config/borgmatic/config.yaml \
  .daily-backup/borgmatic.yaml \
  .Renviron \
  .cfg-backup/
do
  grep -qxF -- "$rule" "$exclude" 2>/dev/null || echo "$rule" >> "$exclude"
done

# 4. Homebrew and the Brewfile. Apple Silicon uses /opt/homebrew, Intel /usr/local.
brew_prefix=/opt/homebrew
[[ $(uname -m) == arm64 ]] || brew_prefix=/usr/local
if [[ ! -x $brew_prefix/bin/brew ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$($brew_prefix/bin/brew shellenv zsh)"
brew bundle install --file="$HOME/.config/homebrew/Brewfile"

# 5. Untracked local files: templates if absent, and the symlink that lets
#    borgmatic find its configuration without -c.
[[ -f $HOME/.config/zsh/local.zsh ]] || cat > "$HOME/.config/zsh/local.zsh" <<'EOF'
# ~/.config/zsh/local.zsh
# Machine-specific settings. Not tracked in the dotfiles repo.
# Sourced near the end of .zshrc, so anything here overrides the tracked config.
EOF

[[ -f $HOME/.config/git/config.local ]] || cat > "$HOME/.config/git/config.local" <<'EOF'
[user]
    name = Rory Lawless
    email =
    signingkey = ssh-ed25519 ...

[gpg "ssh"]
    program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign
EOF

mkdir -p "$HOME/.config/borgmatic"
[[ -L $HOME/.config/borgmatic/config.yaml ]] ||
  ln -s "$HOME/.daily-backup/borgmatic.yaml" "$HOME/.config/borgmatic/config.yaml"

cat <<'EOF'

Done. Finish by hand (details in ~/.config/dotfiles/README.md):
  - Fill in ~/.config/git/config.local.
  - Enable the 1Password SSH agent, then switch origin to SSH.
  - Restore ~/.Renviron and ~/.daily-backup/borgmatic.yaml, then register the backup LaunchAgent.
  - Open a new terminal.
EOF
