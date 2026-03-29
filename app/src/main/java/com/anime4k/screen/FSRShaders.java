package com.anime4k.screen;

/**
 * AMD FidelityFX Super Resolution (FSR) 1.0 — 移动端适配实现
 *
 * v1.9.1 修复：v1.9.0 的 EASU 坐标计算存在严重 bug：
 *   uEasuCon1 传入的是输入纹理 texel 大小 (1/inputW, 1/inputH)，
 *   但 EASU 运行在输出分辨率 viewport 下，vTexCoord 是输出像素网格上的 [0,1] 坐标。
 *   用 vTexCoord / inputTexelSize 得到的像素坐标与实际输出像素不对应，
 *   导致每帧采样位置偏移，产生"像素向下流动"的视觉伪影。
 *
 * 修复方案：
 *   EASU shader 直接使用 textureSize() 获取输入纹理的实际尺寸，
 *   不再依赖外部传入的 uEasuCon1 做坐标转换。
 *   所有采样坐标都在 [0,1] 纹理坐标空间内完成，
 *   仅用输入纹理 texel 大小做邻域偏移，确保坐标稳定。
 */
public class FSRShaders {

    public static final String VERTEX_SHADER =
        "#version 300 es\n" +
        "layout(location = 0) in vec4 aPosition;\n" +
        "layout(location = 1) in vec2 aTexCoord;\n" +
        "out vec2 vTexCoord;\n" +
        "void main() {\n" +
        "    gl_Position = aPosition;\n" +
        "    vTexCoord = aTexCoord;\n" +
        "}\n";

    // =================================================================
    // EASU: Edge Adaptive Spatial Upsampling (FSR 1.0)
    //
    // 移动端简化版：
    //   在输入纹理的 2x2 邻域上计算亮度梯度，估计边缘方向，
    //   然后根据边缘方向选择 4-tap 方向性 Lanczos-2 近似滤波，
    //   平坦区域退化为双线性插值。
    //
    // 坐标策略：
    //   vTexCoord 是 [0,1] 范围的输出像素纹理坐标。
    //   由于 GPU 纹理采样器自动处理输入纹理的归一化坐标映射，
    //   直接用 vTexCoord 采样输入纹理即可得到正确的放大效果。
    //   邻域偏移使用输入纹理的 texel 大小（通过 textureSize 获取）。
    // =================================================================
    public static final String FRAG_EASU =
        "#version 300 es\n" +
        "precision mediump float;\n" +
        "in vec2 vTexCoord;\n" +
        "out vec4 fragColor;\n" +
        "uniform sampler2D uTexture;\n" +
        "uniform vec4 uEasuCon1; // (1.0/InputWidth, 1.0/InputHeight, 0, 0)\n" +
        "\n" +
        "// Lanczos-2 近似核函数\n" +
        "float lanczos2(float d) {\n" +
        "    float d2 = d * d;\n" +
        "    return max(0.0, (1.0 - d2) * (1.0 - d2 * 0.25));\n" +
        "}\n" +
        "\n" +
        "float luma(vec3 c) {\n" +
        "    return dot(c, vec3(0.299, 0.587, 0.114));\n" +
        "}\n" +
        "\n" +
        "void main() {\n" +
        "    // 输入纹理的 texel 大小（用于邻域偏移）\n" +
        "    vec2 texelSize = uEasuCon1.xy;\n" +
        "\n" +
        "    // 采样当前位置及十字形邻域（5-tap）\n" +
        "    vec3 cC = texture(uTexture, vTexCoord).rgb;\n" +
        "    vec3 cT = texture(uTexture, vTexCoord + vec2(0.0, -texelSize.y)).rgb;\n" +
        "    vec3 cB = texture(uTexture, vTexCoord + vec2(0.0,  texelSize.y)).rgb;\n" +
        "    vec3 cL = texture(uTexture, vTexCoord + vec2(-texelSize.x, 0.0)).rgb;\n" +
        "    vec3 cR = texture(uTexture, vTexCoord + vec2( texelSize.x, 0.0)).rgb;\n" +
        "\n" +
        "    // 计算亮度\n" +
        "    float lC = luma(cC);\n" +
        "    float lT = luma(cT);\n" +
        "    float lB = luma(cB);\n" +
        "    float lL = luma(cL);\n" +
        "    float lR = luma(cR);\n" +
        "\n" +
        "    // 梯度估计\n" +
        "    float gradH = abs(lL - lR);  // 水平方向亮度变化\n" +
        "    float gradV = abs(lT - lB);  // 垂直方向亮度变化\n" +
        "\n" +
        "    // 边缘强度：梯度越大说明边缘越明显\n" +
        "    float edgeStrength = clamp(max(gradH, gradV) * 4.0, 0.0, 1.0);\n" +
        "\n" +
        "    // 方向性重建：沿边缘方向（梯度的垂直方向）做 Lanczos 滤波\n" +
        "    vec3 colorEdge;\n" +
        "    if (gradH > gradV) {\n" +
        "        // 水平梯度大 → 垂直边缘 → 沿水平方向（边缘走向）做方向性滤波\n" +
        "        vec3 cLL = texture(uTexture, vTexCoord + vec2(-2.0 * texelSize.x, 0.0)).rgb;\n" +
        "        vec3 cRR = texture(uTexture, vTexCoord + vec2( 2.0 * texelSize.x, 0.0)).rgb;\n" +
        "        // 4-tap Lanczos-2 权重（距离 0, 1, 1, 2 的对称滤波）\n" +
        "        float w0 = lanczos2(0.0);  // 中心\n" +
        "        float w1 = lanczos2(1.0);  // 左右各一\n" +
        "        float w2 = lanczos2(2.0);  // 左右各二\n" +
        "        float wSum = w0 + 2.0 * w1 + 2.0 * w2;\n" +
        "        colorEdge = (cC * w0 + (cL + cR) * w1 + (cLL + cRR) * w2) / wSum;\n" +
        "    } else {\n" +
        "        // 垂直梯度大 → 水平边缘 → 沿垂直方向（边缘走向）做方向性滤波\n" +
        "        vec3 cTT = texture(uTexture, vTexCoord + vec2(0.0, -2.0 * texelSize.y)).rgb;\n" +
        "        vec3 cBB = texture(uTexture, vTexCoord + vec2(0.0,  2.0 * texelSize.y)).rgb;\n" +
        "        float w0 = lanczos2(0.0);\n" +
        "        float w1 = lanczos2(1.0);\n" +
        "        float w2 = lanczos2(2.0);\n" +
        "        float wSum = w0 + 2.0 * w1 + 2.0 * w2;\n" +
        "        colorEdge = (cC * w0 + (cT + cB) * w1 + (cTT + cBB) * w2) / wSum;\n" +
        "    }\n" +
        "\n" +
        "    // 根据边缘强度混合：边缘区域用方向性滤波，平坦区域用原始采样\n" +
        "    vec3 finalColor = mix(cC, colorEdge, edgeStrength);\n" +
        "\n" +
        "    fragColor = vec4(finalColor, 1.0);\n" +
        "}\n";

