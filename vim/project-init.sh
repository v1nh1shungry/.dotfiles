#!/bin/bash

set -euo pipefail

BUILD_SYSTEM="$2"
PROJECT_NAME="$3"

cd "$1"

if [ "$BUILD_SYSTEM" = "cmake" ]; then
  git init "$PROJECT_NAME"
  mkdir "$PROJECT_NAME/src"
  cp "$HOME/.dotfiles/vim/project_templates/cmake/CMakeLists.txt" "$PROJECT_NAME/CMakeLists.txt"
  cp "$HOME/.dotfiles/vim/project_templates/cmake/src/main.cpp" "$PROJECT_NAME/src/main.cpp"
  sed -i "s/\$ProjectName/$PROJECT_NAME/g" "$PROJECT_NAME/CMakeLists.txt"
elif [ "$BUILD_SYSTEM" = "xmake" ]; then
  git init "$PROJECT_NAME"
  mkdir "$PROJECT_NAME/src"
  cp "$HOME/.dotfiles/vim/project_templates/xmake/xmake.lua" "$PROJECT_NAME/xmake.lua"
  cp "$HOME/.dotfiles/vim/project_templates/xmake/src/main.cpp" "$PROJECT_NAME/src/main.cpp"
  sed -i "s/\$ProjectName/$PROJECT_NAME/g" "$PROJECT_NAME/xmake.lua"
elif [ "$BUILD_SYSTEM" = "cargo" ]; then
  cargo new "$PROJECT_NAME"
else
  echo "unknown build system"
  return 1
fi

cp "$HOME/.dotfiles/vim/task_templates/$BUILD_SYSTEM.ini" "$PROJECT_NAME/.tasks"
cp "$HOME/.dotfiles/vim/vimspector/$BUILD_SYSTEM.json" "$PROJECT_NAME/.vimspector.json"
