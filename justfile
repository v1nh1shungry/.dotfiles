[private]
default:
  @just --list

bat:
  ln -sf {{justfile_directory()}}/bat {{config_directory()}}
  bat cache --build

cargo:
  mkdir -p {{home_directory()}}/.cargo
  ln -sf {{justfile_directory()}}/cargo/config.toml {{home_directory()}}/.cargo
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

fish:
  mkdir -p {{config_directory()}}/fish
  ln -sf {{justfile_directory()}}/fish/config.fish {{config_directory()}}/fish

fontconfig:
  ln -sf {{justfile_directory()}}/fontconfig {{config_directory()}}

gdb:
  ln -sf {{justfile_directory()}}/gdb/.gdbinit {{home_directory()}}

git:
  ln -sf {{justfile_directory()}}/git/.gitconfig {{home_directory()}}

go-musicfox:
  mkdir -p {{config_directory()}}/go-musicfox
  ln -sf {{justfile_directory()}}/go-musicfox/go-musicfox.ini {{config_directory()}}/go-musicfox

hyprland:
  ln -sf {{justfile_directory()}}/hypr {{config_directory()}}
  ln -sf {{justfile_directory()}}/waybar {{config_directory()}}
  ln -sf {{justfile_directory()}}/rofi {{config_directory()}}
  echo "--enable-wayland-ime" >{{config_directory()}}/qq-flags.conf

kitty:
  mkdir -p {{config_directory()}}/kitty
  ln -sf {{justfile_directory()}}/kitty/base.conf {{config_directory()}}/kitty
  ln -sf {{justfile_directory()}}/kitty/kitty.conf {{config_directory()}}/kitty
  ln -sf {{justfile_directory()}}/kitty/goto_tab.py {{config_directory()}}/kitty

npm:
  echo "registry=https://npmreg.proxy.ustclug.org/" >{{home_directory()}}/.npmrc

nvim:
  ln -sf {{justfile_directory()}}/nvim {{config_directory()}}

pip:
  mkdir -p {{config_directory()}}/pip
  echo -e "[global]\nindex-url = https://mirrors.ustc.edu.cn/pypi/simple" >{{config_directory()}}/pip/pip.conf

starship:
  ln -sf {{justfile_directory()}}/starship/starship.toml {{config_directory()}}

tmux:
  ln -sf {{justfile_directory()}}/tmux {{config_directory()}}

yazi:
  ln -sf {{justfile_directory()}}/yazi {{config_directory()}}

all: bat cargo fish fontconfig gdb git kitty npm nvim starship yazi
