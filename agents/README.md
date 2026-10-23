# agents — AI 工具配置统一管理

本目录统一管理 AI coding agent 的共享资产。**原则:仓库只存「自己写/维护」的东西;第三方资产只存清单,由脚本安装。**

## 目录结构

```
agents/
├── README.md       # 本文件
├── AGENTS.md       # 全局 Agent 约定(KISS 原则 + 语言 + Git + Python + 工具路由),唯一权威
├── CLAUDE.md       # 仅一行 @AGENTS.md,供 Claude Code 导入
├── instructions/   # 按需读取的细则(由 AGENTS.md 指向),如 commit.md
└── install.sh      # 安装脚本:AGENTS.md 分发 + skills 清单内嵌
```

## 使用

### 完整安装

```bash
./agents/install.sh                # 依次执行 AGENTS.md 分发和 skills 安装
./agents/install.sh --dry-run      # 仅预览完整流程
```

### 分发共享指令 AGENTS.md

```bash
./agents/install.sh --links        # 预览用 --dry-run 先看一遍
```

将 `agents/AGENTS.md` 复制到 reasonix、zcode 的全局配置目录,链接到 codex、opencode、deepseek-harness 和 Claude Code 的全局配置目录;Claude Code 另链接 `agents/CLAUDE.md` 到 `~/.claude/CLAUDE.md`,通过 `@AGENTS.md` 导入;已有目标直接覆盖。deepseek-harness 的全局指令固定在 `$DSH_HOME/AGENTS.md`(`DSH_HOME` 未设置时默认为 `~/.dsh/AGENTS.md`),脚本按该路径软链接。reasonix、zcode 拿到的是复制件,修改 `AGENTS.md` 后需重新运行 `--links` 同步。

### 安装 / 更新 skills

```bash
./agents/install.sh --skills       # 链接本地 skill 并安装第三方 skills
```

本仓库自有 skill 使用 `ccccr-` 前缀；`ccccr-agents-md` 链接到 `~/.agents/skills/`,再由 `~/.claude/skills/` 链接过去。第三方 skill 通过 `install_skill "<owner/repo>" "<skill 名>"` 显式安装到 Universal。

## 维护约定

- **全局 Agent 约定唯一权威是 `agents/AGENTS.md`**,经链接或复制分发到各工具
- 运行时数据(secrets、sessions、cache、`auth.json`、`.infisical.json` 等)一律不入仓库
- install.sh 只做「按清单安装 + 分发」,不做环境假设,也不清理旧链接;删除本地 skill 后需手动删除 `~/.agents/skills/` 和 `~/.claude/skills/` 中对应的链接
