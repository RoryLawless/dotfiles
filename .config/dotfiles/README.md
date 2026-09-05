# Dotfiles

A bare Git repository at `~/.cfg` with the home directory as its work tree.
`.zshrc` defines `config` as the git command for it:

    config status
    config add .config/zsh/.zshrc
    config commit -m "Message"
    config push

`config status` shows tracked files only. `config ls-files` lists them.
Commits are signed with the SSH key held in 1Password.

## What is where

`~/.zshenv` is the only zsh file in the home directory. It sets the XDG
variables and points `ZDOTDIR` at `~/.config/zsh`, which holds `.zprofile`
(Homebrew, PATH, tool environment variables) and `.zshrc` (interactive setup).
`~/.config/zsh/local.zsh` is untracked and is sourced near the end of `.zshrc`
for machine-specific settings.

`~/.config/git` holds the git config, global attributes and global ignore.
Identity and signing key are in `config.local` next to them, untracked.

`~/.config/homebrew` holds the Brewfile and `brew.env`. Emacs, OCaml, air,
jarl, cookiecutter, karabiner and ghostty are configured under `~/.config` as
well. Positron settings are tracked at
`~/Library/Application Support/Positron/User/settings.json`, and the backup
LaunchAgent at `~/Library/LaunchAgents/com.borg.backup.plist`.

`~/.Rprofile` sets the R package repositories and interactive options.

`~/.daily-backup` holds the borg backup patterns and its own README.

Three files hold secrets and are excluded from git in `~/.cfg/info/exclude`:
`~/.Renviron`, `~/.daily-backup/borgmatic.yaml` and
`~/.config/git/config.local`. The install script maintains the exclude list.

## New machine

    zsh <(curl -fsSL https://raw.githubusercontent.com/RoryLawless/dotfiles/main/.config/dotfiles/install.sh)

The script installs the Command Line Tools if they are missing, clones the
repository over HTTPS, moves any file the checkout would overwrite to
`~/.cfg-backup`, checks out, writes the exclude rules, installs Homebrew, runs
`brew bundle`, writes templates for `local.zsh` and `config.local`, and creates the borgmatic
config symlink. Once
the checkout exists, `zsh ~/.config/dotfiles/install.sh` runs the same steps
and is safe to repeat.

Then finish by hand:

1. Fill in the email and signing key in `~/.config/git/config.local`.
2. Enable the 1Password SSH agent and add the signing key to it.
3. Switch the remote to SSH:
   `config remote set-url origin git@github.com:RoryLawless/dotfiles.git`
4. Restore `~/.Renviron` and `~/.daily-backup/borgmatic.yaml` with mode 600.
5. Register the backup LaunchAgent as described in `~/.daily-backup/README.md`.
6. Open a new terminal.

## Checks

    zsh -n ~/.zshenv ~/.config/zsh/.zprofile ~/.config/zsh/.zshrc
    emacs --batch -l ~/.config/emacs/init.el
    zsh ~/.config/dotfiles/tests/test-backup.zsh
