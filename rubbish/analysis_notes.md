# Android 12 Untrusted Touch Occlusion 分析

## 关键规则

1. Android 12 阻止触摸穿透通过不安全的叠加层
2. 使用 `FLAG_NOT_TOUCHABLE` 的 `TYPE_APPLICATION_OVERLAY` 窗口受此限制
3. **例外情况**：
   - 同一应用内的交互（这解释了为什么自己的应用内可以穿透）
   - 可信窗口（无障碍窗口、输入法窗口、助手窗口）
   - 不可见窗口（root view 为 GONE 或 INVISIBLE）
   - 完全透明窗口（alpha = 0.0）
   - 足够半透明的系统警告窗口（组合不透明度 <= 0.8）

## 当前代码的问题

代码中 `overlayParams.alpha = 1.0f`，这意味着窗口完全不透明。
但这不属于任何例外情况中的"完全透明"（alpha=0.0）。

**关键发现**：`FLAG_NOT_TOUCHABLE` 的窗口在 Android 12+ 上，如果窗口不透明（alpha > 0），
系统会认为它在遮挡下方的应用，从而阻止触摸穿透到其他应用的窗口。
同一应用内的窗口被豁免，所以自己的应用内可以正常操作。

## 解决方案

根据文档，有以下几种可行方案：

### 方案 A：将窗口设为完全透明 (alpha = 0.0)
- 问题：alpha=0 窗口完全不可见，但我们需要显示超分内容

### 方案 B：使用可信窗口类型（无障碍窗口）
- 无障碍窗口是可信的，不受此限制
- 可以通过无障碍服务创建窗口

### 方案 C：使 alpha 足够低（<= 0.8 的最大遮挡不透明度）
- 但这会影响显示效果

### 方案 D：使用 InputManager 注入（需要系统权限）

### 实际可行方案：
由于 FLAG_NOT_TOUCHABLE 在 Android 12+ 上对跨应用触摸被阻止，
而"足够半透明"的阈值是 0.8，我们可以将 alpha 设为 0.8 或更低。
但这会导致叠加层半透明，影响显示效果。

**最佳方案**：结合 alpha = 0.0（使窗口对触摸系统完全透明）+ 使用独立的 Surface 层来显示内容。
实际上，当 alpha = 0.0 时，窗口被视为"完全透明"，触摸可以穿透。
但 SurfaceView 的内容是在独立的 Surface 上渲染的，不受 Window alpha 影响。
所以设置 alpha = 0.0 可能让窗口框架透明但 SurfaceView 内容仍然可见！

需要验证：SurfaceView 的 Surface 层是否独立于 Window 的 alpha 设置。
