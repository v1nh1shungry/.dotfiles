case $- in
    *i*) ;;
      *) return;;
esac

source "$HOME/.dotfiles/bash/bash-sensible/sensible.bash"

if grep WSL <(uname -a) >/dev/null; then
    source "$HOME/.dotfiles/bash/local/wsl.bash"
fi

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export EDITOR=vim

alias bat='bat --theme Dracula'
alias grep='grep --color=auto'

bind '"\e[15~":"asynctask -f\n"'
