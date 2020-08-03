### FUNCTIONS
. ~/.scripts/functions.sh

### PLUGINS
source ~/.antigen/antigen.zsh 
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen apply

### PROMPT
PROMPT="%F{4}%n%F{6}@%m %F{7}%30<...<%~%<< %F{255}> "

### HISTORY
HISTFILE=~/.zsh_history
HISTSIZE=100
SAVEHIST=100

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
