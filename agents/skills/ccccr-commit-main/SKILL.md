---
name: ccccr-commit-main
description: 将 Git 暂存区内容提交到 main；本地与 origin/main 同步时推送，本地已领先时只创建本地 commit。仅在用户明确要求绕过 PR、直接提交 main 时使用。
---

# 直接提交到 Main

1. 确认当前分支为 `main`，且存在 `origin`。
2. 检查 `git status --short` 和 `git diff --cached`；暂存区为空时停止。
3. 不执行 `git add`，不提交或覆盖未暂存内容。
4. 运行 `git fetch origin main`，并在提交前判断分支关系：
   - `HEAD` 与 `origin/main` 一致：继续提交，提交后推送。
   - `origin/main` 是 `HEAD` 的祖先：本地仅领先，继续提交，但不推送。
   - 其他情况：本地落后或已经分叉，停止并要求先同步。
5. 使用 `ccccr-commit-message` skill 生成消息并提交暂存内容。
6. 仅当提交前 `HEAD` 与 `origin/main` 一致时，运行 `git push origin main`。
7. 使用 `git log -1 --stat` 和 `git status --short --branch` 验证结果，并明确报告是否已推送。

未推送或推送失败时保留本地提交，不重置、不强推，并明确报告仓库状态。
