# Anime4K Screen v1.4 修复说明

## 1. 崩溃原因分析

经过对 `Anime4KScreen_v1.3_TouchFix.apk` 的反编译分析，定位到核心崩溃原因如下：

*   **空指针异常 (NPE)**：在 `OverlayService.smali` 的 `startOverlay()` 方法中，当用户开启“无障碍模式”时，代码会通过 `TouchForwardingAccessibilityService.getInstance()` 获取服务实例。如果无障碍服务尚未完全启动或被系统杀死，该方法返回 `null`。随后代码直接调用 `getSystemService("window")`，导致程序立即崩溃。
*   **指令逻辑错误**：Smali 注入逻辑中，`WindowManager.LayoutParams` 的构造被改为了先调用无参构造函数再手动 `iput` 字段。虽然这在某些情况下可行，但缺乏必要的上下文保护。

## 2. 修复方案 (v1.4)

我针对上述问题对 Smali 代码进行了重构，采用了**“无障碍优先 + 安全降级”**的策略：

*   **增强型 Null 安全检查**：
    *   在获取无障碍服务实例前，增加了 `isServiceRunning()` 检查。
    *   在调用 `getInstance()` 后，增加了针对返回值的 `if-eqz` (null 检查)。
    *   在获取 `WindowManager` 后，再次确认对象非空。
*   **自动降级逻辑**：如果上述任何一步检查失败（即无障碍服务未就绪），程序将不再崩溃，而是**自动降级**到“传统模式”（使用 `TYPE_APPLICATION_OVERLAY` 窗口类型），确保应用能够正常启动。
*   **优化窗口参数**：
    *   **无障碍模式**：使用 `TYPE_ACCESSIBILITY_OVERLAY` (0x1020)，设置 `alpha = 1.0`（完全不透明），实现最佳显示效果。
    *   **传统模式**：使用 `TYPE_APPLICATION_OVERLAY` (0x7F6)，设置 `alpha = 0.8`，以绕过 Android 12+ 的触摸屏蔽限制。
*   **渲染优化**：保留了 `renderToScreen` 中的透明清除色设置，确保叠加层不会遮挡背景。

## 3. 使用建议

1.  **推荐开启无障碍服务**：在应用界面开启“无障碍开关”并前往系统设置授权。这将允许应用使用“可信窗口”，实现完全不透明且能穿透触摸。
2.  **崩溃保护**：如果您不开启无障碍服务，应用现在会自动切换到传统模式运行，不再会因为 Smali 逻辑错误而启动即崩溃。

## 4. 文件说明

*   `Anime4KScreen_v1.4_Fixed.apk`：修复后的安装包（已签名）。
