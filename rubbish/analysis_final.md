# 最终分析与解决方案

## 根本原因确认

Android 12+ 的 Untrusted Touch Occlusion 机制：
- `TYPE_APPLICATION_OVERLAY` + `FLAG_NOT_TOUCHABLE` 的窗口被视为不受信任
- 触摸穿透到**同一应用**的窗口被豁免（这就是为什么在超分应用内可以操作）
- 触摸穿透到**其他应用**的窗口被阻止

## 例外情况（可以穿透到其他应用）
1. 不可见窗口（root view 为 GONE 或 INVISIBLE）
2. 完全透明窗口（alpha = 0.0）
3. 足够半透明的 TYPE_APPLICATION_OVERLAY 窗口（alpha <= 0.8）
4. 可信窗口（TYPE_ACCESSIBILITY_OVERLAY）

## 当前代码问题
- `overlayParams.alpha = 1.0f` — 完全不透明，不满足任何例外条件
- 所以触摸被阻止穿透到其他应用

## 可行解决方案

### 方案 1：使用 TYPE_ACCESSIBILITY_OVERLAY（最佳方案）
- 通过无障碍服务创建 TYPE_ACCESSIBILITY_OVERLAY 类型的窗口
- 这种窗口是"可信窗口"，不受 untrusted touch 限制
- FLAG_NOT_TOUCHABLE 可以正常工作
- 需要无障碍服务已启用
- 文档明确说明："As a connected accessibility service, it's possible to create windows of type TYPE_ACCESSIBILITY_OVERLAY, which are trusted and thus are exempt"

### 方案 2：设置 alpha <= 0.8
- 将 overlayParams.alpha 设为 0.8 或更低
- 问题：叠加层会变半透明，影响超分显示效果
- 但 SurfaceView 的 Surface 是独立层，Window alpha 可能不影响 Surface 内容
- 需要测试验证

### 方案 3：alpha = 0.0（完全透明窗口）
- 窗口完全透明，触摸可以穿透
- SurfaceView 使用 setZOrderOnTop(true)，其 Surface 在独立层上
- Window alpha 不影响 SurfaceView 的 Surface 内容显示
- 这是最简单的方案！

## 选择方案 3 作为主要修复

理由：
1. SurfaceView 的 Surface 是独立于 Window 的图形层
2. setZOrderOnTop(true) 使 Surface 在 Window 之上
3. Window alpha = 0.0 使 Window 本身完全透明（对触摸系统来说是"完全透明窗口"）
4. 但 SurfaceView 的 Surface 内容不受 Window alpha 影响，仍然可见
5. 这样既能显示超分内容，又能让触摸穿透

同时提供方案 1 作为备选（通过无障碍服务使用 TYPE_ACCESSIBILITY_OVERLAY）
