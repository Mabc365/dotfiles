#Cloning Repository
git clone 

# Installing Scoop
iwr -useb get.scoop.sh | iex
pwsh
scoop install curl jq gcc nvm fzf

#Installing Dependencies
winget install -e --id Git.Git
winget install Neovim.Neovim
winget install junegunn.fzf
winget install gerardog.gsudo
winget install JEsseDuffield.lazygit
winget install --id GitHub.cli

#Setting Configuration
Write-Output Copy-This And-Please-Insure-That-You-Put-The-Dollar-Sign-Immediately-Before-env: ". $ env:USERPROFILE\.config\powershell\user_profile.ps1"
pause
nvim $PROFILE.CurrentUserCurrentHost

#oh-my-posh
Install-Module posh-git -Scope CurrentUser -Force
Install-Module oh-my-posh -Scope CurrentUser -Force
winget install JanDeDobbeleer.OhMyPosh
pwsh

#Terminal-Icons
Install-Module -Name Terminal-Icons -Repository PSGallery -Force
Import-Module Terminal-Icons

#z directory jumper
Install-Module -Name z -Force

#PSReadLine | Command History
Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

#PSFzf | fuzzy finder | Recent File History Finder
Install-Module -Name PSFzf -Scope CurrentUser -Force
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
