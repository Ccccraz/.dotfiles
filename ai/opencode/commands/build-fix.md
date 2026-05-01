---
description: 增量修复构建和类型错误
agent: build-error-resolver
subtask: true
---

请增量修复构建错误，一次只修一个问题。

先运行构建或类型检查命令定位错误：

!`npm run build 2>&1 || npx tsc --noEmit 2>&1 || echo "No build command found"`

修复流程：

1. 一次只处理一个错误或一组同根因错误
2. 使用最小改动修复
3. 修复后重新运行相关命令验证
4. 记录已修复问题和剩余问题

遇到以下情况请停止并说明：

- 修复引入更多错误
- 同一错误尝试 3 次后仍失败
- 需要架构变更，而不是简单构建修复
