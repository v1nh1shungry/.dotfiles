case $- in
*i*) ;;
*) return ;;
esac

# GENERAL OPTIONS
shopt -s checkwinsize
bind Space:magic-space
shopt -s globstar 2> /dev/null
shopt -s nocaseglob;

# SMARTER TAB-COMPLETION (Readline bindings)
bind "set completion-ignore-case on"
bind "set completion-map-case on"
bind "set show-all-if-ambiguous on"
bind "set mark-symlinked-directories on"

# SANE HISTORY DEFAULTS
shopt -s histappend
shopt -s cmdhist
PROMPT_COMMAND='history -a'
HISTSIZE=500000
HISTFILESIZE=100000
HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
HISTTIMEFORMAT='%F %T '
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

# BETTER DIRECTORY NAVIGATION
shopt -s autocd 2> /dev/null
shopt -s dirspell 2> /dev/null
shopt -s cdspell 2> /dev/null
CDPATH="."
shopt -s cdable_vars

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

eval "$(register-python-argcomplete pipx)"

source "/usr/share/xmake/scripts/profile-unix.sh"

eval "$(starship init bash)"

eval "$(fnm env)"
export FNM_NODE_DIST_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/

alias bat='bat --theme Dracula'
alias grep='grep --color=auto'
alias l=ls
alias ls='exa --icons'
alias la='ls -a'
alias ll='ls -al --git'
alias tree='exa -T --icons'
alias diff=difft
