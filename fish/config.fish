if status is-interactive
    fish_add_path ~/.cargo/bin
    fish_add_path ~/.local/bin

    set fish_greeting

    starship init fish | source

    source /home/vinh/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true

    fnm env --use-on-cd | source
    set -gx FNM_NODE_DIST_MIRROR https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/

    set -gx LESS_TERMCAP_mb (set_color -o red)
    set -gx LESS_TERMCAP_md (set_color -o 5fafd7)
    set -gx LESS_TERMCAP_so (set_color 949494)
    set -gx LESS_TERMCAP_us (set_color -u afafd7)

    alias vi nvim
    alias nv nvim
    alias vim nvim
    alias bat 'bat --theme Dracula'
    alias grep 'grep --color=auto'
    alias ls 'exa --icons'
    alias l ls
    alias la 'ls -a'
    alias ll 'ls -al --git'
    alias tree 'exa -T --icons --level 3 --ignore-glob=".git"'
    alias rm 'echo Use `trash-put` instead 🤗; false'
    alias diff difft
    alias neovide 'neovide.exe --wsl --maximized'

    function proxy
        if test "$argv" = unset
            set --erase http_proxy
            set --erase https_proxy
        else if test "$argv" = host
            set winip $(grep nameserver /etc/resolv.conf | awk '{print $2}')
            set -gx http_proxy "http://$winip:10809"
            set -gx https_proxy "http://$winip:10809"
        else if test "$argv" = github
            set -gx http_proxy "http://127.0.0.1:38457"
            set -gx https_proxy "http://127.0.0.1:38457"
        else
            echo 'unknown subcommands:' "$argv"
            false
        end
    end
end
