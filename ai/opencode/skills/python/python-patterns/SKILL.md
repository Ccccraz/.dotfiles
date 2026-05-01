---
name: python-patterns
description: Python 编码实践，覆盖 PEP 8、类型提示、错误处理、资源管理和可维护性
---

# Python 模式

用于编写或审查 Python 代码。当前环境要求所有 Python 运行都通过 `uv`。

## 环境约束

- 单行任务使用 `uv run python -c "..."`
- 临时依赖使用 `uv run --with <package> python -c "..."`
- 独立脚本必须包含 PEP 723 依赖声明
- 不创建 `.venv`，除非用户明确要求

## 风格

- 遵循 PEP 8
- 函数和变量使用 `snake_case`
- 类使用 `PascalCase`
- 常量使用 `UPPER_SNAKE_CASE`
- 公共函数提供类型提示

```python
def calculate_total(items: list[LineItem]) -> Decimal:
    return sum((item.amount for item in items), Decimal("0"))
```

## 错误处理

- 捕获具体异常，不使用裸 `except`
- 异常信息要能定位问题，但不泄露密钥
- 外部 IO、网络、数据库调用必须考虑失败
- 清理资源使用上下文管理器

```python
from pathlib import Path

def read_config(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except FileNotFoundError as exc:
        raise RuntimeError(f"配置文件不存在: {path}") from exc
```

## 数据建模

- 简单结构用 `dataclass`
- 外部输入用 Pydantic 或明确校验
- 金额使用 `Decimal`，不要用 float
- 时间使用带时区信息的 datetime

## 可维护性

- 函数保持单一职责
- 避免隐藏副作用
- 避免可变默认参数
- 对复杂分支写测试

## 检查清单

- [ ] 类型提示清晰
- [ ] 无裸 `except`
- [ ] 文件和网络资源正确关闭
- [ ] 外部输入已校验
- [ ] 通过 `uv` 运行或验证
