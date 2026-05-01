---
name: commit
description: 分析暂存区变更并创建规范的 conventional commit，包含 gitmoji 和分支安全检查
user-invokable: true
---

# 规范提交

此技能用于基于暂存区内容创建规范 commit。提交信息使用英文，流程说明使用中文。

## 核心规则

- 提交前必须检查当前分支：`git branch --show-current`
- 不在 `main` 或 `master` 上直接提交，除非用户明确确认
- 只基于已暂存变更生成提交信息
- 不使用 `git add .`
- 提交信息格式为 `<type>(<scope>): <gitmoji> <subject>`
- 非平凡变更应在 body 中列出关键点

## 类型与默认 gitmoji

| 类型 | 用途 | gitmoji |
|------|------|---------|
| `feat` | 新功能 | `:sparkles:` |
| `fix` | Bug 修复 | `:bug:` |
| `docs` | 文档 | `:memo:` |
| `style` | 格式化 | `:art:` |
| `refactor` | 重构 | `:recycle:` |
| `perf` | 性能优化 | `:zap:` |
| `test` | 测试 | `:white_check_mark:` |
| `build` | 构建或依赖 | `:package:` |
| `ci` | CI/CD | `:construction_worker:` |
| `chore` | 维护 | `:wrench:` |

删除使用 `:fire:`，移动使用 `:truck:`，安全修复使用 `:lock:`。

## 执行流程

1. 检查分支
2. 运行 `git status -s` 和 `git diff --cached`
3. 如果暂存区为空，停止并提示用户暂存具体文件
4. 根据 diff 判断 type、scope、gitmoji 和 subject
5. 使用 HEREDOC 提交：

```bash
git commit -m "$(cat <<'EOF'
<type>(<scope>): <gitmoji> <subject>

- <detail_1>
- <detail_2>
EOF
)"
```

6. 用 `git log -1 --stat` 验证结果

## 示例

```text
feat(auth): :sparkles: add JWT token validation

- validate token expiry before resolving sessions
- reject malformed authorization headers
```
