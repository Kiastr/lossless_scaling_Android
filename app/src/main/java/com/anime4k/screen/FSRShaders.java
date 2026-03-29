package com.anime4k.screen;

/**
 * AMD FidelityFX Super Resolution (FSR) 1.0 — 移动端适配实现
 *
 * v1.9.2 修复：FSR 模式在叠加层透明度 60% 及以上时颜色失真和色块问题。
 *
 * 问题根因：
 *   1. RCAS 锐化算法通过中心像素增强和邻域像素负权重来提升清晰度。
 *      在计算过程中，`(c * (1.0 + 4.0 * w) - (t + b + l + r) * w)` 极易产生超出 [0, 1] 的负值或过大值。
 *   2. 叠加层透明度通过 WindowManager.LayoutParams.alpha 控制，系统合成器在处理
 *      PixelFormat.TRANSLUCENT 表面时，对超出范围的 RGB 值（尤其是负值或 NaN）
 *      非常敏感，会导致合成器产生错误的色块。
 *   3. 原 EASU 和 RCAS 强制输出 Alpha=1.0，导致在半透明叠加层下，系统无法正确
 *      对超分后的像素进行 Alpha 混合，从而产生累积性的颜色失真。
 *
 * 修复方案：
 *   - 在 RCAS Pass 结尾增加严格的 clamp(0.0, 1.0) 约束，确保输出颜色符合标准。
 *   - 保持 Alpha 通道的一致性，确保系统合成器能正确混合。
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
    // =================================================================
    public static final String FRAG_EASU =
        "#version 300 es\n" +
        "precision mediump float;\n" +
        "in vec2 vTexCoord;\n" +
        "out vec4 fragColor;\n" +
        "uniform sampler2D uTexture;\n" +
        "uniform vec4 uEasuCon1; // (1.0/InputWidth, 1.0/InputHeight, 0, 0)\n" +
        "\n" +
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
        "    vec2 texelSize = uEasuCon1.xy;\n" +
        "\n" +
        "    vec4 tC = texture(uTexture, vTexCoord);\n" +
        "    vec3 cC = tC.rgb;\n" +
        "    vec3 cT = texture(uTexture, vTexCoord + vec2(0.0, -texelSize.y)).rgb;\n" +
        "    vec3 cB = texture(uTexture, vTexCoord + vec2(0.0,  texelSize.y)).rgb;\n" +
        "    vec3 cL = texture(uTexture, vTexCoord + vec2(-texelSize.x, 0.0)).rgb;\n" +
        "    vec3 cR = texture(uTexture, vTexCoord + vec2( texelSize.x, 0.0)).rgb;\n" +
        "\n" +
        "    float lC = luma(cC);\n" +
        "    float lT = luma(cT);\n" +
        "    float lB = luma(cB);\n" +
        "    float lL = luma(cL);\n" +
        "    float lR = luma(cR);\n" +
        "\n" +
        "    float gradH = abs(lL - lR);\n" +
        "    float gradV = abs(lT - lB);\n" +
        "\n" +
        "    float edgeStrength = clamp(max(gradH, gradV) * 4.0, 0.0, 1.0);\n" +
        "\n" +
        "    vec3 colorEdge;\n" +
        "    if (gradH > gradV) {\n" +
        "        vec3 cLL = texture(uTexture, vTexCoord + vec2(-2.0 * texelSize.x, 0.0)).rgb;\n" +
        "        vec3 cRR = texture(uTexture, vTexCoord + vec2( 2.0 * texelSize.x, 0.0)).rgb;\n" +
        "        float w0 = lanczos2(0.0);\n" +
        "        float w1 = lanczos2(1.0);\n" +
        "        float w2 = lanczos2(2.0);\n" +
        "        float wSum = w0 + 2.0 * w1 + 2.0 * w2;\n" +
        "        colorEdge = (cC * w0 + (cL + cR) * w1 + (cLL + cRR) * w2) / wSum;\n" +
        "    } else {\n" +
        "        vec3 cTT = texture(uTexture, vTexCoord + vec2(0.0, -2.0 * texelSize.y)).rgb;\n" +
        "        vec3 cBB = texture(uTexture, vTexCoord + vec2(0.0,  2.0 * texelSize.y)).rgb;\n" +
        "        float w0 = lanczos2(0.0);\n" +
        "        float w1 = lanczos2(1.0);\n" +
        "        float w2 = lanczos2(2.0);\n" +
        "        float wSum = w0 + 2.0 * w1 + 2.0 * w2;\n" +
        "        colorEdge = (cC * w0 + (cT + cB) * w1 + (cTT + cBB) * w2) / wSum;\n" +
        "    }\n" +
        "\n" +
        "    vec3 finalColor = mix(cC, colorEdge, edgeStrength);\n" +
        "    // 保持原始 Alpha 值，并对颜色进行初步限制\n" +
        "    fragColor = vec4(clamp(finalColor, 0.0, 1.0), tC.a);\n" +
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
        "    vec4 tC = texture(uTexture, vTexCoord);\n" +
        "    vec3 c = tC.rgb;\n" +
        "    vec3 t = texture(uTexture, vTexCoord + vec2(0.0, -rcpSize.y)).rgb;\n" +
        "    vec3 b = texture(uTexture, vTexCoord + vec2(0.0,  rcpSize.y)).rgb;\n" +
        "    vec3 l = texture(uTexture, vTexCoord + vec2(-rcpSize.x, 0.0)).rgb;\n" +
        "    vec3 r = texture(uTexture, vTexCoord + vec2( rcpSize.x, 0.0)).rgb;\n" +
        "\n" +
        "    float lumaC = dot(c, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaT = dot(t, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaB = dot(b, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaL = dot(l, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaR = dot(r, vec3(0.299, 0.587, 0.114));\n" +
        "\n" +
        "    float lumaMin = min(lumaC, min(min(lumaT, lumaB), min(lumaL, lumaR)));\n" +
        "    float lumaMax = max(lumaC, max(max(lumaT, lumaB), max(lumaL, lumaR)));\n" +
        "\n" +
        "    // RCAS 自适应权重\n" +
        "    float adaptiveW = sharpness * clamp(\n" +
        "        min(lumaMin, 1.0 - lumaMax) / max(lumaMax, 0.001),\n" +
        "        0.0, 1.0\n" +
        "    );\n" +
        "\n" +
        "    // 应用锐化：中心像素增强，周围像素负权重\n" +
        "    // 关键修复：增加严格的 clamp 限制，防止负值或溢出值破坏 Alpha 混合逻辑\n" +
        "    vec3 sharpened = c + (c - (t + b + l + r) * 0.25) * adaptiveW;\n" +
        "    sharpened = clamp(sharpened, 0.0, 1.0);\n" +
        "\n" +
        "    // 继承 EASU 的 Alpha 通道，确保系统合成器正确混合透明度\n" +
        "    fragColor = vec4(sharpened, tC.a);\n" +
        "}\n";
}
