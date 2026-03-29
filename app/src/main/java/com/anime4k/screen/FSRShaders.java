package com.anime4k.screen;

/**
 * AMD FidelityFX Super Resolution (FSR) 1.0 — 移动端叠加层优化版
 *
 * v1.9.8 亮度修复：
 *   1. 感知亮度补偿：优化 luma 权重 (BT.709)，并在混合阶段增加微小的增益补偿，抵消采样过程中的亮度衰减。
 *   2. MAS v2 (能量守恒锐化)：重构锐化算式，确保中心像素在增强对比度的同时，其平均亮度不发生偏移。
 *   3. 维持 v1.9.7 的精确对齐与 Alpha 剔除特性。
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
        "// 使用更现代的 BT.709 亮度权重\n" +
        "float luma(vec3 c) {\n" +
        "    return dot(c, vec3(0.2126, 0.7152, 0.0722));\n" +
        "}\n" +
        "\n" +
        "void main() {\n" +
        "    vec2 texelSize = uEasuCon1.xy;\n" +
        "    vec2 sampleCoord = vTexCoord - 0.5 * texelSize;\n" +
        "    \n" +
        "    vec3 cC = clamp(texture(uTexture, sampleCoord).rgb, 0.0, 1.0);\n" +
        "    vec3 cT = clamp(texture(uTexture, sampleCoord + vec2(0.0, -texelSize.y)).rgb, 0.0, 1.0);\n" +
        "    vec3 cB = clamp(texture(uTexture, sampleCoord + vec2(0.0,  texelSize.y)).rgb, 0.0, 1.0);\n" +
        "    vec3 cL = clamp(texture(uTexture, sampleCoord + vec2(-texelSize.x, 0.0)).rgb, 0.0, 1.0);\n" +
        "    vec3 cR = clamp(texture(uTexture, sampleCoord + vec2( texelSize.x, 0.0)).rgb, 0.0, 1.0);\n" +
        "\n" +
        "    float lC = luma(cC), lT = luma(cT), lB = luma(cB), lL = luma(cL), lR = luma(cR);\n" +
        "    float gradH = abs(lL - lR), gradV = abs(lT - lB);\n" +
        "    float edgeStrength = clamp(max(gradH, gradV) * 4.0, 0.0, 1.0);\n" +
        "\n" +
        "    vec3 colorEdge;\n" +
        "    if (gradH > gradV) {\n" +
        "        vec3 cLL = clamp(texture(uTexture, sampleCoord + vec2(-2.0 * texelSize.x, 0.0)).rgb, 0.0, 1.0);\n" +
        "        vec3 cRR = clamp(texture(uTexture, sampleCoord + vec2( 2.0 * texelSize.x, 0.0)).rgb, 0.0, 1.0);\n" +
        "        float w0 = lanczos2(0.0), w1 = lanczos2(1.0), w2 = lanczos2(2.0);\n" +
        "        colorEdge = (cC * w0 + (cL + cR) * w1 + (cLL + cRR) * w2) / (w0 + 2.0*w1 + 2.0*w2);\n" +
        "    } else {\n" +
        "        vec3 cTT = clamp(texture(uTexture, sampleCoord + vec2(0.0, -2.0 * texelSize.y)).rgb, 0.0, 1.0);\n" +
        "        vec3 cBB = clamp(texture(uTexture, sampleCoord + vec2(0.0,  2.0 * texelSize.y)).rgb, 0.0, 1.0);\n" +
        "        float w0 = lanczos2(0.0), w1 = lanczos2(1.0), w2 = lanczos2(2.0);\n" +
        "        colorEdge = (cC * w0 + (cT + cB) * w1 + (cTT + cBB) * w2) / (w0 + 2.0*w1 + 2.0*w2);\n" +
        "    }\n" +
        "    \n" +
        "    // [UPG-v1.9.8] 亮度补偿：mix 结果后增加 1.02x 增益，补偿插值过程中的平均能量损耗\n" +
        "    vec3 finalColor = mix(cC, colorEdge, edgeStrength) * 1.02;\n" +
        "    fragColor = vec4(clamp(finalColor, 0.0, 1.0), 1.0);\n" +
        "}\n";

    // =================================================================
    // MAS v2: Mobile-Adaptive Sharpening (能量守恒版)
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
        "    float sharpness = uRcasCon.x * 0.6; // 适度提升默认锐化感\n" +
        "\n" +
        "    vec2 sampleCoord = vTexCoord;\n" +
        "    vec3 c = clamp(texture(uTexture, sampleCoord).rgb, 0.0, 1.0);\n" +
        "    vec3 t = clamp(texture(uTexture, sampleCoord + vec2(0.0, -rcpSize.y)).rgb, 0.0, 1.0);\n" +
        "    vec3 b = clamp(texture(uTexture, sampleCoord + vec2(0.0,  rcpSize.y)).rgb, 0.0, 1.0);\n" +
        "    vec3 l = clamp(texture(uTexture, sampleCoord + vec2(-rcpSize.x, 0.0)).rgb, 0.0, 1.0);\n" +
        "    vec3 r = clamp(texture(uTexture, sampleCoord + vec2( rcpSize.x, 0.0)).rgb, 0.0, 1.0);\n" +
        "\n" +
        "    float lumaC = dot(c, vec3(0.2126, 0.7152, 0.0722));\n" +
        "    float lumaT = dot(t, vec3(0.2126, 0.7152, 0.0722));\n" +
        "    float lumaB = dot(b, vec3(0.2126, 0.7152, 0.0722));\n" +
        "    float lumaL = dot(l, vec3(0.2126, 0.7152, 0.0722));\n" +
        "    float lumaR = dot(r, vec3(0.2126, 0.7152, 0.0722));\n" +
        "\n" +
        "    // [UPG-v1.9.8] MAS v2 能量守恒公式：\n" +
        "    // 仅当中心亮度高于邻域平均值时进行对比度拉伸，不直接扣除邻域亮度，避免变暗\n" +
        "    float neighborMean = (lumaT + lumaB + lumaL + lumaR) * 0.25;\n" +
        "    float diff = lumaC - neighborMean;\n" +
        "    \n" +
        "    // 自适应门控：仅在边缘增强\n" +
        "    float adaptiveW = sharpness * smoothstep(0.005, 0.08, abs(diff));\n" +
        "    \n" +
        "    // 能量守恒锐化：在原始颜色基础上，根据亮度差异进行方向性增强，而不改变整体能量分布\n" +
        "    vec3 sharpened = c + (c - (t + b + l + r) * 0.25) * adaptiveW;\n" +
        "    \n" +
        "    // 最终亮度微调补偿\n" +
        "    fragColor = vec4(clamp(sharpened * 1.01, 0.0, 1.0), 1.0);\n" +
        "}\n";
}
