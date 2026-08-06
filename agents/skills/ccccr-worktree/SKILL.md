---
name: ccccr-worktree
description: 管理 Codex 开发 worktree 的放置、创建与使用规范：worktree 放在仓库根目录的 .worktree/ 目录下，分支名使用 feature/ 等前缀；创建后不自动 commit、等待用户 review，并保留测试产生的项目级 .venv。用于用户要求新建 worktree 分支开发、在 worktree 中实现改动，或询问 worktree 位置与使用规则的场景。
---

# Worktree 使用规范

严格按顺序执行；创建失败或状态异常时立即停止并报告，不猜测或隐藏部分完成状态。

## 放置位置

1. worktree 一律放在仓库根目录下的 `.worktree/<分支名>`，例如 `.worktree/feature-centralized-shortcuts`。
2. 创建 worktree 时，在对应特性分支的 `.gitignore` 中追加 `.worktree/`，避免主仓库 `git status` 出现 worktree 目录噪声。

## 创建前置检查

1. 确认主仓库当前分支为 `main`，且存在 `origin`。
2. 检查 `git status --short`；主仓库有未提交改动时停止，先请用户处理。
3. 运行 `git fetch origin main`，要求 `HEAD` 与 `origin/main` 完全一致；否则停止并要求先同步。
4. 检查本地和远端是否已存在同名分支；冲突时依次添加 `-2`、`-3` 后缀。

## 创建 worktree

1. 从主仓库根目录执行：

   ```bash
   git -C <repo-root> worktree add .worktree/<branch> -b <branch>
   ```

   其中 `<branch>` 使用 git-flow 命名（通常为 `feature/<description>`）。
2. `git worktree add` 会写入 `.git/refs`，在沙箱内被拒绝；必须使用 `require_escalated` 并附上创建 worktree 的 justification。
3. 提权执行可能不继承指定的工作目录，因此始终使用绝对路径形式的 `git -C <repo-root> ...`；创建后必须用 `git worktree list` 验证 worktree 出现在预期路径。

## 在 worktree 中开发

1. 所有改动和测试都在该 worktree 内进行，不触碰主仓库工作区。
2. 开发完成（含测试）后**不要 commit**：不执行 `git commit`，也不推送或创建 PR；保持改动原样，向用户报告修改摘要和 worktree 路径，等待用户 review。
3. 创建和测试过程中 `uv run` 生成的项目级 `.venv` **不算垃圾，必须保留**，不得删除。
4. worktree 的清理（移除 worktree、删除分支、同步 main）不在本 skill 范围，由用户 review 后经 `ccccr-worktree-commit-pr` 流程处理。
