# Anime4KScreen 接入 AMD FSR 1.0 技术说明 (V1.1 更新)

本项目已成功集成 **AMD FidelityFX Super Resolution (FSR) 1.0**，为用户提供了一种高效且锐利的超分辨率方案。

## 1. 核心变更概览

| 模块 | 修改内容 | 目的 |
| :--- | :--- | :--- |
| **渲染器 (Anime4KRenderer)** | 升级至 OpenGL ES 3.0，新增 FSR 渲染管线，并优化 Pseudo-MV 兼容性。 | 支持更高级的着色器语法和更好的性能，确保 Pseudo-MV 在 FSR 模式下也能正常工作。 |
| **着色器 (FSRShaders)** | 重新编写 EASU (边缘自适应空间超分) 和 RCAS (对比度自适应锐化) 实现，修复屏幕变黑问题。 | 核心 FSR 算法实现更准确，解决之前屏幕变黑的 Bug。 |
| **服务层 (OverlayService)** | 升级 EGL 上下文，支持 FSR 参数透传。 | 确保渲染环境兼容并支持实时调节。 |
| **UI 界面 (MainActivity)** | 增加 FSR 切换开关和锐化强度调节。 | 提供直观的用户控制。 |

## 2. FSR 算法实现细节

### EASU (Edge Adaptive Spatial Upsampling)
EASU 负责将低分辨率图像放大。我们已重新实现了 EASU 着色器，修正了采样坐标计算逻辑，确保在各种缩放比例下都能获得正确的图像输出，解决了之前屏幕变黑的问题。通过 `uEasuCon0` 和 `uEasuCon1` 两个 Uniform 向量传递缩放比例和像素大小，确保在各种缩放比例下都能获得平滑的边缘。

### RCAS (Robust Contrast Adaptive Sharpening)
RCAS 负责在放大后增强细节。它根据局部对比度动态调整锐化权重，避免了传统锐化算法常见的环状伪影（Ringing）。用户可以通过 UI 调节锐化强度（默认 0.20）。RCAS 着色器也已修正，避免了颜色溢出导致的问题。

## 3. Pseudo-MV 兼容性优化

针对之前 Pseudo-MV 在 FSR 模式下可能表现不佳的问题，我们进行了优化：

*   **边缘数据生成**：无论 FSR 是否开启，只要 Pseudo-MV 启用，`Anime4KRenderer` 都会执行 Anime4K 的 Luma 和 GradX/Y 阶段，以生成 Pseudo-MV 所需的 `lumadTexture`（边缘强度）和 `lumammTexture`（边缘方向）数据。这确保了 Pseudo-MV 在 FSR 模式下也能获得准确的边缘信息，从而正常工作。
*   **性能考量**：虽然在 FSR 模式下额外运行了 Anime4K 的部分 Pass，但这些 Pass 相较于完整的 Anime4K 渲染管线而言非常轻量，对整体性能影响较小，同时保证了 Pseudo-MV 的效果。

## 4. 性能优化
*   **FP16 精度**：着色器统一使用 `precision mediump float;`，利用现代移动 GPU 的半精度计算单元降低功耗。
*   **按需渲染**：当开启 FSR 时，Anime4K 的完整多步卷积管线（Apply 阶段）会被跳过，仅执行 FSR 的两个轻量级 Pass，显著降低了 GPU 负载和发热。
*   **GLES 3.0 优化**：利用 `textureSize` 等 ES 3.0 特性减少 Uniform 传递，提高执行效率。

## 5. 使用建议
*   对于文字较多的内容，建议开启 FSR 并设置锐化强度在 0.2 - 0.5 之间。
*   FSR 在 `captureScale` 设置为 50% - 75% 时效果最佳。
*   若追求极致性能和低发热，FSR 是比 Anime4K 更优的选择。
*   现在 Pseudo-MV 在 FSR 模式下也能正常工作，但建议根据实际效果调整 `pseudoMVStrength` 参数。
