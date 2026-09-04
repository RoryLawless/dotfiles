# Daily Backup (Borgmatic)

This backup system has been migrated from custom shell scripts to `borgmatic`.

## Active paths
- Runtime config: `/Users/rory/.daily-backup/borgmatic.yaml`
- Pattern file: `/Users/rory/.daily-backup/borg-exclude`
- LaunchAgent: `/Users/rory/Library/LaunchAgents/com.borg.backup.plist`

## Scheduled run
The LaunchAgent runs daily at `19:00` and executes:

```bash
/opt/homebrew/bin/borgmatic --config /Users/rory/.daily-backup/borgmatic.yaml create prune compact
```

## Manual commands
Validate config:

```bash
env -u BORG_PASSPHRASE borgmatic -c /Users/rory/.daily-backup/borgmatic.yaml config validate
```

Dry run:

```bash
env -u BORG_PASSPHRASE borgmatic -c /Users/rory/.daily-backup/borgmatic.yaml --dry-run create prune compact
```

Run backup now:

```bash
env -u BORG_PASSPHRASE borgmatic -c /Users/rory/.daily-backup/borgmatic.yaml create prune compact
```

## Notes
- Keep `BORG_PASSPHRASE` unset in shell environments so `encryption_passcommand` is used.
- Some macOS protected folders may emit warning-level permission messages depending on runtime context.
