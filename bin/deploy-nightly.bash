#!/usr/bin/bash

cd ~/.dotfiles || exit
git checkout nightly

pacman -Qqen > ./pacman/packages-repository.txt
pacman -Qqem > ./pacman/packages-AUR.txt

pipx list --short > ./pip/packages-pipx.txt

if test ! -z "$(git diff)"; then
  git add -A
  git commit -m ":arrows_counterclockwise: update $(date +'%Y.%m.%d')"
  git push origin nightly
fi