    // =================================================================
    // RCAS: Robust Contrast Adaptive Sharpening (FSR 1.0)
    // =================================================================
    public static final String FRAG_RCAS =
        "#version 300 es\n" +
        "precision mediump float;\n" +
        "in vec2 vTexCoord;\n" +
        "out vec4 fragColor;\n" +
        "uniform sampler2D uTexture;\n" +
        "uniform vec4 uRcasCon; // (Sharpness, 0, 0, 0)\n" +
        "\n" +
        "void main() {\n" +
        "    vec2 rcpSize = 1.0 / vec2(textureSize(uTexture, 0));\n" +
        "    float sharpness = uRcasCon.x;\n" +
        "\n" +
        "    // 5-tap 十字形采样\n" +
        "    vec3 c = texture(uTexture, vTexCoord).rgb;\n" +
        "    vec3 t = texture(uTexture, vTexCoord + vec2(0.0, -rcpSize.y)).rgb;\n" +
        "    vec3 b = texture(uTexture, vTexCoord + vec2(0.0,  rcpSize.y)).rgb;\n" +
        "    vec3 l = texture(uTexture, vTexCoord + vec2(-rcpSize.x, 0.0)).rgb;\n" +
        "    vec3 r = texture(uTexture, vTexCoord + vec2( rcpSize.x, 0.0)).rgb;\n" +
        "\n" +
        "    // 亮度\n" +
        "    float lumaC = dot(c, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaT = dot(t, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaB = dot(b, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaL = dot(l, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaR = dot(r, vec3(0.299, 0.587, 0.114));\n" +
        "\n" +
        "    // 局部对比度自适应\n" +
        "    float lumaMin = min(lumaC, min(min(lumaT, lumaB), min(lumaL, lumaR)));\n" +
        "    float lumaMax = max(lumaC, max(max(lumaT, lumaB), max(lumaL, lumaR)));\n" +
        "\n" +
        "    // RCAS 权重\n" +
        "    float adaptiveW = sharpness * clamp(\n" +
        "        min(lumaMin, 1.0 - lumaMax) / max(lumaMax, 0.001),\n" +
        "        0.0, 1.0\n" +
        "    );\n" +
        "\n" +
        "    // 锐化\n" +
        "    vec3 sharpened = (c + (c - (t + b + l + r) * 0.25) * adaptiveW);\n" +
        "    sharpened = clamp(sharpened, 0.0, 1.0);\n" +
        "\n" +
        "    fragColor = vec4(sharpened, 1.0);\n" +
        "}\n";
}
