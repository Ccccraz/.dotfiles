---
name: python-testing
description: Python 测试策略，覆盖 pytest、fixture、mock、参数化、覆盖率和回归验证
---

# Python 测试

用于为 Python 代码设计、编写或审查测试。默认使用 pytest。

## 运行方式

```bash
uv run pytest
uv run pytest tests/test_example.py -q
uv run pytest --maxfail=1 -q
```

## 测试结构

- 单元测试覆盖纯逻辑
- 集成测试覆盖数据库、文件系统、外部服务边界
- 回归测试覆盖已修复 bug
- 参数化测试覆盖边界输入

```python
import pytest

@pytest.mark.parametrize(
    ("value", "expected"),
    [(1, True), (0, False)],
)
def test_is_positive(value: int, expected: bool) -> None:
    assert is_positive(value) is expected
```

## 测试夹具

- 测试夹具只做必要准备
- 避免过深的测试夹具依赖
- 涉及文件系统使用 `tmp_path`
- 涉及时间使用可控时钟或模拟对象

## 模拟对象原则

- 模拟外部系统，不模拟被测业务逻辑
- 断言关键调用参数
- 不让模拟对象掩盖真实集成问题

## 断言

- 断言行为结果，不依赖实现细节
- 错误路径使用 `pytest.raises`
- 浮点值使用近似比较

## 检查清单

- [ ] 正常路径和错误路径都有覆盖
- [ ] 边界条件有参数化测试
- [ ] 测试可独立运行
- [ ] 无真实网络或不可控外部依赖
- [ ] 失败信息能定位问题
