---
name: ccccr-commit-message
description: 根据 Git 暂存区差异生成英文 conventional commit message 和 gitmoji。用于用户要求编写、建议或生成 commit message 的场景；只输出消息，不执行提交或其他仓库修改。
---

# 生成 Commit Message

1. 读取 `git status --short` 和 `git diff --cached`。
2. 暂存区为空时停止，并提示用户先暂存明确的文件。
3. 只分析暂存内容，不执行 `git add`，不考虑未暂存修改。
4. 生成英文 commit message，不执行 `git commit`、分支操作或远端操作。

标题格式：

```text
<type>(<scope>): <gitmoji> <subject>
```

- `scope` 不明确时省略括号。
- `subject` 使用祈使语气、小写开头且不加句号。
- 简单改动只输出标题；非平凡改动增加空行和简短项目符号 body。

| type | gitmoji | 用途 |
|---|---|---|
| `feat` | `:sparkles:` | 新功能 |
| `fix` | `:bug:` | Bug 修复 |
| `docs` | `:memo:` | 文档 |
| `style` | `:art:` | 格式化 |
| `refactor` | `:recycle:` | 重构 |
| `perf` | `:zap:` | 性能优化 |
| `test` | `:white_check_mark:` | 测试 |
| `build` | `:package:` | 构建或依赖 |
| `ci` | `:construction_worker:` | CI/CD |
| `chore` | `:wrench:` | 维护 |

删除优先使用 `:fire:`，移动使用 `:truck:`，安全修复使用 `:lock:`。
