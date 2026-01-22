
autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%b '

setopt PROMPT_SUBST

PROMPT='%2~ %(?.%F{14}❯.%F{9}❯)%f '
RPROMPT='%F{8}${vcs_info_msg_0_}%f%F{8}%*%f'

source <(fzf --zsh)

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)
# ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# The following lines were added by compinstall

autoload -Uz compinit; compinit
_comp_options+=(globdots)

# End of lines added by compinstall

# Aliases
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME/'
alias ls='eza --long --header --icons=never'
alias python='python3'
alias rmrf='rm -rf'
alias updateR='Rscript -e "remotes::update_packages(upgrade = \"always\", build = TRUE)"'
alias borg='op run -- borg'
alias update='brew update && brew upgrade --force --greedy && brew cleanup'
alias positron='open /Applications/Positron.app'
alias cat='bat'

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh

