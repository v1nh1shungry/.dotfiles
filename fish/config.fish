if status is-interactive
    set -gx PATH ~/.local/bin $PATH

    set fish_greeting

    if command -q starship
        starship init fish | source
    end

    if command -q fnm
        fnm env --use-on-cd | source
        set -gx FNM_NODE_DIST_MIRROR https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/
    end

    if command -q bob
        set -gx PATH ~/.local/share/bob/nvim-bin $PATH
    end

    if command -q nvim
        alias vi nvim
        alias vim nvim
    end

    if command -q exa
        alias ls 'exa --icons'
        alias tree 'exa -T --icons'
    end

    alias l ls
    alias la 'ls -a'
    alias ll 'ls -al --git'

    if command -q batcat
        alias bat batcat
    end
    if type -q batdiff
        alias diff 'batdiff --delta'
    end

    if command -q fdfind
        alias fd fdfind
    end

    if string match '*WSL*' (uname -a) > /dev/null
        function proxy
            if test "$argv" = unset
                set --erase http_proxy
                set --erase https_proxy
            else if test "$argv" = host
                set winip (grep nameserver /etc/resolv.conf | awk '{print $2}')
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

        alias neovide 'neovide.exe --wsl --frame none --maximized --multigrid'
    end
end
