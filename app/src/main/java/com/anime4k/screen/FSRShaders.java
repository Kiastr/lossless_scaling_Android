package com.anime4k.screen;

/**
 * AMD FidelityFX Super Resolution (FSR) 1.0 — 移动端叠加层优化版
 *
 * v1.9.7 精确对齐修复：
 *   1. 0.5 像素中心补偿：修复 vTexCoord 与输入纹理像素中心未对齐导致的单帧虚影。
 *   2. 强制 Alpha 剔除：在读取输入纹理的第一步就丢弃 Alpha，防止输入源的透明度干扰合成。
 *   3. 简化 2x2 邻域采样：利用硬件线性过滤特性，在梯度估计时减少采样点，降低对齐误差。
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
        "    \n" +
        "    // [FIX-v1.9.7] 0.5 像素中心对齐补偿：确保采样点落在输入像素正中心\n" +
        "    // 消除因对齐偏差产生的单帧文字虚影/残影\n" +
        "    vec2 sampleCoord = vTexCoord - 0.5 * texelSize;\n" +
        "    \n" +
        "    // [FIX-v1.9.7] 强制 Alpha 剔除：仅保留 RGB，防止输入源透明度污染合成层\n" +
        "    vec3 cC = clamp(texture(uTexture, sampleCoord).rgb, 0.0, 1.0);\n" +
        "    \n" +
        "    // 梯度估计采样 (2x2 邻域)\n" +
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
        "    // 强制 Alpha=1.0，完全依靠 WindowManager 透明度混合\n" +
        "    fragColor = vec4(clamp(mix(cC, colorEdge, edgeStrength), 0.0, 1.0), 1.0);\n" +
        "}\n";

    // =================================================================
    // MAS: Mobile-Adaptive Sharpening
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
        "    float sharpness = uRcasCon.x * 0.5;\n" +
        "\n" +
        "    // [FIX-v1.9.7] 锐化 Pass 也需要对齐补偿，确保采样点与 EASU 输出一致\n" +
        "    vec2 sampleCoord = vTexCoord;\n" +
        "    \n" +
        "    vec3 c = clamp(texture(uTexture, sampleCoord).rgb, 0.0, 1.0);\n" +
        "    vec3 t = clamp(texture(uTexture, sampleCoord + vec2(0.0, -rcpSize.y)).rgb, 0.0, 1.0);\n" +
        "    vec3 b = clamp(texture(uTexture, sampleCoord + vec2(0.0,  rcpSize.y)).rgb, 0.0, 1.0);\n" +
        "    vec3 l = clamp(texture(uTexture, sampleCoord + vec2(-rcpSize.x, 0.0)).rgb, 0.0, 1.0);\n" +
        "    vec3 r = clamp(texture(uTexture, sampleCoord + vec2( rcpSize.x, 0.0)).rgb, 0.0, 1.0);\n" +
        "\n" +
        "    float lumaC = dot(c, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaT = dot(t, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaB = dot(b, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaL = dot(l, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaR = dot(r, vec3(0.299, 0.587, 0.114));\n" +
        "\n" +
        "    float neighborMean = (lumaT + lumaB + lumaL + lumaR) * 0.25;\n" +
        "    float edge = abs(lumaC - neighborMean);\n" +
        "    float adaptiveW = sharpness * smoothstep(0.01, 0.1, edge);\n" +
        "    \n" +
        "    vec3 sharpened = c + (c - (t + b + l + r) * 0.25) * adaptiveW;\n" +
        "    fragColor = vec4(clamp(sharpened, 0.0, 1.0), 1.0);\n" +
        "}\n";
}
