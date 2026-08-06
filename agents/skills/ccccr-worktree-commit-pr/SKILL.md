---
name: ccccr-worktree-commit-pr
description: 将 worktree 内已 review 的改动提交、推送并走完整 PR 流程：使用绝对路径 git -C 安全 add/commit，创建 GitHub PR，等待 checks，squash 合并后清理 worktree 与分支并同步 main。用于用户要求把 worktree 分支通过 PR 发布到 main 的场景。
---

# Worktree 内提交并发布

严格按顺序执行；失败时立即停止并报告当前分支、提交和 PR 状态，不猜测或隐藏部分完成状态。

## 前置检查

1. 运行 `gh auth status`，认证失败时停止。
2. 确认改动位于 worktree 内（仓库路径含 `.worktree/`），且主仓库 `main` 工作区未被触碰。
3. 确认存在 `origin`；运行 `git fetch origin main`，要求主仓库 `HEAD` 与 `origin/main` 完全一致；否则停止并要求先同步。
4. 检查本地和远端分支名是否冲突；冲突时依次添加 `-2`、`-3` 后缀。

## 提交

1. 运行 `git -C <worktree-abs-path> status --short`，检查将提交的文件；与任务无关的副作用改动（例如 `uv run` 可能将陈旧的 `uv.lock` 版本号升级）先还原。
2. 不执行 `git add -A` 或 `git add .`，只显式暂存任务相关文件；`.venv` 等生成产物已被 gitignore 忽略，无需清理也不会进入提交。
3. `git add` 和 `git commit` 都会写入 `.git`（index/refs），沙箱内会被拒绝；必须使用 `require_escalated` 并附 justification。
4. 提权命令可能忽略指定的工作目录，因此所有 git 命令一律使用绝对路径形式：

   ```bash
   git -C <worktree-abs-path> add <file...>
   git -C <worktree-abs-path> commit -m "<message>"
   ```

5. 使用 `ccccr-commit-message` skill 根据暂存差异生成英文 conventional commit message 和 gitmoji；提交后运行 `git -C <worktree-abs-path> log --oneline -1` 确认 commit 已创建。

## 推送与 PR

1. 使用 `git -C <worktree-abs-path> push --set-upstream origin <branch>` 推送（需提权）。
2. 使用 `gh pr create --base main --head <branch>` 创建 PR；标题使用 commit 标题，body 简述改动和验证情况。
3. 使用 `gh pr checks` 查询 checks：没有 checks 时继续；存在 pending checks 时使用 `--watch --fail-fast` 等待。
4. 任一 check 失败时停止，保留 PR 及分支供用户处理。
5. checks 通过后使用 `gh pr merge --squash --delete-branch` 合并。

## 清理和同步

1. 确认 PR 已合并后，用 `git worktree remove <worktree-abs-path>` 移除 worktree（需提权）。
2. 用 `git branch -D <branch>` 删除本地工作分支（需提权）。
3. 在主仓库运行 `git fetch --prune origin` 和 `git pull --ff-only origin main`。
4. 输出 PR URL、squash commit、worktree/分支清理结果和最终同步状态。
