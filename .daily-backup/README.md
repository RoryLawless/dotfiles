# Daily backup

borgmatic backs up the home directory every day at 19:00, run by the
LaunchAgent `com.borg.backup`.

## Files

`~/.daily-backup/borgmatic.yaml` is the borgmatic configuration. It names the
repository and the passphrase command, so it is untracked and mode 600.
`~/.config/borgmatic/config.yaml` is a symlink to it, created by the install
script, so borgmatic needs no `-c`.
`~/.daily-backup/borg-exclude` holds the include and exclude patterns and is
tracked. `~/Library/LaunchAgents/com.borg.backup.plist` is the schedule and is
tracked too. Output goes to `~/Library/Logs/borg/borg-backup-out.log` and
`borg-backup-err.log`.

## Schedule

The LaunchAgent runs this at 19:00 with `/opt/homebrew/bin` on PATH:

    /opt/homebrew/bin/borgmatic --config /Users/rory/.daily-backup/borgmatic.yaml create prune compact

`prune` applies the retention policy and `compact` reclaims space. Check the
registration and the last exit status with:

    launchctl print gui/$(id -u)/com.borg.backup

## Commands

Validate the configuration:

    borgmatic config validate

Check the patterns against a synthetic local archive. This touches nothing
live:

    zsh ~/.config/dotfiles/tests/test-backup.zsh

Run a backup now:

    borgmatic create prune compact

List archives, list files in the latest one, and restore a path from it:

    borgmatic repo-list
    borgmatic list --archive latest --path Users/rory/Documents
    borgmatic extract --archive latest --path Users/rory/Documents --destination ~/tmp/restore

Keep `BORG_PASSPHRASE` unset so the passphrase command in the configuration is
used.

## New machine

Install borgmatic from the Brewfile, restore `borgmatic.yaml` with mode 600,
and register the plist, which the dotfiles checkout puts in place:

    launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.borg.backup.plist

The Keychain item that the passphrase command reads and SSH access to the
backup host must also exist.
