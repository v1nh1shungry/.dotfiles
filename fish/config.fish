if status is-interactive
    set -g fish_greeting

    set -gx PATH $HOME/.local/bin /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
    set -gx PATH /mnt/c/Windows/System32/ $PATH
    set -gx PATH /mnt/c/Windows/System32/WindowsPowerShell/v1.0/ $PATH
    set -gx PATH /mnt/d/wslutils/gsudo $PATH
    set -gx PATH /mnt/d/Microsoft\ VS\ Code/bin $PATH
    set -gx PATH $HOME/.cargo/bin $PATH
    set -gx PATH $HOME/github/llvm-project/build/bin $PATH

    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_visual block

    starship init fish | source

    fnm env | source
    set -gx FNM_NODE_DIST_MIRROR https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/

    alias vim nvim
    alias bat 'bat --theme Dracula'
    alias grep 'grep --color=auto'
    alias ls 'exa --icons'
    alias la 'ls -a'
    alias ll 'ls -al --git'
    alias tree 'exa -T --icons --level 3 --ignore-glob=".git"'
    alias rm 'echo Use `trash-put` instead 🤗; false'
    alias tp trash-put
    alias mdv 'rich -m --pager'
    alias ps 'ps aux'
    alias diff difft

    fish_vi_key_bindings
    bind -M insert \ca beginning-of-line
    bind -M insert \ce end-of-line
    bind -M insert \ch accept-autosuggestion
    bind -M insert \ck history-prefix-search-backward
    bind -M insert \cj history-prefix-search-forward

    bind -M insert -k f5 'asynctask -f'

    function proxy
        set winip $(grep nameserver /etc/resolv.conf | awk '{print $2}')
        sed -i '/\[ProxyList\]/,$d' ~/.config/proxychains.conf
        echo -e "[ProxyList]\nsocks5 $winip 10810" >> ~/.config/proxychains.conf
        proxychains4 -q -f ~/.config/proxychains.conf $argv
    end
end
