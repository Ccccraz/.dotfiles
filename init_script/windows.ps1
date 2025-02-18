# 定义失败应用信息类
class FailedAppInfo {
  [string]$AppId
  [string]$Group
  [int]$ErrorCode
  [string]$Message
  [datetime]$Timestamp

  FailedAppInfo(
    [string]$appId,
    [string]$group,
    [int]$code,
    [string]$msg
  ) {
    $this.AppId = $appId
    $this.Group = $group
    $this.ErrorCode = $code
    $this.Message = $msg
    $this.Timestamp = Get-Date
  }
}

# 定义安装结果类
class InstallationResult {
  [int]$TotalApps
  [int]$SuccessCount = 0
  [int]$FailureCount = 0
  [System.Collections.Generic.List[FailedAppInfo]]$FailedApps = [System.Collections.Generic.List[FailedAppInfo]]::new()

  InstallationResult([int]$total) {
    $this.TotalApps = $total
  }

  [void] AddSuccess() {
    $this.SuccessCount++
  }

  [void] AddFailure(
    [string]$appId,
    [string]$group,
    [int]$code,
    [string]$msg
  ) {
    $this.FailureCount++
    $this.FailedApps.Add([FailedAppInfo]::new($appId, $group, $code, $msg))
  }

  [string] GetSummary() {
    return "总应用: $($this.TotalApps) | 成功: $($this.SuccessCount) | 失败: $($this.FailureCount)"
  }
}

$apps = [ordered]@{
  "proxy"      = @("v2rayA.v2rayA") 
  "basic"      = @(
    "Git.Git",
    "GitHub.hub", 
    "Microsoft.PowerShell", 
    "7zip.7zip", 
    "Starship.Starship", 
    "voidtools.Everything", 
    "BurntSushi.ripgrep.MSVC", 
    "Fastfetch-cli.Fastfetch", 
    "Rclone.Rclone", 
    "aria2.aria2", 
    "Yuanli.uTools", 
    "sharkdp.fd", 
    "SoftDeluxe.FreeDownloadManager", 
    "Microsoft.PowerToys", 
    "M2Team.NanaZip.Preview", 
    "Microsoft.WindowsTerminal"
  )
  "wsl"        = @("Microsoft.WSL")
  "ai"         = @("ByteDance.Doubao", "Bin-Huang.Chatbox")
  "cloudDrive" = @("Alibaba.aDrive")
  "game"       = @("Valve.Steam")
  "streaming"  = @("MoonlightGameStreamingProject.Moonlight")
  "im"         = @("Tencent.QQ.NT", "Tencent.WeChat.Universal")
  "dotnet"     = @("Microsoft.DotNet.SDK.9", "Microsoft.DotNet.SDK.8")
  "tilingWM"   = @("glzr-io.glazewm", "AmN.yasb")
  "editor"     = @("Neovim.Neovim", "Microsoft.VisualStudioCode")
  "IDE"        = @("JetBrains.Rider", "Microsoft.VisualStudio.2022.Community")
  "cpp"        = @("Xmake-io.Xmake", "LLVM.LLVM", "LLVM.clangd")
  "python"     = @("Mamba.Micromamba", "Python.Python.3.13")
  "rust"       = @("Rustlang.Rustup")
  "art"        = @("BlenderFoundation.Blender")
  "docker"     = @("Docker.DockerDesktop")
  "academic"   = @("DigitalScholar.Zotero", "Obsidian.Obsidian")
  "java"       = @("BellSoft.LibericaJDK.17")
  "frontend"   = @("Volta.Volta", "Ruihu.Apifox")
}

# $unity = @(
#   "Unity.UnityHub"
#   "Unity.Unity.2020"
#   "Version"
#   "2022.3.14f1"
# )

function Install-Winget {
  param(
    [Parameter(Mandatory)]
    [System.Collections.Specialized.OrderedDictionary]$AppGroups,
        
    [Parameter(Mandatory)]
    [InstallationResult]$Result
  )

  $globalCounter = 0
  $totalApps = ($AppGroups.Values | Measure-Object -Property Count -Sum).Sum

  foreach ($groupEntry in $AppGroups.GetEnumerator()) {
    $groupName = $groupEntry.Key
    $applications = $groupEntry.Value

    foreach ($appId in $applications) {
      $globalCounter++
      Write-Host "`n[$globalCounter/$totalApps] 正在处理 $appId ($groupName)" -ForegroundColor Cyan

      try {
        $process = Start-Process -FilePath winget -ArgumentList @(
          "install",
          "--id", $appId,
          "--exact",
          "--accept-package-agreements",
          "--accept-source-agreements"
        ) -PassThru -Wait -NoNewWindow

        switch ($process.ExitCode) {
          0 {
            $Result.AddSuccess()
            Write-Host "[√] $appId 安装成功" -ForegroundColor Green
          }
          -1978335189 {
            # 已安装状态码
            $Result.AddSuccess()
            Write-Host "[!] $appId 已存在" -ForegroundColor DarkGray
          }
          default {
            $Result.AddFailure($appId, $groupName, $process.ExitCode, "退出码: $($process.ExitCode)")
            Write-Host "[×] 安装失败 (错误码: $_)" -ForegroundColor Red
          }
        }
      }
      catch {
        $Result.AddFailure($appId, $groupName, -1, $_.Exception.Message)
        Write-Host "[×] 执行异常: $_" -ForegroundColor Red
      }
    }
  }
}

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Host "请以管理员权限运行！" -ForegroundColor Red
  exit 1
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Host "未检测到 winget" -ForegroundColor Red
  exit 1
}

# 初始化结果对象
$totalApps = ($apps.Values | Measure-Object -Property Count -Sum).Sum
$result = [InstallationResult]::new($totalApps)
Write-Host "$totalApps 个应用程序将被安装" -ForegroundColor Red

# 执行安装
Install-Winget -AppGroups $apps -Result $result

# 生成报告
Write-Host "`nWinget 安装报告: " -ForegroundColor Yellow
Write-Host $result.GetSummary() -ForegroundColor Cyan

if ($result.FailedApps.Count -gt 0) {
  Write-Host "`n失败详情: " -ForegroundColor Red
  $result.FailedApps | ForEach-Object {
    $info = "[$($_.Group)] $($_.AppId) " +
    "错误码: $($_.ErrorCode) " +
    "时间: $($_.Timestamp.ToString('HH:mm:ss')) " +
    "信息: $($_.Message)"
    Write-Host $info -ForegroundColor Red
  }
}

# 生成日志文件
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$result.FailedApps | ConvertTo-Json | Out-File "InstallErrors_$timestamp.json"

Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
scoop install wget curl

# 创建 .gitconfig 的符号链接
$gitconfigPath = Join-Path $HOME .gitconfig
New-Item -ItemType Directory -Path (Split-Path $gitconfigPath -Parent) -Force | Out-Null
New-Item -Type SymbolicLink -Path $gitconfigPath -Target $HOME\.dotfiles\tools\git\.gitconfig

# 创建 PowerShell Profile 的符号链接
$profileParent = Split-Path $PROFILE -Parent
New-Item -ItemType Directory -Path $profileParent -Force | Out-Null
New-Item -Type SymbolicLink -Path $PROFILE -Target $HOME\.dotfiles\shell\PowerShell\Microsoft.PowerShell_profile.ps1

# 创建 starship.toml 的符号链接
$starshipDir = Join-Path $HOME .config
New-Item -ItemType Directory -Path $starshipDir -Force | Out-Null
New-Item -Type SymbolicLink -Path (Join-Path $starshipDir starship.toml) -Target $HOME\.dotfiles\shell\starship.toml