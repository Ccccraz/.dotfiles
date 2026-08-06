---
name: ccccr-worktree-commit-main
description: 将 worktree 中已 review 的改动直接提交到 main：在 worktree 分支上安全提交后，用 fast-forward 合并到 main，仅在 main 与 origin/main 同步时推送，并清理 worktree 与本地分支。仅在用户明确要求绕过 PR、直接提交 main 时使用。
---

# Worktree 直接提交到 Main

严格按顺序执行；失败时立即停止并报告当前分支、提交和仓库状态，不猜测或隐藏部分完成状态。

## 前置检查

1. 确认用户明确要求绕过 PR、直接提交 main。
2. 确认改动位于 worktree 内（仓库路径含 `.worktree/`），且主仓库 `main` 工作区干净、存在 `origin`。
3. 运行 `git fetch origin main`，并在合并前判断分支关系：
   - `HEAD`(main) 与 `origin/main` 一致：合并后推送。
   - `origin/main` 是 main 的祖先：本地仅领先，合并后不推送。
   - 其他情况：本地落后或已经分叉，停止并要求先同步。

## 提交 worktree 改动

1. 运行 `git -C <worktree-abs-path> status --short`，检查将提交的文件；与任务无关的副作用改动（例如 `uv run` 可能将陈旧的 `uv.lock` 版本号升级）先还原。
2. 只显式暂存任务相关文件，不执行 `git add -A`；`.venv` 等生成产物已被 gitignore 忽略，保留即可。
3. `git add` 和 `git commit` 都会写入 `.git`（index/refs），沙箱内会被拒绝；必须使用 `require_escalated` 并附 justification，且一律使用 `git -C <worktree-abs-path> ...` 绝对路径形式。
4. 使用 `ccccr-commit-message` skill 生成消息并提交；提交后运行 `git -C <worktree-abs-path> log --oneline -1` 确认 commit 已创建。

## 合并到 main

1. 确认 worktree 分支仅领先 main：`git -C <repo-root> rev-list --count main..<branch>` 至少为 1，且 `git -C <repo-root> rev-list --count <branch>..main` 为 0；否则停止并报告。
2. 在主仓库执行 `git -C <repo-root> merge --ff-only <branch>`（需提权）。
3. 仅当合并前 main 的 `HEAD` 与 `origin/main` 一致时，运行 `git -C <repo-root> push origin main`。
4. 推送失败时保留本地提交，不重置、不强推，并明确报告仓库状态。

## 清理与验证

1. 用 `git worktree remove <worktree-abs-path>` 移除 worktree，并用 `git branch -D <branch>` 删除本地分支（均需提权）。
2. 运行 `git -C <repo-root> log -1 --stat` 和 `git status --short --branch` 验证结果，明确报告是否已推送。
