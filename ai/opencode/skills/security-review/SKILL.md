---
name: security-review
description: 安全审查技能。用于认证、用户输入、密钥、API、支付、文件上传和敏感数据相关改动
---

# 安全审查

当代码涉及用户输入、认证授权、API、数据库、文件上传、第三方集成或敏感数据时使用。

## 检查清单

### 密钥管理

- [ ] 源码中没有 API key、token、密码或私钥
- [ ] 密钥通过环境变量或密钥管理系统注入
- [ ] 缺少关键密钥时快速失败
- [ ] `.env`、凭证文件和导出数据不进入版本库

### 输入验证

```typescript
import { z } from 'zod'

const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
})
```

- [ ] 所有 request body、params、query 都经过校验
- [ ] 文件上传检查大小、类型和扩展名
- [ ] HTML 内容必须清洗或禁止

### 注入防护

- [ ] SQL 使用参数化查询或 ORM 安全 API
- [ ] shell 命令不拼接用户输入
- [ ] 文件路径经过归一化和白名单校验

### 认证与授权

- [ ] 每个敏感端点都有认证
- [ ] 资源访问做对象级授权
- [ ] JWT/session 校验过期、签名和受众
- [ ] 管理员能力有额外权限检查

### Web 安全

- [ ] CORS 只允许可信来源
- [ ] 设置必要安全响应头
- [ ] 关键操作有 CSRF 防护或等效机制
- [ ] API 有速率限制

### 日志与错误

- [ ] 日志不包含密码、token、PII 或完整请求头
- [ ] 用户错误不暴露堆栈、SQL、内部路径
- [ ] 安全事件可追踪

## 常见高危模式

| 模式 | 风险 | 修复 |
|------|------|------|
| 硬编码密钥 | 凭证泄露 | 使用 `process.env` |
| 拼接 SQL | SQL 注入 | 参数化查询 |
| `innerHTML` 写入用户输入 | XSS | 使用 `textContent` 或 DOMPurify |
| 用户输入拼接命令 | 命令注入 | 使用安全 API 或 `execFile` |
| 未授权访问对象 ID | 越权 | 校验资源归属 |

## 输出要求

- 按 CRITICAL、HIGH、MEDIUM 分组
- 每个问题包含文件、风险、影响和修复建议
- 如果发现密钥泄露，建议立即轮换
- 不确定时说明假设，不夸大风险
