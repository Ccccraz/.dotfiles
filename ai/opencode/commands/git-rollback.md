---
description: 交互式回滚 Git 分支到历史版本；默认只预览，确认后才执行 reset 或 revert
allowed-tools: Read(**), Exec(git fetch, git branch, git tag, git log, git reflog, git checkout, git reset, git revert, git switch), Write()
argument-hint: [--branch <branch>] [--target <rev>] [--mode reset|revert] [--depth <n>] [--dry-run]
---

# Git 回滚命令

目标：安全、可视地将指定分支回滚到历史版本。

默认只做预览；真正执行前必须二次确认，不提供 `--yes` 跳过确认。

## 用法

```bash
/git-rollback
/git-rollback --branch feature/calculator
/git-rollback --branch main --target 1a2b3c4d --mode reset
/git-rollback --branch release/v2.1 --target v2.0.5 --mode revert --dry-run
```

## 参数

| 参数 | 说明 |
|------|------|
| `--branch <branch>` | 要回滚的分支，缺省时交互选择 |
| `--target <rev>` | 目标版本，可为 commit、tag 或 reflog 引用 |
| `--mode reset\|revert` | `reset` 改写历史，`revert` 生成反向提交 |
| `--depth <n>` | 交互模式列出最近 n 条记录 |
| `--dry-run` | 只预览即将执行的命令 |

## 流程

1. 同步远端：`git fetch --all --prune`
2. 列出本地和远端分支
3. 选择目标分支
4. 列出最近提交、tag 和 reflog
5. 选择目标版本
6. 选择 `reset` 或 `revert`
7. 显示将执行的命令并要求最终确认
8. 执行回滚
9. 给出后续推送建议

## 安全护栏

- 默认只预览
- `main`、`master`、`production` 等受保护分支需要额外确认
- `reset` 会改写历史，优先建议 `revert`
- 不提供强推命令；如确需强推，用户必须手动执行 `git push --force-with-lease`

## 注意

- `reset` 会改写历史，可能影响协作者
- `revert` 更安全，但会增加反向提交
- 回滚前确认 LFS、子模块和 CI 策略
