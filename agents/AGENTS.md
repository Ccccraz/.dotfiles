# 全局 Agent 约定

## 原则：KISS
- 选最简单可行的方案；能删就不加，能用标准库就不引依赖。
- 不为假想需求做抽象、配置项或兼容层；三处重复再考虑抽取。
- 只改被要求的部分，不顺手重构；需要更大改动先说明再做。
- 组合优于继承；扁平优于嵌套。

## 语言与输出
- 必须用中文与用户交流：回复、提问（含 AskUserQuestion 的问题与选项）、方案说明、总结，以及转述子会话或工具的英文结果都算；需要用户审批或操作的事项尤其如此。长会话里最容易漂移成英文。其他内容不限语言。
- issue、PR、提交和仓库文档用该项目已有的语言（目前的项目都是英文）；给用户的操作步骤、待办清单只在对话里给，不写进 issue 或 PR。
- 面向用户的终端示例用 nushell；`.sh` 脚本用 bash；agent 内部执行命令不受此限。
- 先给结论，再给必要细节；不复述已知上下文。

## Git
- 写 commit message 前，必须先读 `~/.dotfiles/agents/instructions/commit.md` 并按其格式写。
- 会话已在 app worktree（路径含 `/.claude/worktrees/`）里就直接在其中工作，不再手建 worktree。
- 只有在非仓库目录启动、需要改某个子仓库时，才手建同级 worktree：`git -C <repo> worktree add ../<repo>-<topic> -b <branch> origin/main`。
- 等 CI 时用 `gh run watch -i 30` 或 `gh pr checks --watch -i 30`，同一时间只开一个 watch；默认 3 秒轮询，并行多个会耗尽 GitHub API 每小时 5000 次的额度。
- 开始任务前先 `git worktree list`；PR 已合并、工作区干净且本地 HEAD 等于 PR head 的，`git worktree remove` 并 `git branch -D`，然后告知用户。

## Python
- 必须 typed：函数签名与公共数据结构都要标注。
- 可以随时写临时 Python 脚本处理文件或数据；全局 `python3` 的版本和依赖不保证，优先用 `uv` 运行。
- 单行：`uv run python -c "..."`；带依赖：`uv run --with <pkg> python -c "..."`
- 独立脚本：PEP 723 内联依赖 + `uv run <script>.py`。
- 需要时可以建虚拟环境（`uv venv`），放在 scratchpad 或项目已忽略的目录里。
- 结束前删掉不再需要的临时脚本和为此建的虚拟环境；需要保留时先问用户。

## 工具路由
- 第三方库/框架/SDK 的版本敏感用法：`ctx7 library` 解析 ID，`ctx7 docs` 取文档；不凭训练数据。
- 字符串、配置、非代码文件：grep/glob。
