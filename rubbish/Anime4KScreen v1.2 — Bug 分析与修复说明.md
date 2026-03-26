# Anime4KScreen v1.2 — Bug 分析与修复说明

## 问题一：输出层无法透传触摸事件到原始层

### 根本原因

原始设计将触摸透传分为两种模式，由用户在 UI 的 `accessibilitySwitch` 开关决定：

- **无障碍模式**（`useAccessibilityMode = true`）：使用 `TouchInterceptView` 接收触摸，再通过 `TouchForwardingAccessibilityService.dispatchGesture()` 将手势重新注入系统。
- **传统模式**（`useAccessibilityMode = false`）：设置 `FLAG_NOT_TOUCHABLE`，让触摸事件直接穿透叠加层。

**无障碍模式的致命缺陷**在于 `dispatchGesture()` 的工作原理：它是由无障碍服务向系统**重新注入**一个全局手势，该手势会被发送到**当前焦点窗口**，而非叠加层下方的窗口。由于叠加层本身（`TYPE_APPLICATION_OVERLAY`）在无障碍模式下没有设置 `FLAG_NOT_TOUCHABLE`，它会持续持有触摸焦点，导致 `dispatchGesture()` 注入的手势又回到了叠加层自身，形成死循环，底层应用永远收不到任何触摸事件。

此外，`TouchInterceptView.onTouchEvent()` 中存在一个逻辑错误：当无障碍服务实例为 `null` 时，方法直接 `return true`（消费事件），而不是 `return false`（放弃事件让系统穿透），导致即使服务未启动，触摸事件也被吞掉。

**传统模式**（`FLAG_NOT_TOUCHABLE`）才是正确且可靠的实现路径。在 Android 12+ 上，`FLAG_NOT_TOUCHABLE` 对于 `TYPE_APPLICATION_OVERLAY` 类型的窗口依然完全有效，并不存在注释中所说的"可能无法正常工作"的问题。

### 修复方案

废弃无障碍触摸转发路径，统一使用 `FLAG_NOT_TOUCHABLE` 实现触摸穿透。具体改动如下：

**`OverlayService.java`**：`startOverlay()` 方法中，无论 `useAccessibilityMode` 取何值，均使用普通 `SurfaceView`，并统一设置 `FLAG_NOT_TOUCHABLE` 标志，移除两套分支逻辑。

**`MainActivity.java`**：将无障碍开关、状态文本、引导按钮在运行时隐藏（`GONE`），并将传递给 Service 的 `useAccessibility` 参数固定为 `false`，避免用户误操作进入已知失效的无障碍模式。

---

## 问题二：输出层存在多帧残影

### 根本原因

残影问题源于 OpenGL ES 的**双缓冲（Double Buffering）机制**与 `EGLSurface` 的状态管理缺陷共同作用。

`OverlayService` 使用 EGL 将渲染结果输出到 `SurfaceView` 对应的 `EGLSurface`（`eglOverlaySurface`）。EGL 窗口 Surface 默认采用双缓冲：前缓冲（front buffer）显示在屏幕上，后缓冲（back buffer）用于绘制，`eglSwapBuffers()` 负责交换两者。

问题出在 `renderToOverlay()` 方法中，每次渲染前**没有调用 `glClear()` 清空后缓冲区**。这意味着每一帧绘制时，后缓冲中残留着上上帧（即两帧前）的内容。当新的超分结果只覆盖了部分区域，或者由于 `SurfaceHolder` 格式为 `TRANSLUCENT` 导致 Alpha 混合不完整时，旧内容就会透出，形成"多帧之前的残影"。

此外，`Anime4KRenderer.renderToScreen()` 中虽然调用了 `glClearColor(0, 0, 0, 1)` 并执行了 `glClear()`，但清除色的 Alpha 值为 `1`（完全不透明黑色），这会在每帧渲染时先用黑色填充整个 Surface，再绘制超分图像。当超分图像完整覆盖全屏时，这不会造成问题；但当 EGL Surface 与 SurfaceHolder 的 `TRANSLUCENT` 格式产生混合时，黑色底色会参与合成，导致画面偏暗或出现黑边。

### 修复方案

**`OverlayService.java`**：在 `renderToOverlay()` 方法中，于 `eglMakeCurrent()` 之后、`renderer.renderToScreen()` 之前，显式调用 `GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT)` 清空当前后缓冲区，确保每帧都从干净的画布开始渲染，彻底消除跨帧残留。

**`Anime4KRenderer.java`**：将 `renderToScreen()` 中的 `glClearColor(0, 0, 0, 1)` 改为 `glClearColor(0, 0, 0, 0)`，即以完全透明色清除，与 `SurfaceHolder.setFormat(PixelFormat.TRANSLUCENT)` 的设置保持一致，避免黑色底色参与合成。

---

## 修改文件汇总

| 文件 | 修改内容 |
|------|----------|
| `OverlayService.java` | 统一使用普通 `SurfaceView`；窗口标志统一为 `FLAG_NOT_TOUCHABLE`；`renderToOverlay()` 中添加 `glClear()` |
| `Anime4KRenderer.java` | `renderToScreen()` 中 `glClearColor` 的 Alpha 从 `1` 改为 `0` |
| `MainActivity.java` | 隐藏无障碍相关 UI 控件；`useAccessibility` 参数固定为 `false` |

---

## 关于无障碍服务的后续建议

`TouchForwardingAccessibilityService` 和 `TouchInterceptView` 两个类目前已不在主路径上使用，可以保留以备将来探索，但建议在文档中注明其局限性：`dispatchGesture()` 注入的手势目标是系统焦点窗口，而非坐标下方的窗口，因此无法实现"透过叠加层操控底层"的目标。若未来需要此功能，需要结合 `AccessibilityWindowInfo` 动态管理焦点，或使用 `InputManager`（需要系统签名权限）等更底层的方案。