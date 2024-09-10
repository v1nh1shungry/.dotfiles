default:
  @just --list

sync:
  git add -A
  git commit -m "update"
  git pull --rebase
  git push origin main

install:
  mkdir -p ~/.config/fish
  ln -s ~/.dotfiles/fish/config.fish ~/.config/fish/config.fish
  ln -s ~/.dotfiles/gdb/.gdbinit ~/.gdbinit
  ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
  ln -s ~/.dotfiles/nvim ~/.config/nvim
  ln -s ~/.dotfiles/starship/starship.toml ~/.config/starship.toml
  ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
  ln -s ~/.dotfiles/wezterm ~/.config/wezterm
