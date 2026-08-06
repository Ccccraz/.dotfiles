# agents — AI 工具配置统一管理

本目录统一管理 AI coding agent 的共享资产。**原则:仓库只存「自己写/维护」的东西;第三方资产只存清单,由脚本安装。**

## 目录结构

```
agents/
├── README.md       # 本文件
├── AGENTS.md       # 共享设计原则(语言规范 + KISS + SOLID + Agent 工具约束),唯一权威
└── install.sh      # 安装脚本:skills / mcp 清单内嵌 + AGENTS.md 分发
```

## 使用

### 完整安装

```bash
./agents/install.sh                # 按 AGENTS.md、skills、MCP 的顺序执行
./agents/install.sh --dry-run      # 仅预览完整流程
```

### 分发共享指令 AGENTS.md

```bash
./agents/install.sh --links        # 预览用 --dry-run 先看一遍
```

将 `agents/AGENTS.md` 链接到 reasonix、codex 和 opencode 的全局配置目录；已有目标直接覆盖。

### 安装 / 更新 skills

```bash
./agents/install.sh --skills       # 链接本地 skill 并安装第三方 skills
```

本仓库自有 skill 统一使用 `ccccr-` 前缀；`ccccr-commit-message`、`ccccr-commit-pr`、`ccccr-commit-main`、`ccccr-worktree`、`ccccr-worktree-commit-pr` 和 `ccccr-worktree-commit-main` 链接到 `~/.agents/skills/`。第三方 skill 通过 `install_skill "<owner/repo>" "<skill 名>"` 显式安装到 Universal。

### 安装 / 更新 MCP

```bash
./agents/install.sh --mcp          # 安装脚本中声明的第三方 MCP
```

当前通过官方安装脚本安装 codebase-memory-mcp；已有二进制和 agent 配置由安装器更新。

## 维护约定

- **设计原则唯一权威是 `agents/AGENTS.md`**,经符号链接分发到各工具
- **codebase-memory 提示块**由 codebase-memory-mcp 工具自动插入/更新各 AGENTS.md(带 `<!-- -->` 标记),不要手动编辑
- 运行时数据(secrets、sessions、cache、`auth.json`、`.infisical.json` 等)一律不入仓库
- 配置文件中的绝对路径(如 `/Users/ccccr/.local/bin/codebase-memory-mcp`)为本机特定,换机器时需手动替换为 `$HOME` 对应路径
- install.sh 只做「按清单安装/校验 + 分发链接」,不做环境假设;目录问题(如悬空链接)会如实报错,由你处置
