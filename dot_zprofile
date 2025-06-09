export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox"
export PATH="$PATH:$HOME/.local/bin:/home/bulatov/.dotnet/tools:/home/bulatov/go/bin"
export GPG_TTY=$(tty)

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

. ~/.zprofile_secrets

if [[ "$(tty)" = "/dev/tty1" ]]; then
	startx .xinitrc
fi
