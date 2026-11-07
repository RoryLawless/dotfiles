#!/bin/zsh
# Restore global tools from the manifest tracked in the dotfiles repository.
emulate -L zsh
setopt errexit nounset pipefail

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/Library/Caches}"
export PIXI_HOME="${PIXI_HOME:-$XDG_CONFIG_HOME/pixi}"
[[ -r "$PIXI_HOME/manifests/pixi-global.toml" ]] || {
  print -ru2 -- "Missing global manifest: $PIXI_HOME/manifests/pixi-global.toml"
  exit 1
}
pixi global sync

# Some packages ship completion functions without exposing them to zsh.
completion_dir="$PIXI_HOME/completions/zsh"
mkdir -p "$completion_dir"
changed=0
for completion in "$PIXI_HOME"/envs/*/share/zsh/site-functions/_*(N.); do
  link="$completion_dir/${completion:t}"
  if [[ ! -L $link || $(readlink "$link") != "$completion" ]]; then
    # Preserve handwritten completion functions instead of overwriting them.
    [[ ! -e $link || -L $link ]] || {
      print -ru2 -- "Refusing to replace completion file: $link"
      exit 1
    }
    ln -sfn "$completion" "$link"
    changed=1
  fi
done
for link in "$completion_dir"/_*(N@); do
  if [[ ! -e $link && $(readlink "$link") == "$PIXI_HOME/envs/"* ]]; then
    rm -- "$link"
    changed=1
  fi
done
if (( changed )); then
  rm -f -- "$XDG_CACHE_HOME/zsh/zcompdump" "$XDG_CACHE_HOME/zsh/zcompdump.zwc"
fi
print -r -- 'Pixi global tools and zsh completion links are ready. Open a new shell to load completions.'
