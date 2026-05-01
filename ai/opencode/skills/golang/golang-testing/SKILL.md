---
name: golang-testing
description: Go 测试模式，覆盖表驱动测试、子测试、benchmark、fuzz、race 和覆盖率
---

# Go 测试

用于为 Go 代码设计、编写或审查测试。

## 常用命令

```bash
go test ./...
go test -race ./...
go test -cover ./...
go test -run TestName ./pkg/...
go test -bench=. ./...
```

## 表驱动测试

```go
func TestNormalize(t *testing.T) {
    tests := []struct {
        name string
        input string
        want string
    }{
        {name: "去除空格", input: " hello ", want: "hello"},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got := Normalize(tt.input)
            if got != tt.want {
                t.Fatalf("got %q, want %q", got, tt.want)
            }
        })
    }
}
```

## 测试原则

- 测行为，不测实现细节
- 每个测试用例有清晰名称
- 使用 `t.Helper()` 封装测试辅助函数
- 使用 `t.TempDir()` 管理临时文件
- 并发代码运行 race 检查

## 模拟对象与依赖

- 优先用小接口隔离外部依赖
- 不模拟标准库简单行为
- 数据库测试可用事务回滚或测试容器

## 性能基准

- 只对关键路径做性能基准
- 使用 `b.ReportAllocs()` 观察分配
- 避免编译器优化掉被测逻辑

## 模糊测试

- 适合解析器、编码器、校验器
- 保留发现的失败输入作为回归测试

## 检查清单

- [ ] 正常、边界、错误路径都有覆盖
- [ ] 并发代码通过 `go test -race`
- [ ] 测试无顺序依赖
- [ ] 失败信息包含实际值和期望值
