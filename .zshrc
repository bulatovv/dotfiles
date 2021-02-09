### FUNCTIONS
. ~/.scripts/functions.sh

### PLUGINS

### PROMPT
#PROMPT="%F{4}%n%F{6}@%m %F{7}%30<...<%~%<< %F{255}> "
PROMPT=" %F{7}%30<...<%~%<< %F{2}>%F{15} "

### HISTORY
HISTFILE=~/.zsh_history
HISTSIZE=500
SAVEHIST=500

### KEYBINDS
# ---

### ALIASES
alias ".."="cd .."
alias ls='ls --color'
alias ovim='/bin/vim'
alias vim=nvim
alias rmswap="rm ~/.local/share/nvim/swap/*"

alias sync-configs=~/.scripts/dotsync/dotsync.sh
alias i3-config="vim ~/.config/i3/config"
alias i3b-config="vim ~/.config/i3blocks/config"
alias newsboat-config="vim ~/.config/newsboat/config"
alias newsboat-urls="vim ~/.config/newsboat/urls"
alias vim-config="vim ~/.config/nvim/init.vim"
alias lf-config="vim ~/.config/lf/lfrc"
