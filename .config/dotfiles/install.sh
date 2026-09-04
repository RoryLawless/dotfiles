#!/bin/zsh
# Bootstrap these dotfiles on a new Mac. See README.md for download instructions.
# Reruns preserve the checkout, but brew bundle may upgrade packages and services.

set -euo pipefail

fail() { print -ru2 -- "dotfiles: $*"; exit 1; }
config() { command git --git-dir="$dotfiles_git_dir" --work-tree="$HOME" -C "$HOME" "$@"; }

check_parents() {
  local ancestor=${1:h}
  while [[ $ancestor != "$HOME" && $ancestor != / ]]; do
    if [[ -L $ancestor || ( -e $ancestor && ! -d $ancestor ) ]]; then
      fail "Unsafe parent path ${(q)ancestor}; nothing beneath it will be changed."
    fi
    ancestor=${ancestor:h}
  done
}

validate_repo() {
  [[ ! -L $dotfiles_git_dir && -d $dotfiles_git_dir ]] ||
    fail "Expected a real bare repository at $dotfiles_git_dir; inspect it before retrying."
  # --work-tree makes rev-parse report non-bare even for this bare repository.
  [[ $(config config --bool core.bare) == true ]] || fail "The existing .cfg is not bare."
  config rev-parse --verify 'HEAD^{commit}' >/dev/null || fail "The .cfg checkout is incomplete: no commit HEAD."
  local origin_url
  origin_url=$(config config --get remote.origin.url) || fail "The .cfg repository has no origin."
  case $origin_url in
    https://github.com/RoryLawless/dotfiles(.git|)|git@github.com:RoryLawless/dotfiles(.git|)|ssh://git@github.com/RoryLawless/dotfiles(.git|)) ;;
    *) fail "The existing .cfg has an unexpected origin; preserve it and inspect before retrying." ;;
  esac
}

