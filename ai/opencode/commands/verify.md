---
description: 验证当前代码库状态
---

请按顺序验证当前代码库状态。

## 构建检查

!`npm run build 2>&1 || echo "No build script"`

## 类型检查

!`npx tsc --noEmit 2>&1 || echo "No TypeScript"`

## Lint 检查

!`npm run lint 2>&1 || npx eslint . 2>&1 || echo "No lint script"`

## 测试套件

!`npm test 2>&1 || echo "No test script"`

## console.log 审计

!`grep -r "console.log" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" src/ 2>/dev/null | head -20 || echo "No source files"`

## Git 状态

!`git status --short`

请输出简洁验证报告：

```text
验证结果: [通过/失败]
构建: [OK/失败]
类型: [OK/X 错误]
Lint: [OK/X 问题]
测试: [X/Y 通过]
日志: [OK/X console.log]

准备合并: [是/否]
```

如果存在关键问题，请列出并提供修复建议。
