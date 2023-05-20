deploy-github:
  git checkout main
  pacman -Qqen > ./pacman/packages-repository.txt
  pacman -Qqem > ./pacman/packages-AUR.txt
  pipx list --short > ./pip/packages-pipx.txt
  cp /mnt/c/Users/lenovo/.ideavimrc idea/.ideavimrc
  cp /mnt/c/Users/lenovo/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1 powershell/Microsoft.PowerShell_profile.ps1
  git add -A
  git commit -m ":arrows_counterclockwise: update $(date +'%Y.%m.%d')"
  git push origin main
