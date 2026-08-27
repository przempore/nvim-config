# PowerShell installation script for Windows
# Usage: .\install.ps1 [repository-url or path]

param(
    [string]$Source = ""
)

Write-Host "Neovim Configuration Installer" -ForegroundColor Green
Write-Host "================================`n" -ForegroundColor Green

if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Neovim is not installed!" -ForegroundColor Red
    Write-Host "`nPlease install Neovim first:"
    Write-Host "  - Using winget: winget install Neovim.Neovim"
    Write-Host "  - Using scoop: scoop install neovim"
    Write-Host "  - Using chocolatey: choco install neovim"
    Write-Host "  - Or download from: https://github.com/neovim/neovim/releases"
    exit 1
}

$nvimVersion = & nvim --version | Select-Object -First 1
Write-Host "✓ Neovim found: $nvimVersion" -ForegroundColor Green

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Error: git is not installed!" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Git found" -ForegroundColor Green

$configDir = "$env:LOCALAPPDATA\nvim"

if (Test-Path $configDir) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupDir = "${configDir}.backup.$timestamp"
    Write-Host "`nWarning: Existing Neovim config found" -ForegroundColor Yellow
    Write-Host "Backing up to: $backupDir" -ForegroundColor Yellow
    Move-Item $configDir $backupDir
}

if ($Source) {
    Write-Host "`nInstalling from: $Source" -ForegroundColor Green
    if ($Source -match "^http|^git@") {
        git clone $Source $configDir
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error: Failed to clone repository" -ForegroundColor Red
            exit 1
        }
    } else {
        Copy-Item -Path $Source -Destination $configDir -Recurse
    }
} else {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    if (Test-Path "$scriptDir\init.lua") {
        Write-Host "`nInstalling from current directory" -ForegroundColor Green
        New-Item -ItemType Directory -Force -Path $configDir | Out-Null
        Copy-Item -Path "$scriptDir\*" -Destination $configDir -Recurse -Force
    } else {
        Write-Host "Error: Please provide repository URL or run from config directory" -ForegroundColor Red
        Write-Host "Usage: .\install.ps1 [repository-url or path]"
        exit 1
    }
}

Write-Host "`n✓ Configuration installed to: $configDir" -ForegroundColor Green

Write-Host "`nStarting Neovim to initialize config..." -ForegroundColor Green
Write-Host "  vim.pack will install missing plugins on first start" -ForegroundColor Gray
Write-Host "  Existing plugins may be migrated to native start packages" -ForegroundColor Gray
Write-Host ""

Start-Sleep -Seconds 2

& nvim --headless "+qa"
$firstExitCode = $LASTEXITCODE

# A first run can migrate plugins from opt to start packages. Start packages are
# loaded before init.lua, so validate once more after that migration completes.
& nvim --headless "+qa"

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✓ Configuration validated successfully!" -ForegroundColor Green
} else {
    Write-Host "`nWarning: Headless validation reported an issue" -ForegroundColor Yellow
    if ($firstExitCode -ne 0) {
        Write-Host "The first validation pass also reported an issue" -ForegroundColor Yellow
    }
    Write-Host "Run 'nvim' and check ':messages' for details" -ForegroundColor Yellow
}

Write-Host "`nInstallation complete!" -ForegroundColor Green
Write-Host "Run 'nvim' to start using your new configuration`n"
Write-Host "For more information, see the README.md"
