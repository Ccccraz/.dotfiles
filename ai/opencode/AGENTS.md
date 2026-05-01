# AGENTS.md

## 1. 语言与交互规范

- **对话语言**: 中文
- **代码注释/输出**: 中文

## 2. Python 环境约束

本系统无全局 Python 环境，所有 Python 代码必须通过 `uv` 调度执行。

### A. 临时单行任务

用于快速计算、系统检查或简单逻辑验证。

- **格式**: `uv run python -c "<code_string>"`
- **带依赖**: `uv run --with <package> python -c "..."`

### B. 独立任务脚本

所有生成的 `.py` 脚本必须包含 PEP 723 内联依赖定义，确保脚本自包含且可直接运行。

```python
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "httpx",
#     "pandas",
#     "rich",
# ]
# ///

import httpx
# 业务逻辑代码
```

- **执行命令**: `uv run <script_name>.py`

### C. 快速运行模式

若脚本较短且不需长期保留，可使用 `--with` 风格。

- **格式**: `uv run --with <pkg_1> --with <pkg_2> <script>.py`

## 3. 目录与资源清理

- **无痕运行**: 除非用户明确要求，否则严禁执行 `uv venv` 或在当前目录生成 `.venv` 文件夹。
- **临时文件**: 任务完成后，询问用户是否需要删除生成的 `.py` 临时脚本。
