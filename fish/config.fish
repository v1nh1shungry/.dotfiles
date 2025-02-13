if status is-interactive
    set -gx LANG "en_US.UTF-8"
    set -gx LANGUAGE "en_US.UTF-8"
    set -gx LC_ALL "en_US.UTF-8"

    set -gx EDITOR nvim

    set fish_greeting

    if test -d ~/.local/bin
        fish_add_path -g ~/.local/bin
    end

    if test -d ~/.cargo
        set -gx RUSTUP_UPDATE_ROOT https://mirrors.ustc.edu.cn/rust-static/rustup
        set -gx RUSTUP_DIST_SERVER https://mirrors.ustc.edu.cn/rust-static
        fish_add_path -g ~/.cargo/bin
    end

    if test -d ~/.spicetify
        fish_add_path -g ~/.spicetify
    end

    if command -q starship
        starship init fish | source
    end

    if command -q fnm
        fnm env --use-on-cd | source
        set -gx FNM_NODE_DIST_MIRROR https://mirrors.ustc.edu.cn/node/
    end

    if command -q nvim
        alias vi nvim
        alias vim nvim
    end

    alias l ls
    alias la 'ls -a'
    alias ll 'ls -al'

    if command -q eza
        alias ls 'eza --icons'
        alias tree 'eza -T --icons'
    end

    if command -q zoxide
        zoxide init fish | source
        alias cd "echo 'use `z` instead'; false"
    end

    if test -d ~/.local/kitty.app
        fish_add_path -g ~/.local/kitty.app/bin
        alias kitty-update "curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"
    end

    if command -q kitty
        alias icat 'kitty +kitten icat'
    end

    if command -q yazi
        function y
            set tmp (mktemp -t "yazi-cwd.XXXXXX")
            yazi $argv --cwd-file="$tmp"
            if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
                builtin cd -- "$cwd"
            end
            rm -f -- "$tmp"
        end
    end
end
