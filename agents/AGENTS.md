# 全局 Agent 约定

## 原则：KISS
- 选最简单可行的方案；能删就不加，能用标准库就不引依赖。
- 不为假想需求做抽象、配置项或兼容层；三处重复再考虑抽取。
- 只改被要求的部分，不顺手重构；需要更大改动先说明再做。
- 组合优于继承；扁平优于嵌套。

## 语言与输出
- 对话用中文；代码注释、程序输出、commit message 用英文。
- 面向用户的终端示例用 nushell；`.sh` 脚本用 bash；agent 内部执行命令不受此限。
- 先给结论，再给必要细节；不复述已知上下文。

## Git
- 写 commit message 前，必须先读 `~/.dotfiles/agents/instructions/commit.md` 并按其格式写。
- 会话已在 app worktree（路径含 `/.claude/worktrees/`）里就直接在其中工作，不再手建 worktree。
- 只有在非仓库目录启动、需要改某个子仓库时，才手建同级 worktree：`git -C <repo> worktree add ../<repo>-<topic> -b <branch> origin/main`。
- 开始任务前先 `git worktree list`；PR 已合并、工作区干净且本地 HEAD 等于 PR head 的，`git worktree remove` 并 `git branch -D`，然后告知用户。

## Python
- 必须 typed：函数签名与公共数据结构都要标注。
- 全局 `python3` 的版本和依赖不保证；临时 Python 一律用 `uv`，不要创建 `.venv`。
- 单行：`uv run python -c "..."`；带依赖：`uv run --with <pkg> python -c "..."`
- 独立脚本：PEP 723 内联依赖 + `uv run <script>.py`。
- 临时脚本用完清理；需要保留时先问用户。

## 工具路由
- 第三方库/框架/SDK 的版本敏感用法：`ctx7 library` 解析 ID，`ctx7 docs` 取文档；不凭训练数据。
- 字符串、配置、非代码文件：grep/glob。
