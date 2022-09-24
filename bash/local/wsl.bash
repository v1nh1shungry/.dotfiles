export PATH=$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH=/mnt/d/wslutils/gsudo:$PATH
export PATH=/mnt/d/Microsoft\ VS\ Code/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH

WINIP=$(grep nameserver /etc/resolv.conf | awk '{print $2}')
export DISPLAY=$WINIP:0
export PULSE_SERVER=tcp:$WINIP
export BROWSER=wslview

export DOTNET_CLI_TELEMETRY_OPTOUT=true

export HSTR_CONFIG=hicolor
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

eval "$(register-python-argcomplete pipx)"

source "/usr/share/xmake/scripts/profile-unix.sh"

source /usr/share/nvm/init-nvm.sh

eval "$(starship init bash)"

sed -i '/\[ProxyList\]/,$d' ~/.config/proxychains.conf
echo -e "[ProxyList]\nsocks5 $WINIP 10810" >> ~/.config/proxychains.conf

alias ls='exa --icons'
alias la='ls -a'
alias ll='ls -al --git'
alias tree='exa -T --icons --level 3 --ignore-glob=".git"'
alias ps=procs
alias diff=difft
alias proxy='proxychains4 -q -f ~/.config/proxychains.conf'

if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
