---
name: backend-patterns
description: 后端架构模式、API 设计、数据库访问、错误处理，以及 Node.js、Express、Next.js API 路由实践
---

# 后端模式

用于实现或审查后端逻辑。目标是边界清晰、错误可控、接口稳定。

## 分层建议

- route/controller：解析请求、鉴权、调用 service
- service：承载业务逻辑
- repository：封装数据库访问
- schema：校验外部输入
- adapter：隔离第三方 API

## 请求处理流程

1. 认证用户
2. 校验输入
3. 检查授权
4. 调用业务逻辑
5. 返回稳定响应
6. 记录必要日志

## 输入校验

```typescript
const schema = z.object({
  email: z.string().email(),
  page: z.coerce.number().int().min(1).default(1),
})
```

所有 body、query、params 都应视为不可信输入。

## 错误处理

- 业务错误使用稳定错误码
- 不向用户暴露堆栈、SQL、内部路径
- 日志保留 request id 和排障上下文
- 外部依赖失败要设置超时和降级策略

## 数据库访问

- 查询必须有边界，例如 `LIMIT`
- 避免 N+1 查询
- 写操作使用事务保护一致性
- 高并发关键路径使用锁或唯一约束
- 迁移和 schema 变更必须可回滚或可前滚

## API 安全

- 敏感接口必须鉴权和授权
- 公共接口需要速率限制
- 文件上传限制大小和类型
- 第三方 URL 必须白名单，避免 SSRF

## 完成检查

- [ ] 输入已校验
- [ ] 权限已检查
- [ ] 错误响应稳定
- [ ] 日志不泄露敏感信息
- [ ] 数据库查询有边界
- [ ] 相关测试或验证已执行
