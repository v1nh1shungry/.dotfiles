if ! status is-interactive
    return
end

set -x LANG "en_US.UTF-8"
set -x LANGUAGE "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"

set fish_greeting

if test -d ~/.local/bin
    fish_add_path -g ~/.local/bin
end

set -x LESS -rF

if command -q atuin
    atuin init fish --disable-up-arrow | source
end

if test -d ~/.cargo
    set -x RUSTUP_UPDATE_ROOT https://mirrors.ustc.edu.cn/rust-static/rustup
    set -x RUSTUP_DIST_SERVER https://mirrors.ustc.edu.cn/rust-static
    fish_add_path -g ~/.cargo/bin
end

if command -q eza
    alias ls "eza --icons --hyperlink"
end

if command -q fnm
    fnm env --use-on-cd | source
    set -x FNM_NODE_DIST_MIRROR https://mirrors.ustc.edu.cn/node/
end

if test -e ~/.local/share/nvim/lazy/fzf/bin/fzf
    fish_add_path -g ~/.local/share/nvim/lazy/fzf/bin
end

if command -q fzf && command -q delta
    set fzf_diff_highlighter "delta --paging=never --width=20"
end

abbr l ls
alias la "ls -a"
alias ll "ls -al"

if command -q nvim
    set -x EDITOR $(which nvim)
    set -x VISUAL $EDITOR
    set -x SUDO_EDITOR $EDITOR

    abbr vi nvim
    abbr vim nvim

    set -x MANPAGER "nvim +Man!"
end

if command -q rg
    abbr grep rg
end

if test -d ~/.spicetify
    fish_add_path -g ~/.spicetify
end

if command -q starship
    starship init fish | source
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

if command -q zoxide
    zoxide init fish | source
    abbr cd z
end

fish_add_path /home/scutech/.spicetify
