if status is-interactive
    set -gx PATH ~/.local/bin $PATH

    set fish_greeting

    set -gx PATH ~/.cargo/bin $PATH

    starship init fish | source

    fnm env --use-on-cd | source
    set -gx FNM_NODE_DIST_MIRROR https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/

    set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
    set -gx PATH $HOME/.cabal/bin /home/vinh/.ghcup/bin $PATH

    set -gx LESS_TERMCAP_mb (set_color -o red)
    set -gx LESS_TERMCAP_md (set_color -o 5fafd7)
    set -gx LESS_TERMCAP_so (set_color 949494)
    set -gx LESS_TERMCAP_us (set_color -u afafd7)

    alias vi nvim
    alias vim nvim
    alias ls 'exa --icons'
    alias l ls
    alias la 'ls -a'
    alias ll 'ls -al --git'
    alias tree 'exa -T --icons'
    alias diff 'batdiff --delta'
    alias tldr 'tldr --pager'

    function proxy
        if test "$argv" = unset
            set --erase http_proxy
            set --erase https_proxy
        else if test "$argv" = host
            set winip $(grep nameserver /etc/resolv.conf | awk '{print $2}')
            set -gx http_proxy "http://$winip:7890"
            set -gx https_proxy "http://$winip:7890"
        else if test "$argv" = github
            set -gx http_proxy "http://127.0.0.1:38457"
            set -gx https_proxy "http://127.0.0.1:38457"
        else
            echo 'unknown subcommands:' "$argv"
            false
        end
    end
end
