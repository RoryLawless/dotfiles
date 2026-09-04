# Daily backup (borgmatic)

## Files and restoration

| File | Handling |
| --- | --- |
| `~/.daily-backup/borgmatic.yaml` | Private runtime configuration; restore separately, keep out of Git, mode `0600`. |
| `~/.daily-backup/borg-exclude` | Tracked include/exclude patterns; restored by the dotfiles checkout. |
| `~/.daily-backup/README.md` | Tracked documentation; restored by the dotfiles checkout. |
| `~/Library/LaunchAgents/com.borg.backup.plist` | Machine-local scheduled job; restore separately and inspect before loading. |
| `~/.config/borgmatic/config.yaml` | Optional conventional-path symlink to the private YAML; keep out of Git. The job uses the YAML's explicit path. |

Restore the YAML through a private channel, without displaying its contents in
chat or terminal logs. Restrict its permissions and inspect any ACLs:

```zsh
chmod 600 "$HOME/.daily-backup/borgmatic.yaml"
ls -le "$HOME/.daily-backup/borgmatic.yaml"
```

The owner-only mode must not be undermined by an ACL granting other users
access. Restore the Keychain item referenced by `encryption_passcommand`, SSH
access to the configured backup repository, and any monitoring credentials.
Keep `BORG_PASSPHRASE` unset so the configured passphrase command is used.
Replacement of an exposed notification credential must happen in the private
account workflow, followed by updating any consumers; do not paste replacements
into a support conversation.

The current LaunchAgent writes to these paths, whose parent must exist:

- `~/Library/Logs/borg/borg-backup-out.log`
- `~/Library/Logs/borg/borg-backup-err.log`

Review protected-folder access for the actual scheduled process. A successful
interactive terminal test does not establish that launchd has the same Keychain,
SSH, or macOS privacy access.

## Schedule and registration

The job is named `com.borg.backup`, runs daily at 19:00, and executes:

```zsh
/opt/homebrew/bin/borgmatic --config /Users/rory/.daily-backup/borgmatic.yaml create prune compact
```

This includes retention changes: `prune` removes archives according to the
configured policy and `compact` reclaims repository space. Do not start the job
as a harmless connectivity test. Its paths are machine-specific; inspect them
when restoring on another Mac.

Restoring the plist alone does not register it. Inspect its arguments, schedule,
environment, and any `RunAtLoad` setting, then register it only when ready for
the configured job to run:

```zsh
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.borg.backup.plist"
```

Check registration and the most recent recorded result without starting a run:

```zsh
launchctl print "gui/$(id -u)/com.borg.backup"
```

## Validation and diagnostics

Validate syntax and schema without displaying configuration values:

```zsh
env -u BORG_PASSPHRASE borgmatic -c "$HOME/.daily-backup/borgmatic.yaml" config validate
```

Do not use `--show` in shared diagnostics; the configuration contains secrets.
The standalone validation action in the installed borgmatic does not run backup
actions or monitoring hooks. Review command behavior again after major upgrades.

Test the tracked patterns without loading the private configuration or touching
the server:

```zsh
zsh "$HOME/.config/dotfiles/tests/test-backup.zsh"
```

Before other borgmatic diagnostics, inspect configured command and monitoring
hooks privately. A command called a “dry run” is not proof that every hook or
notification is inert. Use isolated local fixtures with inert hooks for tests.

When a live backup has been explicitly authorized, a create-only diagnostic is:

```zsh
env -u BORG_PASSPHRASE borgmatic -c "$HOME/.daily-backup/borgmatic.yaml" create
```

This writes a real archive and may deliver notifications, but does not run the
job's prune/compact actions. It does not prove the complete scheduled job works.
Changing transport, retries, or scheduling should follow a reproduced failure,
not a historical connection-reset message alone.

## Evidence of success

Record the job's completion and exit status separately from underlying Borg
codes; they are not interchangeable. Inspect warnings for omitted files and
document any accepted exceptions instead of suppressing them. An archive can
exist even if another action failed later.

For an authorized full-job verification, record the archive time/name and
representative members from after deployment, including `.Rprofile` and
`.config/zsh/.zshrc`. A listing from an archive created before the Zsh relocation
cannot verify that new path. A clean local job result is useful evidence, but
does not replace checking archive contents and, when appropriate, a restore.
