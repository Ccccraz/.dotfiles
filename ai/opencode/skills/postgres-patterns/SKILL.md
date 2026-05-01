---
name: postgres-patterns
description: PostgreSQL 查询优化、schema 设计、索引、安全和 Supabase 相关模式
---

# PostgreSQL 模式

用于设计 schema、编写 SQL、排查慢查询、设置 RLS 或审查数据库相关代码。

## 索引速查

| 查询模式 | 索引类型 | 示例 |
|----------|----------|------|
| `WHERE col = value` | B-tree | `CREATE INDEX idx ON t (col)` |
| `WHERE a = x AND b > y` | 复合索引 | `CREATE INDEX idx ON t (a, b)` |
| `WHERE jsonb @> '{}'` | GIN | `CREATE INDEX idx ON t USING gin (col)` |
| 时间范围查询 | BRIN | `CREATE INDEX idx ON t USING brin (created_at)` |

复合索引通常等值条件在前，范围条件在后。

## 数据类型建议

| 用途 | 推荐 | 避免 |
|------|------|------|
| ID | `bigint` 或明确策略的 UUID | 随意混用 |
| 文本 | `text` | 无意义的 `varchar(255)` |
| 时间 | `timestamptz` | `timestamp` |
| 金额 | `numeric` | `float` |
| 标志 | `boolean` | 字符串状态混用 |

## 常用模式

```sql
CREATE INDEX idx_orders_status_created_at ON orders (status, created_at);

CREATE INDEX idx_users_email_active ON users (email) WHERE deleted_at IS NULL;

INSERT INTO settings (user_id, key, value)
VALUES (123, 'theme', 'dark')
ON CONFLICT (user_id, key)
DO UPDATE SET value = EXCLUDED.value;
```

## RLS 注意事项

```sql
CREATE POLICY policy ON orders
  USING ((SELECT auth.uid()) = user_id);
```

- 策略必须覆盖 select、insert、update、delete
- 避免策略中重复执行昂贵函数
- 用测试验证不同角色访问结果

## 慢查询排查

```sql
SELECT query, mean_exec_time, calls
FROM pg_stat_statements
WHERE mean_exec_time > 100
ORDER BY mean_exec_time DESC;
```

检查点：

- 是否缺少索引
- 是否返回过多字段或行
- 是否存在 N+1 查询
- 是否使用 OFFSET 深分页
- 是否需要覆盖索引或部分索引

## 安全检查

- [ ] 查询参数化
- [ ] RLS 策略可测试
- [ ] migration 可回滚或可前滚
- [ ] 权限最小化
- [ ] 不在日志中输出敏感字段

## 相关技能

- `database-migrations`
- `backend-patterns`
