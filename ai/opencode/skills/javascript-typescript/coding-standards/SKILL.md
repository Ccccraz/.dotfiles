---
name: coding-standards
description: 通用编码标准，覆盖可读性、最小改动、错误处理、类型安全和 TypeScript/JavaScript/React/Node.js 常用模式
---

# 编码标准

用于编写、审查或重构代码时保持一致质量。优先遵循当前项目已有约定。

## 核心原则

1. 可读性优先：代码被阅读的次数远多于被编写
2. 最小正确改动：只解决当前需求，不顺手重写无关代码
3. 简单优先：能直接表达的逻辑不要过度抽象
4. 明确错误处理：外部依赖、IO、网络和数据库调用必须考虑失败路径
5. 类型表达意图：避免隐式 `any`，公共接口需要清晰类型

## 命名

```typescript
// 好例子
const marketSearchQuery = 'election'
const isUserAuthenticated = true

// 坏例子
const q = 'election'
const flag = true
```

函数名优先使用动词短语，例如 `fetchMarketData`、`calculateTotal`、`isValidEmail`。

## 不可变更新

```typescript
const updatedUser = {
  ...user,
  name: nextName,
}

const nextItems = items.filter((item) => item.id !== removedId)
```

只有在性能、框架约定或 API 明确要求时，才使用原地修改，并说明原因。

## 错误处理

- 对外部服务调用使用 `try/catch`
- 用户可见错误要稳定、可理解
- 日志保留排障信息，但不能泄露密钥或隐私
- 缺少必要配置时快速失败

## 文件组织

- 优先按 feature 或 domain 聚合
- 单文件过大时先拆职责明确的模块
- 不为了抽象而抽象
- 公共工具必须有明确复用场景

## React/Next.js

- 不在 render 中触发 state 更新
- list key 必须稳定
- 异步数据需要 loading 和 error 状态
- server/client 边界要明确
- 不默认添加 `useMemo` 或 `useCallback`，除非项目模式或性能证据需要

## Node.js/API

- 所有外部输入必须校验
- 数据库查询使用参数化或 ORM 安全 API
- 外部 HTTP 调用设置超时
- 对外错误信息不要暴露内部实现
- 关键 API 需要鉴权、授权和速率限制

## 完成前检查

- [ ] 命名清晰
- [ ] 没有无关重构
- [ ] 错误路径可处理
- [ ] 外部输入已校验
- [ ] 没有硬编码密钥
- [ ] 相关测试或验证已运行，或说明未运行原因
