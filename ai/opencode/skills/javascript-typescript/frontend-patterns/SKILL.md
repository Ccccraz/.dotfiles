---
name: frontend-patterns
description: React、Next.js、状态管理、性能优化和 UI 实现实践
---

# 前端模式

用于实现或审查 React/Next.js 前端代码。优先遵循项目已有设计系统和组件模式。

## 组件设计

- 组件职责单一
- props 表达业务语义，不暴露内部实现
- 复杂逻辑抽到 hook 或 service
- 列表 key 使用稳定 ID
- loading、empty、error 状态必须明确

## 状态管理

- 本地 UI 状态放组件内
- 跨组件状态使用项目已有 store/context
- 服务端数据优先使用数据请求库或框架机制
- 避免把派生状态重复存储

## React 注意事项

- 不在 render 中触发 state 更新
- `useEffect` 必须有清晰依赖和清理逻辑
- 不默认添加 `useMemo`/`useCallback`，除非已有项目模式或明确性能证据
- 避免 stale closure
- 长列表考虑虚拟化

## Next.js 注意事项

- 明确 server component 和 client component 边界
- 不把密钥传到客户端
- 数据获取位置应靠近使用场景
- loading 和 error 边界要覆盖主要路径

## 可访问性

- 交互元素可键盘操作
- 表单控件有关联 label
- 图片有合适 alt
- 颜色对比度足够
- 弹窗、菜单和焦点管理正确

## 性能

- 图片使用合适尺寸和懒加载
- 避免不必要的大包进入首屏
- 大型计算延后或移出 render
- 请求去重并处理缓存

## 完成检查

- [ ] 移动端和桌面端可用
- [ ] loading/error/empty 状态完整
- [ ] 无明显可访问性问题
- [ ] 无敏感数据泄露到客户端
- [ ] 相关测试或手动验证已完成
