[private]
default:
    @just --list

alacritty:
    mkdir -p {{ config_directory() }}/alacritty
    ln -sf {{ justfile_directory() }}/alacritty/alacritty.toml {{ config_directory() }}/alacritty
    ln -sf {{ data_directory() }}/nvim/lazy/tokyonight.nvim/extras/alacritty/tokyonight_moon.toml {{ config_directory() }}/alacritty/theme.toml

atuin:
    ln -sf {{ justfile_directory() }}/atuin {{ config_directory() }}

bat:
    mkdir -p {{ config_directory() }}/bat/themes
    ln -sf {{ justfile_directory() }}/bat/config {{ config_directory() }}/bat
    ln -sf {{ data_directory() }}/nvim/lazy/tokyonight.nvim/extras/sublime/tokyonight_moon.tmTheme {{ config_directory() }}/bat/themes
    bat cache --build

brave:
    echo "--enable-features=TouchpadOverscrollHistoryNavigation,UseOzonePlatform" >{{ justfile_directory() }}/brave-flags.conf

cargo:
    mkdir -p {{ home_directory() }}/.cargo
    ln -sf {{ justfile_directory() }}/cargo/config.toml {{ home_directory() }}/.cargo

claude:
    mkdir -p {{ home_directory() }}/.claude
    ln -sf {{ justfile_directory() }}/claude/settings.json {{ home_directory() }}/.claude

electron program:
    echo "--enable-wayland-ime" >{{ config_directory() }}/{{ program }}-flags.conf

fish:
    mkdir -p {{ config_directory() }}/fish
    ln -sf {{ justfile_directory() }}/fish/config.fish {{ config_directory() }}/fish
    ln -sf {{ justfile_directory() }}/fish/fish_plugins {{ config_directory() }}/fish

fontconfig:
    ln -sf {{ justfile_directory() }}/fontconfig {{ config_directory() }}

gdb:
    wget -P ~ https://github.com/cyrus-and/gdb-dashboard/raw/master/.gdbinit

git:
    ln -sf {{ justfile_directory() }}/git/.gitconfig {{ home_directory() }}

lazygit:
    ln -sf {{ justfile_directory() }}/lazygit {{ config_directory() }}

niri:
    ln -sf {{ justfile_directory() }}/niri {{ config_directory() }}

npm:
    echo "registry=https://npmreg.proxy.ustclug.org/" >{{ home_directory() }}/.npmrc

nvim:
    ln -sf {{ justfile_directory() }}/nvim {{ config_directory() }}

pip:
    mkdir -p {{ config_directory() }}/pip
    echo "[global]\nindex-url = https://mirrors.ustc.edu.cn/pypi/simple" >{{ config_directory() }}/pip/pip.conf

starship:
    ln -sf {{ justfile_directory() }}/starship/starship.toml {{ config_directory() }}

tmux:
    ln -sf {{ justfile_directory() }}/tmux {{ config_directory() }}

yazi:
    mkdir -p {{ config_directory() }}/yazi
    ln -sf {{ justfile_directory() }}/yazi/package.toml {{ config_directory() }}/yazi
    ln -sf {{ justfile_directory() }}/yazi/theme.toml {{ config_directory() }}/yazi
    ln -sf {{ justfile_directory() }}/yazi/yazi.toml {{ config_directory() }}/yazi
    ya pkg add BennyOe/tokyo-night

all: atuin bat cargo fish fontconfig gdb git lazygit npm nvim pip starship tmux yazi

wayland: brave niri
