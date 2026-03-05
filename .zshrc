
# Completions

autoload -Uz compinit

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    compinit
else
    compinit -C
fi

_comp_options+=(globdots)

# Setup git prompt

source "$(brew --prefix git)/etc/bash_completion.d/git-prompt.sh"

function custom_prompts () {
    RPS1='$(__git_ps1 "%s") %F{8}%T%f'
    PS1='%2~ %(?.%F{green}❯.%F{red}❯)%f '
}

precmd_functions+=(custom_prompts)

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM=(verbose git)
export GIT_PS1_SHOWCOLORHINTS=true

setopt PROMPT_SUBST

# Environment vars for defaults
export EDITOR="emacs"
export VISUAL="$EDITOR"
export GPG_TTY=$(tty)

# Aliases
alias borg='op run -- borg'
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME/'
alias ls='eza --long --header --icons=never'
alias python='python3'
alias rmrf='rm -rf'
alias updateR='Rscript -e "remotes::update_packages(upgrade = \"always\", build = TRUE)"'
alias update='brew update && brew upgrade --force --greedy && brew cleanup'
alias positron='open /Applications/Positron.app'
alias cat='bat'

# Extensions
BREW_PREFIX=$(brew --prefix)

source <(fzf --zsh)

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

source $BREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)
source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/rory/.opam/opam-init/init.zsh' ]] || source '/Users/rory/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

# Added by Antigravity
export PATH="/Users/rory/.antigravity/antigravity/bin:$PATH"
