#!/bin/bash

set -euo pipefail

BUILD_SYSTEM="$2"
PROJECT_NAME="$3"

cd "$1"

if [ "$BUILD_SYSTEM" = "cmake" ]; then
  git init "$PROJECT_NAME"
  cd "$PROJECT_NAME"
  mkdir src
  vim src/main.cpp +wq
  vim CMakeLists.txt +wq
elif [ "$BUILD_SYSTEM" = "xmake" ]; then
  git init "$PROJECT_NAME"
  cd "$PROJECT_NAME"
  mkdir src
  vim src/main.cpp +wq
  vim xmake.lua +wq
elif [ "$BUILD_SYSTEM" = "cargo" ]; then
  cargo new "$PROJECT_NAME"
  cd "$PROJECT_NAME"
else
  echo "unknown build system"
  exit 1
fi

cp "$HOME/.dotfiles/vim/templates/task/$BUILD_SYSTEM.ini" .tasks
cp "$HOME/.dotfiles/vim/templates/vimspector/$BUILD_SYSTEM.json" .vimspector.json
