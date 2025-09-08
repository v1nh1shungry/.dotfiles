[private]
default:
  @just --list

bat:
  mkdir -p {{config_directory()}}/bat/themes
  ln -sf {{justfile_directory()}}/bat/config {{config_directory()}}/bat
  ln -sf {{data_directory()}}/nvim/lazy/tokyonight.nvim/extras/sublime/tokyonight_moon.tmTheme {{config_directory()}}/bat/themes
  bat cache --build

cargo:
  mkdir -p {{home_directory()}}/.cargo
  ln -sf {{justfile_directory()}}/cargo/config.toml {{home_directory()}}/.cargo

fish:
  mkdir -p {{config_directory()}}/fish
  ln -sf {{justfile_directory()}}/fish/config.fish {{config_directory()}}/fish

fontconfig:
  ln -sf {{justfile_directory()}}/fontconfig {{config_directory()}}

gdb:
  wget -P ~ https://github.com/cyrus-and/gdb-dashboard/raw/master/.gdbinit

git:
  ln -sf {{justfile_directory()}}/git/.gitconfig {{home_directory()}}

hyprland:
  ln -sf {{justfile_directory()}}/hypr {{config_directory()}}
  ln -sf {{justfile_directory()}}/rofi {{config_directory()}}
  ln -sf {{justfile_directory()}}/waybar {{config_directory()}}

kitty:
  mkdir -p {{config_directory()}}/kitty
  ln -sf {{justfile_directory()}}/kitty/base.conf {{config_directory()}}/kitty
  ln -sf {{justfile_directory()}}/kitty/kitty.conf {{config_directory()}}/kitty
  ln -sf {{justfile_directory()}}/kitty/goto_tab.py {{config_directory()}}/kitty
  kitty +kitten themes --config-file-name=base.conf Tokyo Night Moon

npm:
  echo "registry=https://npmreg.proxy.ustclug.org/" >{{home_directory()}}/.npmrc

nvim:
  ln -sf {{justfile_directory()}}/nvim {{config_directory()}}

pip:
  mkdir -p {{config_directory()}}/pip
  echo "[global]\nindex-url = https://mirrors.ustc.edu.cn/pypi/simple" >{{config_directory()}}/pip/pip.conf

starship:
  ln -sf {{justfile_directory()}}/starship/starship.toml {{config_directory()}}

tmux:
  ln -sf {{justfile_directory()}}/tmux {{config_directory()}}

yazi:
  mkdir -p {{config_directory()}}/yazi
  ln -sf {{justfile_directory()}}/yazi/package.toml {{config_directory()}}/yazi
  ln -sf {{justfile_directory()}}/yazi/theme.toml {{config_directory()}}/yazi
  ln -sf {{justfile_directory()}}/yazi/yazi.toml {{config_directory()}}/yazi
  ya pkg add BennyOe/tokyo-night

all: bat cargo fish fontconfig gdb git kitty npm nvim starship yazi
