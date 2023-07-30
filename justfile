deploy-wsl:
  git checkout main
  pacman -Qqen > ./pacman/packages-repository.txt
  pacman -Qqem > ./pacman/packages-AUR.txt
  pipx list --short > ./pipx/packages.txt
  cp /mnt/c/Users/lenovo/.ideavimrc idea/.ideavimrc
  cp /mnt/c/Users/lenovo/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1 powershell/Microsoft.PowerShell_profile.ps1
  cp /mnt/d/scoop/persist/vscode/data/user-data/User/settings.json vscode/settings.json
  git add -A
  git commit -m "update"
  git push origin main

deploy-ubuntu:
  git checkout main
  pipx list --short > ./pipx/packages.txt
  git add -A
  git commit -m "update"
  git push origin main
