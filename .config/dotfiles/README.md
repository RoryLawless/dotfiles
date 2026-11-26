# Dotfiles

A bare Git repository at `~/.cfg` with the home directory as its work tree.
`.zshrc` defines `config` as the git command for it:

    config status
    config add .config/zsh/.zshrc
    config commit -m "Message"
    config push

`config status` shows tracked files only. `config ls-files` lists them.
Commits are signed with the SSH key at `~/.ssh/git-personal`.

## What is where

`~/.zshenv` is the only zsh file in the home directory. It sets the XDG
variables and points `ZDOTDIR` at `~/.config/zsh`, which holds `.zprofile`
(Homebrew, PATH, tool environment variables) and `.zshrc` (interactive setup).
`XDG_CACHE_HOME` is set explicitly to `~/.cache`, the default, because
`.zshrc` and `sync-pixi.zsh` build cache paths from it and GUI and launchd
processes, which do not read `.zshenv`, fall back to the same directory.
`~/.config/zsh/local.zsh` is untracked and is sourced near the end of `.zshrc`
for machine-specific settings.

`~/.config/git` holds the git config, global attributes and global ignore.
Identity and signing key are in `config.local` next to them, untracked.

`~/.config/homebrew` holds the Brewfile and `brew.env`. Emacs, air,
jarl, cookiecutter, karabiner and ghostty are configured under `~/.config` as
well. Positron settings are tracked at
`~/Library/Application Support/Positron/User/settings.json`, and the borg and
imap-backup LaunchAgents at `~/Library/LaunchAgents/com.borg.backup.plist` and
`com.rory.imap-backup.daily.plist`.

`~/.Rprofile` sets the R package repositories and interactive options.

`~/.daily-backup` holds the borg backup patterns and its own README.

Five files hold secrets or machine-specific settings and are excluded from
git in `~/.cfg/info/exclude`: `~/.Renviron`, `~/.config/.env`,
`~/.config/zsh/local.zsh`, `~/.daily-backup/borgmatic.yaml` and
`~/.config/git/config.local`. The install script maintains the exclude list.
`~/.imap-email-backup` holds the imap-backup configuration and mail data and
is never added to the repository.

## New machine

    zsh <(curl -fsSL https://raw.githubusercontent.com/RoryLawless/dotfiles/main/.config/dotfiles/install.sh)

The script installs the Command Line Tools if they are missing and clones the
repository over HTTPS. Before moving any files, it checks the parent directories
of tracked paths and stops if it finds a symlink or a non-directory. It moves
existing files at checkout destinations to `~/.cfg-backup/checkout.*`, checks
out, writes the exclude rules, installs Homebrew, runs `brew bundle`, restores
Pixi tools and completion links, writes templates for `local.zsh` and
`config.local`, and creates the borgmatic config symlink and backup log
directory. Rerun the script to resume an interrupted first checkout. Each
checkout attempt uses its own backup directory. Once the checkout exists,
`zsh ~/.config/dotfiles/install.sh` runs the same steps and is safe to repeat.

Then finish by hand:

1. Fill in the email and signing key in `~/.config/git/config.local`.
2. Restore `~/.ssh/git-personal` and add it to the SSH agent.
3. Switch the remote to SSH:
   `config remote set-url origin git@github.com:RoryLawless/dotfiles.git`
4. Restore `~/.Renviron` and `~/.daily-backup/borgmatic.yaml` with mode 600.
5. Register the backup LaunchAgent as described in `~/.daily-backup/README.md`.
6. Install R with `rig add release` if the machine has no R installation.
   Installing `r-rig` alone does not install R.
7. Open a new terminal.

### Pixi global tools

`~/.config/pixi/manifests/pixi-global.toml` records the global tools and
exposed command names. Keep changes made by `pixi global install`,
`uninstall`, or `expose` in the dotfiles repository. This manifest records
package requirements, not an exact lock of installed versions.

The installer restores these tools automatically. To repeat this separately:

```sh
zsh ~/.config/dotfiles/sync-pixi.zsh
```

The helper runs `pixi global sync`, links package-provided zsh completions,
and invalidates the completion dump when links change. Homebrew manages
Pixi itself; Pixi manages Air, Jarl, Ruff, Ty, DuckDB, Quarto, Marimo, the
Python language server, and the cookiecutter-data-science CLI.

Set `PIXI_HOME` before installing environments. Moving existing environment
directories can leave absolute interpreter and activation paths pointing to
the old location; `global sync` alone may not repair those paths. Reinstall
the affected packages with `pixi global install --force-reinstall`, preserving
any explicit exposure mappings (such as `pylsp`).

### R package updater

`~/.local/bin/rupdate` checks for R package updates and installs them with pak.
It updates package copies in their existing writable libraries and marks
updates in read-only libraries as skipped. Pak can use dependencies from other
active libraries. The dry run lists candidate package updates. Pak may also
update dependencies during installation.

R excludes core packages such as `stats` from the update check. Recommended
packages such as `MASS` can be installed separately from the copy shipped with
R, so both copies can appear in the update list.

On each new machine, install its dependencies and generate the Rapp launcher
by running this in R:

```r
install.packages(c("Rapp", "pak"))
Rapp::install_pkg_cli_apps("Rapp")
```

The launcher is installed in `~/.local/bin`, which the zsh configuration
already adds to `PATH`. Track the `rupdate` script, but regenerate the `Rapp`
launcher on each machine rather than tracking it in Git.

```sh
rupdate             # Check for updates and install them
rupdate --dry-run   # List updates without installing
rupdate --help      # Show help
```

## Checks

    zsh -n ~/.zshenv ~/.config/zsh/.zprofile ~/.config/zsh/.zshrc
    emacs --batch -l ~/.config/emacs/init.el
    zsh ~/.config/dotfiles/tests/test-backup.zsh
