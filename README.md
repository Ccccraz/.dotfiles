# dotfiles

我的配置文件仓库,用 [mise bootstrap](https://mise.jdx.dev/bootstrap.html) 声明式管理:系统包、CLI 工具、配置文件链接、登录 shell 都写在 `mise/` 下。

## 安装

macOS / Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/Ccccraz/.dotfiles/main/install.sh | bash -s -- --preset full
```

Windows(先在 设置 → 系统 → 开发者选项 打开开发者模式):

```powershell
irm https://raw.githubusercontent.com/Ccccraz/.dotfiles/main/install.ps1 | iex
```

加 `--dry-run`(Windows 为 `-DryRun`)只预览。脚本会安装 mise,把仓库 clone 到 `~/.dotfiles`,把 `~/.config/mise` 链接到 `~/.dotfiles/mise`,再执行 `mise -E <preset> bootstrap`。预设记在 `mise/miserc.local.toml`(不入库),之后直接 `mise bootstrap --update` 即可同步。

## 预设

| 预设 | 平台 | 内容 |
|------|------|------|
| `full` | macOS、Linux、Windows | 完全控制的开发机:nushell(登录 shell)、kitty、aerospace、LazyVim、Maple Mono 字体、全部 CLI 工具、agents |
| `minimal` | Linux | 基础 dev 环境:zsh(登录 shell)+ 插件、starship、carapace、neovim、lazygit、uv、btop |

## 目录

| 路径 | 内容 |
|------|------|
| `mise/config.toml` | 各预设共用:公共 CLI 工具、starship、git 配置 |
| `mise/config.<preset>.toml` | 预设专属:系统包(apt/brew/winget/scoop)、工具、配置链接、登录 shell |
| `shell/` | nushell、zsh、pwsh、starship 配置 |
| `tools/` | git、nvim(LazyVim)、kitty、ghostty、yazi、aerospace 配置 |
| `agents/` | AI 工具共享指令与 skills,见 [agents/README.md](agents/README.md) |

## 维护

- 一键升级:在 nushell 里执行 `update`,依次升级 mise、所有工具(配置里都写 `latest`)、系统包、brew 和 uv tool。
- 升级系统包:`mise bootstrap packages upgrade`。
- 新增配置链接:在对应 `mise/*.toml` 的 `[dotfiles]` 里加一项,然后 `mise bootstrap --only dotfiles`。
