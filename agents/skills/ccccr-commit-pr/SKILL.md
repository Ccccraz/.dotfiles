---
name: ccccr-commit-pr
description: 将 Git 暂存区内容提交到新分支，创建 GitHub PR，等待 checks，通过后 squash 合并，清理分支并同步 main。用于用户明确要求通过完整 PR 流程发布已暂存改动的场景。
---

# 通过 PR 提交

严格按顺序执行；失败时立即停止并报告当前分支、提交和 PR 状态，不猜测或隐藏部分完成状态。

## 前置检查

1. 运行 `gh auth status`，认证失败时停止。
2. 确认当前分支为 `main`，且存在 `origin`。
3. 检查 `git status --short` 和 `git diff --cached`；暂存区为空时停止。
4. 不执行 `git add`，不提交或覆盖未暂存内容。
5. 运行 `git fetch origin main`，要求 `HEAD` 与 `origin/main` 完全一致；否则停止并要求先同步。

## 创建分支和提交

1. 使用 `git-flow-branch-creator` 根据暂存差异选择 `feature/`、`release-` 或 `hotfix/` 名称，只采用其分类和命名规则。
2. 忽略该第三方 skill 的 `develop`、`master` 和多目标合并规则；始终从当前 `main` 创建分支并 PR 回 `main`。
3. 检查本地和远端分支名；冲突时依次添加 `-2`、`-3`。
4. 运行 `git switch -c <branch>`。
5. 使用 `ccccr-commit-message` skill 生成消息并提交暂存内容。
6. 使用 `git push --set-upstream origin <branch>` 推送。

## PR、检查和合并

1. 使用 `gh pr create --base main --head <branch>` 创建 PR；标题使用 commit 标题，body 简述改动和验证情况。
2. 使用 `gh pr checks` 查询 checks：没有 checks 时继续；存在 pending checks 时使用 `--watch --fail-fast` 等待。
3. 任一 check 失败时停止，保留 PR 及分支供用户处理。
4. checks 通过后使用 `gh pr merge --squash --delete-branch` 合并。

## 清理和同步

1. 确认 PR 已合并后切换到 `main`。
2. 检查本地和远端工作分支；仍存在时分别删除。
3. 运行 `git fetch --prune origin` 和 `git pull --ff-only origin main`。
4. 输出 PR URL、squash commit、分支清理结果和最终同步状态。
