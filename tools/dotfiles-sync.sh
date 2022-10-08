#!/usr/bin/bash

cd /home/vinh/.dotfiles
if test ! -z "$(git diff)"; then
  git add -A
  git commit -m ":arrows_counterclockwise: update $(date +'%Y.%m.%d')"
  git push origin main
fi
