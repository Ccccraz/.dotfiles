# Install scoop
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod get.scoop.sh | Invoke-Expression

# Basic tools for scoop
$basicApp = "7zip", "aria2", "git", "sudo"
ScoopInstall($basicApp)

# Add bucket
$bucketList = "extras", "java", "nerd-fonts", "v2raya", "dorado https://github.com/chawyehsu/dorado"
ScoopAddBucket($bucketList)

# Install applications
$basicTools = "gow", "dark", "utools", "lazygit", "wezterm", "everything", "freedownloadmanager"
$shell = "pwsh", "elvish", "starship"
$proxy = "v2raya", "clash-for-windows-np"
$academic = "zotero", "obsidian", "pandoc", "pandoc-crossref"
$pdf = "diff-pdf"
$editor = "vim", "neovim", "helix", "vscode"
$IDE = "rider", "pycharm"
$message = "qqnt", "wechat"

$environmentCCpp = "llvm", "clangd", "mingw", "make", "cmake", "xmake"
$environmentDotnet = "dotnet-sdk"
$environmentPython = "python", "micromamba", "poetry"
$environmentJava = "openjdk"
$environmentNodejs = "nvm"

$video = "mpv.net"
$fonts = "CascadiaCode-NF", "Source-Han-Sans-HC"

$appList += $basicTools
$appList += $shell
$appList += $proxy
$appList += $academic
$appList += $pdf
$appList += $editor
$appList += $IDE
$appList += $message
$appList += $environmentCCpp
$appList += $environmentDotnet
$appList += $environmentPython
$appList += $environmentJava
$appList += $environmentNodejs
$appList += $video
$appList += $fonts

ScoopInstall($appList)

# Winget only
Write-Output "Start winget flow..."
winget install Microsoft.VisualStudio.2022.Community

# Make symboliclink
New-Item -ItemType SymbolicLink "path" -Target "path"

# Function define
function ScoopInstall {
  param(
    $appList
  )
  foreach ($appName in $appList) {
    try {
      scoop install $appName
    }
    catch {
      $appName+=" install failed..."
      Write-Output $appName
    }
  }
}

function ScoopAddBucket {
  param (
    $bucketList
  )
  foreach ($bucket in $bucketList) {
    try {
      scoop bucket add $bucket
    }
    catch {
      Write-Output $bucket "can't add bucket, init failed..."
      exit
    }
  }
}