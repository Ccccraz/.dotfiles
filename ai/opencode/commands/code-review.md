---
description: 审查当前代码变更的质量、安全性和回归风险
agent: code-reviewer
subtask: true
---

请审查当前未提交的代码变更：

!`git diff --name-only HEAD`

重点检查：

**安全问题（CRITICAL）**

- 硬编码凭证、API key、token 或密码
- SQL 注入、XSS、路径遍历、命令注入
- 缺少输入验证、认证或授权校验

**代码质量（HIGH）**

- 函数超过 50 行或文件超过 800 行
- 嵌套超过 4 层
- 缺少错误处理
- `console.log`、死代码、未使用 import

**最佳实践（MEDIUM）**

- 不必要的 mutation
- 新行为缺少测试或验证说明
- 与现有项目模式不一致

请按严重程度分组报告发现的问题，并给出具体修复建议。
