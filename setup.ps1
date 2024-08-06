# Confirmation Prompt
$confirmation = Read-Host "Are you sure you want to run this script? This will erase your current configuration and replace it. Type 'yes' to continue or 'no' to exit."

if ($confirmation -ne 'yes') {
    Write-Output "Operation cancelled. No changes were made."
    exit
}

$configDir = "$env:USERPROFILE\.config"
if (Test-Path $configDir) {
    Write-Output "Attempting to delete existing .config directory..."
    try {
        # Check if the directory is in use
        $inUse = Get-Process | Where-Object { $_.Modules.FileName -like "$configDir\*" }
        if ($inUse) {
            Write-Output "The .config directory is in use by another process. Please close any applications using it and try again."
            exit
        }

        Remove-Item -Path $configDir -Recurse -Force
        Write-Output ".config directory deleted."
    } catch {
        Write-Output "Failed to delete .config directory. Error: $_"
        Write-Output "Please ensure you have the necessary permissions or manually remove the directory."
        exit
    }
} else {
    Write-Output ".config directory does not exist. Proceeding with cloning..."
}

# Cloning Repository
Write-Output "Cloning the repository..."
try {
    gsudo git clone -b clone https://github.com/Mabc365/dotfiles.git $configDir
    Write-Output "Repository cloned successfully."
} catch {
    Write-Output "Failed to clone repository. Please check if the .config directory was deleted correctly or manually resolve any issues."
    exit
}

# Function to Check if Scoop is Installed
function Is-ScoopInstalled {
    try {
        $scoopVersion = scoop --version
        return $true
    } catch {
        return $false
    }
}

# Check if Scoop is installed
if (Is-ScoopInstalled) {
    Write-Output "Scoop is already installed. Skipping Scoop installation."
} else {
    Write-Output "Scoop is not installed. Installing Scoop..."
    iwr -useb get.scoop.sh | iex
    Write-Output "Scoop installation complete."
}

# Install Scoop packages
Write-Output "Installing Scoop packages..."
scoop install curl jq gcc nvm fzf

# Installing Dependencies
Write-Output "Installing dependencies..."
winget install -e --id Git.Git
winget install Neovim.Neovim
winget install junegunn.fzf
winget install gerardog.gsudo
winget install JEsseDuffield.lazygit
winget install --id GitHub.cli

# Setting Configuration
Write-Output "Copy the following command and ensure that you put the dollar sign immediately before 'env':"
Write-Output ". $ env:USERPROFILE\.config\powershell\user_profile.ps1"
pause
nvim $PROFILE.CurrentUserCurrentHost

# oh-my-posh
Write-Output "Installing oh-my-posh and related modules..."
Install-Module posh-git -Scope CurrentUser -Force
Install-Module oh-my-posh -Scope CurrentUser -Force
winget install JanDeDobbeleer.OhMyPosh
pwsh

# Terminal-Icons
Write-Output "Installing Terminal-Icons module..."
Install-Module -Name Terminal-Icons -Repository PSGallery -Force
Import-Module Terminal-Icons

# z directory jumper
Write-Output "Installing z module..."
Install-Module -Name z -Force

# PSReadLine | Command History
Write-Output "Installing PSReadLine module and configuring settings..."
Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# PSFzf | fuzzy finder | Recent File History Finder
Write-Output "Installing PSFzf module and configuring settings..."
Install-Module -Name PSFzf -Scope CurrentUser -Force
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

Write-Output "Script execution complete."
