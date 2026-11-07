# Bootstrap these dotfiles on Windows with mise.
#
#   irm https://raw.githubusercontent.com/Ccccraz/.dotfiles/main/install.ps1 | iex
#   & ([scriptblock]::Create((irm https://raw.githubusercontent.com/Ccccraz/.dotfiles/main/install.ps1))) -Preset full -DryRun
#
# Needs Developer Mode (Settings > System > For developers) so mise can create symlinks.
param(
    [ValidateSet('full')][string]$Preset = 'full',
    [switch]$DryRun
)
$ErrorActionPreference = 'Stop'

$Repo = 'https://github.com/Ccccraz/.dotfiles.git'
$Dotfiles = Join-Path $HOME '.dotfiles'

function Update-SessionPath {
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
        [Environment]::GetEnvironmentVariable('Path', 'User')
}

$devMode = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock' `
    -Name AllowDevelopmentWithoutDevLicense -ErrorAction SilentlyContinue).AllowDevelopmentWithoutDevLicense -eq 1
if (-not $devMode) {
    throw 'Enable Developer Mode (Settings > System > For developers), then run this script again.'
}

if (-not (Get-Command mise -ErrorAction SilentlyContinue)) {
    winget install --id jdx.mise --exact --silent --accept-package-agreements --accept-source-agreements
} else {
    # Bootstrap needs a recent mise; a no-op when it is already current.
    winget upgrade --id jdx.mise --exact --silent --accept-package-agreements --accept-source-agreements
}
# Scoop supplies the Maple Mono font (nerd-fonts bucket).
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Invoke-RestMethod https://get.scoop.sh | Invoke-Expression
}

# Put mise shims on the user PATH so every program sees the tools.
$shims = Join-Path $env:LOCALAPPDATA 'mise\shims'
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if (($userPath -split ';') -notcontains $shims) {
    [Environment]::SetEnvironmentVariable('Path', "$shims;$userPath", 'User')
}
Update-SessionPath

# mise links ~/.config/mise to $Dotfiles\mise; the path must be free.
$configDir = Join-Path $HOME '.config\mise'
$item = Get-Item $configDir -ErrorAction SilentlyContinue
if ($item -and -not $item.LinkType) {
    $backup = "$configDir.bak.$(Get-Date -Format yyyyMMddHHmmss)"
    Write-Host "moving $configDir to $backup"
    if (-not $DryRun) { Move-Item $configDir $backup }
}

$miseArgs = @('-E', $Preset, 'bootstrap', '--from', $Repo, '--from-dir', $Dotfiles,
    '--config-dir', 'mise', '--save-env')
if ($DryRun) { $miseArgs += '--dry-run' } else { $miseArgs += '--yes' }
mise @miseArgs
