---
name: api-design
description: REST API 设计模式，包括资源命名、状态码、分页、过滤、错误响应、版本控制和速率限制
---

# API 设计

用于设计、审查或重构 REST API。优先保持现有项目风格一致。

## 资源命名

- 使用名词复数：`/users`、`/orders`
- 嵌套资源不超过两层：`/users/{userId}/orders`
- 动作用 HTTP 方法表达，不放进路径

```text
GET    /users
POST   /users
GET    /users/{id}
PATCH  /users/{id}
DELETE /users/{id}
```

## 状态码

| 状态码 | 用途 |
|--------|------|
| `200` | 查询或更新成功 |
| `201` | 创建成功 |
| `204` | 删除成功且无响应体 |
| `400` | 请求格式或校验失败 |
| `401` | 未认证 |
| `403` | 无权限 |
| `404` | 资源不存在 |
| `409` | 冲突 |
| `422` | 语义校验失败 |
| `429` | 触发速率限制 |
| `500` | 服务端错误 |

## 响应结构

```json
{
  "success": true,
  "data": {},
  "meta": {}
}
```

错误响应：

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request",
    "details": []
  }
}
```

## 分页和过滤

- 小型列表可用 `page` + `limit`
- 大型或实时列表优先游标分页
- 过滤参数保持显式：`?status=active&created_after=2026-01-01`
- 排序使用 `sort=created_at:desc`

## 安全要求

- 所有外部输入必须校验
- 错误信息不泄露内部实现
- 写操作需要认证和授权
- 公开 API 需要速率限制
- 幂等写操作应支持 idempotency key

## 版本控制

- 破坏性变更使用 `/v1`、`/v2` 或 header 版本
- 非破坏性新增字段不需要新版本
- 废弃字段要有迁移期和文档说明
