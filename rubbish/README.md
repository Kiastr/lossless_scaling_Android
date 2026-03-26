# Anime4K Screen — 安卓实时屏幕超分辨率应用

## 概述

Anime4K Screen 是一款 Android 应用，利用 **MediaProjection 屏幕录制 API** 实时捕获屏幕内容，通过 **Anime4K v3.2 超分辨率算法**（OpenGL ES 2.0 着色器实现）进行画质增强处理，然后通过 **SYSTEM_ALERT_WINDOW 悬浮窗叠加层** 将处理后的画面覆盖显示在屏幕上。用户可以透过叠加层正常操控底层应用。

## 技术架构

### 核心流程

```
屏幕内容 → MediaProjection 捕获（降低分辨率）
    → ImageReader 获取帧数据
    → Bitmap 转换
    → OpenGL ES 2.0 多 Pass 渲染（Anime4K 算法）
    → 悬浮窗 SurfaceView 显示处理后画面
```

### Anime4K 算法实现

应用完整移植了 **Anime4K-v3.2-Upscale-Original-x2** 算法，包含 6 个渲染 Pass：

| Pass | 名称 | 功能 |
|------|------|------|
| 1 | Luma 提取 | 从 RGB 图像提取亮度通道 |
| 2 | Gradient X (第一轮) | 计算水平方向梯度 |
| 3 | Gradient Y (第一轮) | 计算垂直梯度 + Sobel 边缘检测 + 多项式拟合边缘强度 |
| 4 | Gradient X (第二轮) | 计算边缘方向的水平分量 |
| 5 | Gradient Y (第二轮) | 计算边缘方向的垂直分量 + 归一化 |
| 6 | Apply | 根据边缘方向和强度进行定向插值混合 |

### 悬浮窗叠加

- 使用 `TYPE_APPLICATION_OVERLAY` 窗口类型
- 设置 `FLAG_NOT_TOUCHABLE` + `FLAG_NOT_FOCUSABLE` 实现触摸穿透
- 通过 `SurfaceView` + EGL Window Surface 直接 GPU 渲染到叠加层
- 类似夜间屏幕滤镜应用（如 Twilight、f.lux）的实现方式

### 屏幕捕获

- 使用 `MediaProjection` + `VirtualDisplay` + `ImageReader`
- 捕获分辨率可调（默认为屏幕分辨率的 50%）
- 通过 Anime4K 超分后输出到全屏分辨率

## 系统要求

- Android 8.0 (API 26) 及以上
- 需要授予「显示在其他应用上层」（悬浮窗）权限
- 需要授予屏幕录制权限
- 建议设备具有较好的 GPU 性能以获得流畅体验

## 使用方法

1. 安装 APK 并打开应用
2. 调整设置参数：
   - **捕获缩放比例**：降低可提高性能，升高可提高画质（默认 50%）
   - **超分强度**：控制 Anime4K 边缘增强的强度（默认 0.50）
   - **帧间隔**：控制处理帧率，增大可降低 GPU 负载（默认 100ms）
3. 点击「启动超分」按钮
4. 授予屏幕录制权限
5. 应用将最小化，超分后的画面将覆盖显示在屏幕上
6. 所有触摸操作会穿透叠加层到达底层应用
7. 通过通知栏点击「停止」或返回应用点击「停止超分」来关闭

## 可调参数说明

| 参数 | 范围 | 默认值 | 说明 |
|------|------|--------|------|
| 捕获缩放 | 25%-75% | 50% | 捕获分辨率相对于屏幕分辨率的比例 |
| 超分强度 | 0.00-1.00 | 0.50 | Anime4K 边缘增强强度 |
| 帧间隔 | 33ms-500ms | 100ms | 帧处理间隔，越小帧率越高 |

## 注意事项

1. **延迟**：由于屏幕捕获→处理→显示的流程，存在一定延迟（约 100-300ms），这是设计上的妥协
2. **递归捕获**：叠加层会被 MediaProjection 捕获到，但由于超分后的内容与原始内容视觉差异不大，不会造成明显的递归放大问题
3. **Android 12+ 触摸穿透限制**：Android 12 对 `FLAG_NOT_TOUCHABLE` 的触摸穿透行为有所限制，叠加层设置为完全不透明以确保兼容
4. **电量消耗**：持续的屏幕捕获和 GPU 处理会增加电量消耗
5. **性能**：在低端设备上建议增大帧间隔、降低捕获缩放比例

## 项目结构

```
Anime4KScreen/
├── app/src/main/
│   ├── AndroidManifest.xml          # 权限声明和组件注册
│   ├── java/com/anime4k/screen/
│   │   ├── MainActivity.java        # 主界面 Activity
│   │   ├── OverlayService.java      # 核心前台服务
│   │   └── Anime4KRenderer.java     # Anime4K OpenGL ES 渲染器
│   └── res/
│       ├── layout/activity_main.xml  # 主界面布局
│       ├── values/strings.xml        # 字符串资源
│       ├── values/themes.xml         # 主题样式
│       └── drawable/ic_launcher.xml  # 应用图标
├── build.gradle                      # 根构建脚本
├── app/build.gradle                  # 应用构建脚本
└── settings.gradle                   # 项目设置
```

## 开源协议

- 应用代码：MIT License
- Anime4K 算法：MIT License (Copyright (c) 2019-2021 bloc97)
- 项目地址：https://github.com/bloc97/Anime4K
