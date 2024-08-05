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

    try {
        $url = "https://raw.githubusercontent.com/Mabc365/dotfiles/main/.config/powershell/user_profile.ps1"
        $localProfilePath = "~/.config/powershell/user_profile.ps1"
        $oldhash = Get-FileHash $localProfilePath
        $tempFilePath = "$env:temp/user_profile.ps1"
        Invoke-RestMethod $url -OutFile $tempFilePath
        $newhash = Get-FileHash $tempFilePath
        if ($newhash.Hash -ne $oldhash.Hash) {
            Copy-Item -Path $tempFilePath -Destination $localProfilePath -Force
            Write-Host "Profile has been updated. Please restart your shell to reflect changes" -ForegroundColor Magenta
        }
    } catch {
        Write-Error "Unable to check for profile updates"
    } finally {
        Remove-Item $tempFilePath -ErrorAction SilentlyContinue
    }
}
Update-Profile