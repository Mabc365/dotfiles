#Package Updates
#winget upgrade --all
#scoop update

#Prompt Updates
$canConnectToGitHub = Test-Connection github.com -Count 2 -Quiet -TimeoutSeconds 5

function Update-Config {
    param (
        [string]$repoUrl = "https://github.com/Mabc365/dotfiles.git",
        [string]$localConfigPath = "~/.config",
        [string]$repoConfigPath = ".config"
    )

    if (-not $canConnectToGitHub) {
        Write-Host "Skipping config update check. Unable to reach GitHub.com." -ForegroundColor Yellow
        return
    }

    Write-Host "Checking for config updates..." -ForegroundColor Cyan

    try {
        $tempRepoPath = "$env:temp\dotfiles"
        if (Test-Path $tempRepoPath) {
            Remove-Item -Recurse -Force $tempRepoPath
        }

        Write-Host "Cloning repository to: $tempRepoPath" -ForegroundColor Gray
        git clone $repoUrl $tempRepoPath

        $repoConfigFullPath = Join-Path $tempRepoPath $repoConfigPath
        if (-not (Test-Path $repoConfigFullPath)) {
            Write-Error "Config folder not found in the repository: $repoConfigFullPath"
            return
        }

        $localConfigFullPath = (Resolve-Path $localConfigPath).Path

        $repoFiles = Get-ChildItem -Recurse -File $repoConfigFullPath
        foreach ($repoFile in $repoFiles) {
            $relativePath = $repoFile.FullName.Substring($repoConfigFullPath.Length)
            $localFilePath = Join-Path $localConfigFullPath $relativePath

            if (Test-Path $localFilePath) {
                $localContent = Get-Content -Path $localFilePath -Raw
                $repoContent = Get-Content -Path $repoFile.FullName -Raw

                if ($localContent -ne $repoContent) {
                    Write-Host "Contents differ for $relativePath. Updating file..." -ForegroundColor Yellow
                    Remove-Item -Path $localFilePath -Force -ErrorAction SilentlyContinue
                    Copy-Item -Path $repoFile.FullName -Destination $localFilePath -Force
                    Write-Host "File $relativePath has been updated." -ForegroundColor Magenta
                } else {
                    Write-Host "Contents match for $relativePath. File is up to date." -ForegroundColor Green
                }
            } else {
                Write-Host "Local file $relativePath does not exist. Creating file..." -ForegroundColor Yellow
                Copy-Item -Path $repoFile.FullName -Destination $localFilePath -Force
                Write-Host "File $relativePath has been created." -ForegroundColor Magenta
            }
        }
    } catch {
        Write-Error "Unable to check for config updates: $_"
    } finally {
        if (Test-Path $tempRepoPath) {
            Remove-Item -Recurse -Force $tempRepoPath
            Write-Host "Temporary repository removed." -ForegroundColor Gray
        }
    }
}

Write-Host "Starting config update process..." -ForegroundColor Cyan
Update-Config
Write-Host "Config update process completed." -ForegroundColor Cyan
