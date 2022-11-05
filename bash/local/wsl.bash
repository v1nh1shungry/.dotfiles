export PATH=$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH=/mnt/d/wslutils/gsudo:$PATH
export PATH=/mnt/d/Microsoft\ VS\ Code/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH

WINIP=$(grep nameserver /etc/resolv.conf | awk '{print $2}')
export DISPLAY=$WINIP:0
export PULSE_SERVER=tcp:$WINIP
export BROWSER=wslview

eval "$(register-python-argcomplete pipx)"

source "/usr/share/xmake/scripts/profile-unix.sh"

eval "$(starship init bash)"

eval "$(fnm env)"
export FNM_NODE_DIST_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/

sed -i '/\[ProxyList\]/,$d' ~/.config/proxychains.conf
echo -e "[ProxyList]\nsocks5 $WINIP 10810" >>~/.config/proxychains.conf

alias ls='exa --icons'
alias la='ls -a'
alias ll='ls -al --git'
alias tree='exa -T --icons --level 3 --ignore-glob=".git"'
alias ps=procs
alias proxy='proxychains4 -q -f ~/.config/proxychains.conf'
