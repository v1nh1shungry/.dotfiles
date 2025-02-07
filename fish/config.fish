if status is-interactive
    set -gx LANG "en_US.UTF-8"
    set -gx LANGUAGE "en_US.UTF-8"
    set -gx LC_ALL "en_US.UTF-8"

    set fish_greeting

    if test -d ~/.local/bin
        fish_add_path ~/.local/bin
    end

    if test -d ~/.rustup || command -q rustup
        set -gx RUSTUP_UPDATE_ROOT https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
        set -gx RUSTUP_DIST_SERVER https://mirrors.tuna.tsinghua.edu.cn/rustup
        fish_add_path ~/.cargo/bin
    end

    if test -d ~/.spicetify
        fish_add_path ~/.spicetify
    end

    if command -q starship
        starship init fish | source
    end

    if command -q fnm
        fnm env --use-on-cd | source
        set -gx FNM_NODE_DIST_MIRROR https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/
    end

    if command -q nvim
        alias vi nvim
        alias vim nvim
    end

    if command -q eza
        alias ls 'eza --icons'
        alias tree 'eza -T --icons'
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

    if command -q ncdu
        alias ncdu 'ncdu --color dark'
    end

    if command -q zoxide
        zoxide init fish | source
        function cd
            echo 'use `z` instead'
            return 1
        end
    end

    if command -q kitty
        alias icat 'kitty +kitten icat'
    end
end
