#!/bin/zsh
# Check the borg-exclude patterns against synthetic files in a local archive.
emulate -L zsh
setopt errexit nounset pipefail

tests_dir=${0:A:h}
dotfiles_root=${tests_dir:h:h:h}
pattern_source="$dotfiles_root/.daily-backup/borg-exclude"
borg_command=${commands[borg]:-}
[[ -n $borg_command ]] || { print -ru2 -- 'Borg is required for this local test.'; exit 1; }
fixture_root=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-patterns.XXXXXX")
trap 'rm -rf -- "$fixture_root"' EXIT
mkdir -p "$fixture_root/home" "$fixture_root/tree/Users/rory"
fixture_home="$fixture_root/tree/Users/rory"

included=(.Rprofile .config/zsh/.zshrc Documents/check.txt Library/Preferences/check.plist Library/Messages/check.txt)
excluded=(Downloads/check.txt Library/Caches/check.txt repos/check.txt Documents/check.log)
for relative in "${included[@]}" "${excluded[@]}"; do
  target="$fixture_home/$relative"
  mkdir -p -- "${target:h}"
  print -r -- 'synthetic backup fixture' > "$target"
done
# Make the root relative to the fixture tree; archive paths stay Users/rory/...
sed 's|^R /Users/rory$|R Users/rory|' "$pattern_source" > "$fixture_root/patterns"
local_borg() {
  env -i HOME="$fixture_root/home" PATH=/usr/bin:/bin LANG=en_US.UTF-8 \
    BORG_BASE_DIR="$fixture_root/state" BORG_RSH=/usr/bin/false \
    "$borg_command" "$@"
}
local_borg init --encryption=none "$fixture_root/repository"
(
  cd "$fixture_root/tree"
  local_borg create --patterns-from "$fixture_root/patterns" "$fixture_root/repository::patterns"
)
listing=$(local_borg list --short "$fixture_root/repository::patterns")
for relative in "${included[@]}"; do
  print -r -- "$listing" | grep -Fxq -- "Users/rory/$relative" || {
    print -ru2 -- "Missing expected archive member: $relative"; exit 1
  }
done
for relative in "${excluded[@]}"; do
  if print -r -- "$listing" | grep -Fxq -- "Users/rory/$relative"; then
    print -ru2 -- "Unexpected archive member: $relative"; exit 1
  fi
done
print -r -- 'ok - archive includes five intended files and excludes four unwanted files'
