---
description: 管理 Git worktree，在项目平级的 ../worktrees/项目名/ 目录下创建，支持智能默认、IDE 集成和内容迁移
allowed-tools: Read(**), Exec(git worktree add, git worktree list, git worktree remove, git worktree prune, git branch, git checkout, git rev-parse, git stash, git cp, detect-ide, open-ide, which, command, basename, dirname)
argument-hint: <add|list|remove|prune|migrate> [path] [-b <branch>] [-o|--open] [--track] [--guess-remote] [--detach] [--checkout] [--lock] [--migrate-from <source-path>] [--migrate-stash]
---

# Git Worktree 管理命令

管理 Git worktree，默认在项目平级目录 `../worktrees/项目名/` 下创建。

## 用法

```bash
/git-worktree add <path>
/git-worktree add <path> -b <branch>
/git-worktree add <path> -o
/git-worktree list
/git-worktree remove <path>
/git-worktree prune
/git-worktree migrate <target> --from <source>
/git-worktree migrate <target> --stash
```

## 参数

| 参数 | 说明 |
|------|------|
| `add [<path>]` | 在 `../worktrees/项目名/<path>` 创建 worktree |
| `migrate <target>` | 迁移未提交改动或 stash 到目标 worktree |
| `list` | 列出所有 worktree |
| `remove <path>` | 删除指定 worktree |
| `prune` | 清理无效 worktree 引用 |
| `-b <branch>` | 创建或检出指定分支 |
| `-o, --open` | 创建后直接打开 IDE |
| `--from <source>` | 指定迁移源 |
| `--stash` | 迁移当前 stash 内容 |
| `--track` | 设置远端跟踪分支 |
| `--guess-remote` | 自动猜测远端分支 |
| `--detach` | 创建 detached HEAD worktree |
| `--checkout` | 创建后立即 checkout |
| `--lock` | 创建后锁定 worktree |

## 路径计算

```bash
get_main_repo_path() {
  local git_common_dir=$(git rev-parse --git-common-dir 2>/dev/null)
  local current_toplevel=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ "$git_common_dir" != "$current_toplevel/.git" ]]; then
    dirname "$git_common_dir"
  else
    echo "$current_toplevel"
  fi
}

MAIN_REPO_PATH=$(get_main_repo_path)
PROJECT_NAME=$(basename "$MAIN_REPO_PATH")
WORKTREE_BASE="$MAIN_REPO_PATH/../worktrees/$PROJECT_NAME"
ABSOLUTE_WORKTREE_PATH="$WORKTREE_BASE/<path>"
```

始终使用绝对路径，避免在已有 worktree 内创建嵌套目录。

## 环境文件处理

- 扫描主仓库 `.gitignore`
- 复制被忽略的 `.env` 和 `.env.*` 到新 worktree
- 跳过 `.env.example` 等模板文件
- 保留原文件权限和时间戳

## 目录结构

```text
parent-directory/
├── your-project/
└── worktrees/
    └── your-project/
        ├── feature-ui/
        ├── hotfix/
        └── debug/
```

## 注意

- worktree 共享 `.git` 数据，节省磁盘空间
- 创建前检查路径冲突和分支占用
- 内容迁移仅处理未提交改动；已提交内容请使用 `git cherry-pick`
- IDE 命令行工具必须在 PATH 中
