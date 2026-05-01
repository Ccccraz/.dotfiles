---
name: golang-patterns
description: Go 编码实践，覆盖 idiomatic Go、错误处理、并发、接口和性能
---

# Go 模式

用于编写或审查 Go 代码。

## 基本原则

- 简单优先，少抽象
- 小接口由消费者定义
- 错误显式返回，不吞错误
- 并发必须有取消、超时和资源释放
- 公共 API 保持稳定、清晰

## 错误处理

```go
value, err := repo.Find(ctx, id)
if err != nil {
    return nil, fmt.Errorf("find user %s: %w", id, err)
}
```

- 使用 `%w` 包装错误
- 不用 panic 表示业务错误
- sentinel error 使用 `errors.Is`
- 类型错误使用 `errors.As`

## context

- 外部请求、数据库和网络调用必须传递 `context.Context`
- 不把 context 存在 struct 中
- 长任务支持取消

## 接口

```go
type UserStore interface {
    Find(ctx context.Context, id string) (*User, error)
}
```

- 接口保持小而具体
- 不为单个实现提前抽象
- mock 需求不是唯一抽象理由

## 并发

- goroutine 生命周期必须可解释
- channel 关闭方应明确
- 使用 `errgroup` 管理并发错误
- 共享状态用锁或 channel，避免 data race

## 检查命令

```bash
go test ./...
go test -race ./...
go vet ./...
gofmt -w .
```

## 检查清单

- [ ] 错误被处理并保留上下文
- [ ] context 正确传递
- [ ] 无 goroutine 泄漏
- [ ] 公共接口不过度抽象
- [ ] 通过 `gofmt` 和相关测试
