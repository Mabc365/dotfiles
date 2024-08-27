# Set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Import modules
Import-Module posh-git
Import-Module -Name Terminal-Icons
Import-Module PSFzf

# Set up initial Oh My Posh
$omp_config = Join-Path $PSScriptRoot ".\xube.omp.json"
oh-my-posh --init --shell pwsh --config $omp_config | Invoke-Expression

# PSReadLine configuration
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Fzf configuration
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Environment variables
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

# Aliases and Functions
Set-Alias -Name vim -Value nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias home cd
Set-Alias cr clear
Set-Alias sudo gsudo
Set-Alias update '~/.config/powershell/update.ps1'
Set-Alias r pwsh
Set-Alias e explorer
Set-Alias c cursor
Set-Alias g git
function zc { Set-Location "$HOME\.config" }
function zp { Set-Location "$HOME\.config\powershell" }
function zd { Set-Location "$HOME\github\dotfiles" }
function zdc { Set-Location "$HOME\github\dotfiles\.config "}
function zz { z .. }
function mm {
    git checkout main -- ./.config/
}
function mc {
    git checkout clone -- ./.config/
}
Set-Alias w winget
function wi { winget install }
function ws {winget search }

# Utilities
function which {
    param (
        [string]$command
    )
    Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Define global variable to track the current prompt
if (-not $global:CurrentPrompt) {
    $global:CurrentPrompt = ""
}

# Function to activate Oh My Posh
function posh {
    if ($global:CurrentPrompt -eq 'posh') {
        Write-Host "Oh My Posh is already active."
        return
    }

    # Deactivate Starship if it was previously active
    if ($global:CurrentPrompt -eq 'star') {
        Invoke-Expression (& 'C:\Program Files\starship\bin\starship.exe' init powershell --print-full-init | Out-String)
    }

    # Activate Oh My Posh
    oh-my-posh init pwsh --config $omp_config | Invoke-Expression
    $global:CurrentPrompt = 'posh'
}

# Function to activate Starship
function star {
    if ($global:CurrentPrompt -eq 'star') {
        Write-Host "Starship is already active."
        return
    }

    # Deactivate Oh My Posh if it was previously active
    if ($global:CurrentPrompt -eq 'posh') {
        oh-my-posh init pwsh --config $omp_config | Out-Null
    }

    # Activate Starship
    Invoke-Expression (& 'C:\Program Files\starship\bin\starship.exe' init powershell --print-full-init | Out-String)
    $global:CurrentPrompt = 'star'
}

# Initialize with a default prompt if desired
# posh # Uncomment this line to set a default prompt
