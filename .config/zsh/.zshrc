# ~/.config/zsh/.zshrc

# A non-login shell normally inherits the login environment; build it if not
[[ -n $HOMEBREW_PREFIX ]] || source "$ZDOTDIR/.zprofile"

# History
HISTFILE="$XDG_STATE_HOME/zsh/history"
[[ -d ${HISTFILE:h} ]] || mkdir -p "${HISTFILE:h}"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt SHARE_HISTORY EXTENDED_HISTORY

# Directories: cd into a ~/repos project from anywhere, with or without cd
cdpath=("$HOME/repos")
setopt AUTO_CD

# Line editor: emacs keymap, up/down search history by typed prefix
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
[[ -n $terminfo[kcuu1] ]] && bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
[[ -n $terminfo[kcud1] ]] && bindkey "$terminfo[kcud1]" down-line-or-beginning-search

# Completions
if [[ -n $HOMEBREW_PREFIX ]]; then
  fpath=(
    "$HOMEBREW_PREFIX/share/zsh-completions"
    "$HOMEBREW_PREFIX/share/zsh/site-functions"
    $fpath
  )
fi

zstyle ':completion:*' menu no                 # fzf-tab draws the menu instead
zstyle ':completion:*:descriptions' format '[%d]'   # group headings in fzf-tab
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/compcache"

autoload -Uz compinit
zcompdump="$XDG_CACHE_HOME/zsh/zcompdump"
[[ -d ${zcompdump:h} ]] || mkdir -p "${zcompdump:h}"
if [[ -n $zcompdump(#qN.mh+24) ]]; then
  compinit -d "$zcompdump"       # dump older than a day: full rescan
else
  compinit -C -d "$zcompdump"    # otherwise trust the cached dump
fi
unset zcompdump
_comp_options+=(globdots)

# Prompt
setopt PROMPT_SUBST
PS1='%2~ %(?.%F{green}❯.%F{red}❯)%f '

git_prompt="$HOMEBREW_PREFIX/opt/git/etc/bash_completion.d/git-prompt.sh"
if [[ -r $git_prompt ]]; then
  source "$git_prompt"
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWUNTRACKEDFILES=true
  GIT_PS1_SHOWUPSTREAM=(verbose git)
  RPS1='$(__git_ps1 "%s") %F{8}%T%f'
fi
unset git_prompt

# Defaults
export EDITOR="cot -w"
[[ -n $SSH_CONNECTION ]] && export EDITOR="emacs -nw"   # no GUI over SSH
export VISUAL="$EDITOR"
export GPG_TTY=$(tty)
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Aliases
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME/'
alias ls='eza --long --header --icons=never'
alias python='python3'
alias update='brew update && brew upgrade --yes && brew cleanup'
alias positron='open /Applications/Positron.app'
alias cat='bat'

# Typing a data file's name prints its first rows
peek() { duckdb -c "SELECT * FROM '$1' LIMIT 20" }
alias -s {csv,parquet,json}=peek

# opam
[[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2>&1

# zoxide: z jumps to a directory you have visited, zi picks one with fzf
eval "$(zoxide init zsh)"

# fzf: Ctrl-R history, Ctrl-T files, Alt-C cd
export FZF_DEFAULT_OPTS='--height 40% --layout reverse --border'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
(( $+commands[fzf] )) && source <(fzf --zsh)

# fzf-tab: Tab completion through fzf. Loads after compinit and before the
# plugins that wrap widgets (autosuggestions, syntax highlighting).
if [[ -r "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh"
  zstyle ':fzf-tab:*' use-fzf-default-opts yes
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
  zstyle ':completion:*:git-checkout:*' sort false
fi

# Autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
[[ -r "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Mole completion, cached and regenerated when the binary changes
if (( $+commands[mole] )); then
  mole_comp="$XDG_CACHE_HOME/zsh/mole-completion.zsh"
  if [[ ! -s $mole_comp || ${commands[mole]:A} -nt $mole_comp ]]; then
    mole completion zsh > "$mole_comp" 2>/dev/null
  fi
  source "$mole_comp"
  unset mole_comp
fi

# Machine-specific, untracked
[[ -r $ZDOTDIR/local.zsh ]] && source "$ZDOTDIR/local.zsh"

# Syntax highlighting: must be sourced last
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)
[[ -r "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
