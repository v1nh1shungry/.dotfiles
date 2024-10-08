_default:
  @just --list

commit:
  git add -A
  git commit -m "update"

sync: commit
  git pull --rebase
  git push origin main

install:
  mkdir -p ~/.config/fish
  ln -s ~/.dotfiles/fish/config.fish ~/.config/fish/config.fish
  ln -s ~/.dotfiles/gdb/.gdbinit ~/.gdbinit
  ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
  ln -s ~/.dotfiles/nvim ~/.config/nvim
  ln -s ~/.dotfiles/starship/starship.toml ~/.config/starship.toml
  ln -s ~/.dotfiles/tmux ~/.config/tmux
  ln -s ~/.dotfiles/wezterm ~/.config/wezterm