checkout_new_repo() {
  local manifest relative target backup_dir='' backup_root="$HOME/.cfg-backup"
  local -a conflicts=()
  manifest=$(mktemp "$dotfiles_git_dir/checkout-paths.XXXXXX") || fail "Cannot create a checkout manifest."
  config ls-tree -rz --name-only HEAD > "$manifest" || fail "Cannot enumerate the intended checkout."
  # Check every path before moving any originals. Never parse Git's diagnostics.
  while IFS= read -r -d '' relative; do
    case $relative in
      ''|/*|../*|*/../*|.cfg|.cfg/*|.cfg-backup|.cfg-backup/*)
        fail "Refusing unsafe tracked path ${(q)relative}." ;;
    esac
    target="$HOME/$relative"
    check_parents "$target"
    if [[ -L $target || -f $target ]]; then
      conflicts+=("$relative")
    elif [[ -e $target ]]; then
      fail "Checkout path ${(q)target} is a directory or special file; inspect it before retrying."
    fi
  done < "$manifest"
  rm -f -- "$manifest"

  if (( ${#conflicts} )); then
    [[ ! -L $backup_root && ( ! -e $backup_root || -d $backup_root ) ]] ||
      fail "Unsafe backup directory $backup_root."
    (umask 077; mkdir -p -- "$backup_root") || fail "Cannot create the backup directory."
    backup_dir=$(mktemp -d "$backup_root/bootstrap.XXXXXX") || fail "Cannot create a private backup."
    chmod 700 "$backup_dir" || fail "Cannot protect the backup directory."
    print -r -- "Pre-existing files will be preserved in: $backup_dir"
    for relative in "${conflicts[@]}"; do
      target="$backup_dir/$relative"
      mkdir -p -- "${target:h}" && mv -- "$HOME/$relative" "$target" ||
        fail "Recovery stopped. Originals remain in $HOME or $backup_dir; inspect both before retrying."
    done
  fi
  config checkout || fail "Checkout failed. Preserve .cfg and ${backup_dir:-the original files}; restore backed-up paths individually before retrying."
}

add_exclusions() {
  local exclude_file="$dotfiles_git_dir/info/exclude" rule
  [[ ! -L $dotfiles_git_dir/info && ( ! -e $dotfiles_git_dir/info || -d $dotfiles_git_dir/info ) ]] ||
    fail "Unsafe .cfg/info directory."
  [[ ! -L $exclude_file && ( ! -e $exclude_file || -f $exclude_file ) ]] || fail "Unsafe Git exclude file."
  mkdir -p -- "${exclude_file:h}"
  local -a rules=(
    .config/zsh/local.zsh
    .config/git/config.local
    .config/git/allowed_signers
    .config/karabiner/automatic_backups/
    .config/karabiner/assets/
    .config/emacs/elpa/
    .config/emacs/opam-user-setup.el
    .config/emacs/auto-save-list/
    .config/emacs/eln-cache/
    .Renviron
    .daily-backup/borgmatic.yaml
    .config/borgmatic/config.yaml
    .cfg-backup/
  )
  for rule in "${rules[@]}"; do
    if [[ ! -f $exclude_file ]] || ! command grep -Fqx -- "$rule" "$exclude_file"; then
      # A separating newline also preserves a local final line without a newline.
      printf '\n%s\n' "$rule" >> "$exclude_file"
    fi
  done
}

find_brew() {
  local candidate
  local -a candidates=("${commands[brew]:-}")
  if [[ $(uname -m) == arm64 ]]; then
    candidates+=(/opt/homebrew/bin/brew /usr/local/bin/brew)
  else
    candidates+=(/usr/local/bin/brew /opt/homebrew/bin/brew)
  fi
  for candidate in "${candidates[@]}"; do
    if [[ -n $candidate && -x $candidate ]] && "$candidate" --prefix >/dev/null 2>&1; then
      print -r -- "$candidate"
      return 0
    fi
  done
  return 1
}

setup_brew() {
  local installer_script brew_environment
  if ! dotfiles_brew=$(find_brew); then
    installer_script=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh) ||
      fail "Homebrew installer download failed."
    [[ -n $installer_script ]] || fail "Homebrew installer download was empty."
    /bin/bash -c "$installer_script" || fail "Homebrew installation failed; inspect its output before retrying."
    rehash
    dotfiles_brew=$(find_brew) || fail "Homebrew installation finished but no working brew was found."
  fi
  brew_environment=$("$dotfiles_brew" shellenv zsh) || fail "Homebrew shell environment failed."
  [[ -n $brew_environment ]] || fail "Homebrew returned an empty shell environment."
  eval "$brew_environment" || fail "Cannot apply the Homebrew shell environment."
}

main() {
  [[ -d $HOME && $HOME == /* && $HOME != / ]] || fail "HOME must be an existing user directory."
  local dotfiles_git_dir="$HOME/.cfg" dotfiles_brew branch_name fresh_clone=false
  local dotfiles_repo=https://github.com/RoryLawless/dotfiles.git

  if ! xcode-select -p >/dev/null 2>&1; then
    print -r -- "Installing Xcode Command Line Tools; rerun when the installer finishes."
    xcode-select --install
    return 1
  fi

  if [[ ! -e $dotfiles_git_dir && ! -L $dotfiles_git_dir ]]; then
    command git clone --bare "$dotfiles_repo" "$dotfiles_git_dir" ||
      fail "Clone failed. Inspect any partial .cfg directory before retrying; it has not been removed."
    fresh_clone=true
  fi
  validate_repo
  if $fresh_clone; then
    branch_name=$(config symbolic-ref --short HEAD) || fail "The new repository has no current branch."
    config config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
    config fetch origin || fail "Cannot initialize remote-tracking branches."
    config branch --set-upstream-to="origin/$branch_name" "$branch_name"
    config config status.showUntrackedFiles no
    checkout_new_repo
  else
    [[ -f $dotfiles_git_dir/index && ! -L $dotfiles_git_dir/index ]] ||
      fail "The existing .cfg has no checkout index. Inspect the incomplete checkout and any .cfg-backup before retrying."
    print -r -- "Existing checkout preserved; no checkout, pull, reset, or remote reconfiguration."
  fi
  add_exclusions

  # A newly checked-out .zshenv does not run inside this already-running process.
  export XDG_CONFIG_HOME="$HOME/.config" XDG_CACHE_HOME="$HOME/Library/Caches"
  export XDG_DATA_HOME="$HOME/.local/share" XDG_STATE_HOME="$HOME/.local/state"
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

  local directory template
  for directory in "$XDG_STATE_HOME/zsh" "$XDG_CACHE_HOME/zsh" "$XDG_DATA_HOME/emacs/backups" "$ZDOTDIR" "$XDG_CONFIG_HOME/git"; do
    check_parents "$directory/placeholder"
    mkdir -p -- "$directory"
  done
  template="$ZDOTDIR/local.zsh"
  if [[ ! -e $template && ! -L $template ]]; then
    (umask 077; print -r -- '# Machine-specific zsh settings. Not tracked. Sourced at the end of .zshrc.' > "$template")
  fi
  template="$XDG_CONFIG_HOME/git/config.local"
  if [[ ! -e $template && ! -L $template ]]; then
    (umask 077; print -r -- '[user]
    name = Rory Lawless
    email =
    signingkey = ssh-ed25519 ...

[gpg "ssh"]
    program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign' > "$template")
  fi

  setup_brew
  print -r -- 'Installing the Brewfile. This can upgrade packages and restart configured services, including on reruns.'
  "$dotfiles_brew" bundle install --file="$XDG_CONFIG_HOME/homebrew/Brewfile"

  print -r -- '
Done. Remaining manual steps:
  - Fill in ~/.config/git/config.local and create ~/.config/git/allowed_signers.
  - Enable the 1Password SSH agent and configure your signing key.
  - After SSH authentication works, optionally change origin from HTTPS to SSH.
  - Restore ~/.Renviron and ~/.daily-backup/borgmatic.yaml privately (mode 0600).
    borg-exclude and the backup README are already tracked; do not overwrite them.
  - Restore the backup LaunchAgent and follow ~/.daily-backup/README.md for
    Keychain/SSH access, logs, registration, and authorized backup verification.
  - Open a new terminal. See ~/.config/dotfiles/README.md for details.'
}

if [[ $ZSH_EVAL_CONTEXT == toplevel ]]; then
  main "$@"
fi
