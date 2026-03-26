# SurfaceView Alpha 行为分析

从 Android 源码注释中发现关键信息：

> "Note: Starting in platform version UPSIDE_DOWN_CAKE (Android 14), SurfaceView will support 
> arbitrary alpha blending. Prior platform versions ignored alpha values on the SurfaceView if 
> they were between 0 and 1."
> 
> "Alpha value of the view is ignored and the underlying surface is rendered opaque by default."

这意味着：
1. Android 14 之前，SurfaceView 的 View alpha 被忽略，Surface 始终以不透明方式渲染
2. Window 的 alpha（LayoutParams.alpha）和 View 的 alpha 是不同的概念
3. LayoutParams.alpha 影响整个窗口的合成，包括其中的 Surface

## 关键区别
- `LayoutParams.alpha` = Window 级别的 alpha，影响 SurfaceFlinger 合成
- `View.setAlpha()` = View 级别的 alpha，Android 14 前对 SurfaceView 无效

## 重新评估方案

如果设置 `LayoutParams.alpha = 0.0`：
- 整个窗口（包括 SurfaceView 的 Surface）都会变成完全透明 → 不可见
- 这不可行

如果设置 `LayoutParams.alpha = 0.8`：
- 叠加层会有 20% 的透明度
- 可以让触摸穿透到其他应用
- 但显示效果会受影响（变半透明）

## 最佳方案：TYPE_ACCESSIBILITY_OVERLAY

根据 Android 官方博文明确指出：
"As a connected accessibility service, it's possible to create windows of type 
TYPE_ACCESSIBILITY_OVERLAY, which are trusted and thus are exempt from the restrictions."

方案：
1. 在 TouchForwardingAccessibilityService 中创建 TYPE_ACCESSIBILITY_OVERLAY 窗口
2. 使用无障碍服务的 Context 获取 WindowManager
3. 窗口类型设为 TYPE_ACCESSIBILITY_OVERLAY（而非 TYPE_APPLICATION_OVERLAY）
4. 保持 FLAG_NOT_TOUCHABLE
5. 这样触摸可以穿透到任何应用

这需要无障碍服务已启用，但这是 Android 12+ 上唯一能让叠加层完全不透明且触摸穿透到其他应用的方案。

## 备选方案：alpha <= 0.8
作为不需要无障碍服务的降级方案。
