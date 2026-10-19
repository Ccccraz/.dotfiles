# 全局 Agent 约定

## 个人风格
保持简单；组合优于继承；Python 必须 typed（函数签名与公共数据结构都要标注）。

## 语言与输出
- 对话用中文；代码注释、程序输出、commit message 用英文。
- 面向用户的终端示例用 nushell；`.sh` 脚本用 bash；agent 内部执行命令不受此限。
- 先给结论，再给必要细节；不复述已知上下文。

## Python
- 全局 `python3` 的版本和依赖不保证；临时 Python 一律用 `uv`，不要创建 `.venv`。
- 单行：`uv run python -c "..."`；带依赖：`uv run --with <pkg> python -c "..."`
- 独立脚本：PEP 723 内联依赖 + `uv run <script>.py`。
- 临时脚本用完清理；需要保留时先问用户。

## 工具路由
- 第三方库/框架/SDK 的版本敏感用法：`ctx7 library` 解析 ID，`ctx7 docs` 取文档；不凭训练数据。
- 代码结构/调用链：优先 `codebase-memory`，仅限已建索引的项目；DSH 工具名 `mcp__codebase-memory__*`，除 `list_projects` 外都要传 `project`。
- `query_graph` 的 `ORDER BY` 会被忽略；取 top-N 用 `get_architecture` 的 hotspots 或自行排序。
- 字符串、配置、非代码文件：grep/glob。

<!-- codebase-memory-mcp:start -->
# Codebase Knowledge Graph (codebase-memory-mcp)

This project uses codebase-memory-mcp to maintain a knowledge graph of the codebase.
ALWAYS prefer MCP graph tools over grep/glob/file-search for code discovery.

## Priority Order
1. `search_graph` — find functions, classes, routes, variables by pattern
2. `trace_path` — trace who calls a function or what it calls
3. `get_code_snippet` — read specific function/class source code
4. `query_graph` — run Cypher queries for complex patterns
5. `get_architecture` — high-level project summary

## When to fall back to grep/glob
- Searching for string literals, error messages, config values
- Searching non-code files (Dockerfiles, shell scripts, configs)
- When MCP tools return insufficient results

## Examples
- Find a handler: `search_graph(name_pattern=".*OrderHandler.*")`
- Who calls it: `trace_path(function_name="OrderHandler", direction="inbound")`
- Read source: `get_code_snippet(qualified_name="pkg/orders.OrderHandler")`
<!-- codebase-memory-mcp:end -->
