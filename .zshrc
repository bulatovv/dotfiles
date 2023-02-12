fpath=(~/.zsh/plug/zsh-completions/src $fpath)
autoload -Uz compinit; compinit
autoload -Uz vcs_info
precmd() { vcs_info }


### FUNCTIONS
. ~/.scripts/functions.sh

### PLUGINS
. ~/.zsh/plug/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
. ~/.zsh/plug/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

### PROMPT
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT=' %30<...<%~%<< %F{green}> $f'
RPROMPT='${vcs_info_msg_0_:+on} %F{yellow}${vcs_info_msg_0_}$f'


### HISTORY
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

### KEYBINDS
# ---

### ALIASES
alias ".."="cd .."
alias "~"="cd"
alias ls='ls --color'
alias ovim='/bin/vim'
alias vim=nvim
alias rmswap="rm ~/.local/state/nvim/swap/*"

alias gt='cd $(git rev-parse --show-toplevel)'
alias dotsync=~/.scripts/dotsync/dotsync.sh
alias i3-config="vim ~/.config/i3/config"
alias vim-config="vim ~/.config/nvim/init.vim"
