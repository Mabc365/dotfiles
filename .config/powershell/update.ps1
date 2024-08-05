#Package Updates
winget upgrade --all
scoop update

#Prompt Updates
$canConnectToGitHub = Test-Connection github.com -Count 2 -Quiet -TimeoutSeconds 5
function Update-Profile {
    if (-not $canConnectToGitHub) {
        Write-Host "Skipping profile update check. Unable to reach GitHub.com." -ForegroundColor Yellow
        return
    }

    Write-Host "Checking for profile updates..." -ForegroundColor Cyan

    try {
        $url = "https://raw.githubusercontent.com/Mabc365/dotfiles/main/.config/powershell/user_profile.ps1"
        $localProfilePath = "~/.config/powershell/user_profile.ps1"
        Write-Host "Local profile path: $localProfilePath" -ForegroundColor Gray

        $oldhash = Get-FileHash $localProfilePath
        Write-Host "Current local profile hash: $($oldhash.Hash)" -ForegroundColor Gray

        $tempFilePath = "$env:temp/user_profile.ps1"
        Write-Host "Downloading latest profile to: $tempFilePath" -ForegroundColor Gray
        Invoke-RestMethod $url -OutFile $tempFilePath

        $newhash = Get-FileHash $tempFilePath
        Write-Host "Downloaded profile hash: $($newhash.Hash)" -ForegroundColor Gray

        if ($newhash.Hash -ne $oldhash.Hash) {
            Write-Host "Hashes differ. Updating profile..." -ForegroundColor Yellow
            Copy-Item -Path $tempFilePath -Destination $localProfilePath -Force
            Write-Host "Profile has been updated. Please restart your shell to reflect changes" -ForegroundColor Magenta
        } else {
            Write-Host "Hashes match. Profile is up to date." -ForegroundColor Green
        }
    } catch {
        Write-Error "Unable to check for profile updates: $_"
    } finally {
        if (Test-Path $tempFilePath) {
            Remove-Item $tempFilePath -ErrorAction SilentlyContinue
            Write-Host "Temporary file removed." -ForegroundColor Gray
        }
    }
}

Write-Host "Starting profile update process..." -ForegroundColor Cyan
Update-Profile
Write-Host "Profile update process completed." -ForegroundColor Cyan