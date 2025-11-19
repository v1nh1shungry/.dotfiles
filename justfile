__default:
    @just --list

theme := "tokyonight_moon"

_check-theme:
    test -d {{ data_directory() }}/nvim/lazy/tokyonight.nvim/extras

alacritty: _check-theme
    ln -sf {{ justfile_directory() }}/alacritty {{ config_directory() }}

bat: _check-theme
    mkdir -p {{ config_directory() }}/bat/themes
    ln -sf {{ justfile_directory() }}/bat/config {{ config_directory() }}/bat
    ln -sf {{ data_directory() }}/nvim/lazy/tokyonight.nvim/extras/sublime/{{ theme }}.tmTheme {{ config_directory() }}/bat/themes
    bat cache --build

brave:
    echo "--enable-features=TouchpadOverscrollHistoryNavigation,UseOzonePlatform" >{{ justfile_directory() }}/brave-flags.conf

btop: _check-theme
    test -e {{ config_directory() }}/btop/btop.conf
    -rm -r {{ config_directory() }}/btop/themes
    ln -sf {{ data_directory() }}/nvim/lazy/tokyonight.nvim/extras/btop {{ config_directory() }}/btop/themes
    sed -i 's/^color_theme = "Default"$/color_theme = "{{ theme }}"/' {{ config_directory() }}/btop/btop.conf
    sed -i 's/^vim_keys = False$/vim_keys = True/' {{ config_directory() }}/btop/btop.conf

cargo:
    mkdir -p {{ home_directory() }}/.cargo
    ln -sf {{ justfile_directory() }}/cargo/config.toml {{ home_directory() }}/.cargo

claude:
    mkdir -p {{ home_directory() }}/.claude
    ln -sf {{ justfile_directory() }}/claude/settings.json {{ home_directory() }}/.claude

fish:
    mkdir -p {{ config_directory() }}/fish
    ln -sf {{ justfile_directory() }}/fish/config.fish {{ config_directory() }}/fish
    ln -sf {{ justfile_directory() }}/fish/fish_plugins {{ config_directory() }}/fish

fontconfig:
    ln -sf {{ justfile_directory() }}/fontconfig {{ config_directory() }}

foot: _check-theme
    ln -sf {{ justfile_directory() }}/foot {{ config_directory() }}

gdb:
    wget -P ~ https://github.com/cyrus-and/gdb-dashboard/raw/master/.gdbinit

git: _check-theme
    ln -sf {{ justfile_directory() }}/git/.gitconfig {{ home_directory() }}
    mkdir -p {{ config_directory() }}/git
    ln -sf {{ justfile_directory() }}/git/ignore {{ config_directory() }}/git

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

waylandify-electron-app program:
    echo "--enable-wayland-ime" >{{ config_directory() }}/{{ program }}-flags.conf

yazi:
    mkdir -p {{ config_directory() }}/yazi
    ln -sf {{ justfile_directory() }}/yazi/yazi.toml {{ config_directory() }}/yazi
    ln -sf {{ data_directory() }}/nvim/lazy/tokyonight.nvim/extras/yazi/{{ theme }}.toml {{ config_directory() }}/yazi/theme.toml

zathura: _check-theme
    mkdir -p {{ config_directory() }}/zathura
    ln -sf {{ data_directory() }}/nvim/lazy/tokyonight.nvim/extras/zathura/{{ theme }}.zathurarc {{ config_directory() }}/zathura/zathurarc
