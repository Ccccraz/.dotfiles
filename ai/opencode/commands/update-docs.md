---
description: 从源码同步文档
agent: doc-updater
subtask: true
---

请从源码同步文档。

## 事实来源

| 来源 | 用途 |
|------|------|
| `package.json` scripts | 命令参考 |
| `.env.example` 或 `.env.template` | 环境变量文档 |
| 路由文件 | API 端点参考 |
| 源码导出 | 公共 API 文档 |
| `Dockerfile` | 基础设施说明 |

## 检查命令

!`cat package.json | grep -A 20 '"scripts"'`

!`cat .env.example 2>/dev/null || cat .env.template 2>/dev/null || echo "No env template found"`

## 更新目标

- 生成或更新 `docs/CONTRIBUTING.md`
- 生成或更新 `docs/RUNBOOK.md`
- 标记可能过时的文档
- 不编造源码中不存在的脚本、端点或环境变量

请输出文档更新报告：

```text
文档更新
─────────────
更新: X 个文件
标记: Y 个文件可能过时
跳过: Z 个文件（无变更）
─────────────
```
