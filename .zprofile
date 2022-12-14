export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox"
export PATH="$PATH:$HOME/.local/bin"
. ~/.zprofile_secrets

if [[ "$(tty)" = "/dev/tty1" ]]; then
	startx ~/.xinitrc
fi
