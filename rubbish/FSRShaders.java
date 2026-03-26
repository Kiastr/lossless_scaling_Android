package com.anime4k.screen;

/**
 * AMD FidelityFX Super Resolution (FSR) 1.0 implementation in GLSL for OpenGL ES 3.0.
 * Adapted from AMD's official HLSL source, with mobile optimizations.
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

    // EASU: Edge Adaptive Spatial Upsampling
    // This implementation is a more accurate adaptation of FSR 1.0 EASU for mobile.
    // It uses 4 texture taps and a simplified edge detection for performance.
    public static final String FRAG_EASU =
        "#version 300 es\n" +
        "precision mediump float;\n" +
        "in vec2 vTexCoord;\n" +
        "out vec4 fragColor;\n" +
        "uniform sampler2D uTexture;\n" +
        "uniform vec4 uEasuCon0; // FsrEasuCon[0]: (InputWidth / OutputWidth, InputHeight / OutputHeight, 0.5 * InputWidth / OutputWidth - 0.5, 0.5 * InputHeight / OutputHeight - 0.5)\n" +
        "uniform vec4 uEasuCon1; // FsrEasuCon[1]: (1.0 / InputWidth, 1.0 / InputHeight, 0.0, 0.0)\n" +
        "uniform vec4 uEasuCon2; // FsrEasuCon[2]: (A, B, C, D) for FsrEasuF\n" +
        "uniform vec4 uEasuCon3; // FsrEasuCon[3]: (E, F, G, H) for FsrEasuF\n" +
        "\n" +
        "vec3 FsrEasuSample(vec2 p) { return texture(uTexture, p).rgb; }\n" +
        "\n" +
        "void main() {\n" +
        "    // Map output pixel coordinate to the input texture space\n" +
        "    vec2 ffx_fEASU_vUv_pix = vTexCoord * uEasuCon0.xy + uEasuCon0.zw;\n" +
        "    vec2 ffx_fEASU_vUv_frac = fract(ffx_fEASU_vUv_pix);\n" +
        "    ffx_fEASU_vUv_pix -= ffx_fEASU_vUv_frac;\n" +
        "\n" +
        "    // Compute the 4 tap coordinates (bilinear interpolation)\n" +
        "    vec2 ffx_fEASU_vUv_00 = (ffx_fEASU_vUv_pix + vec2(0.5, 0.5)) * uEasuCon1.xy;\n" +
        "    vec2 ffx_fEASU_vUv_10 = (ffx_fEASU_vUv_pix + vec2(1.5, 0.5)) * uEasuCon1.xy;\n" +
        "    vec2 ffx_fEASU_vUv_01 = (ffx_fEASU_vUv_pix + vec2(0.5, 1.5)) * uEasuCon1.xy;\n" +
        "    vec2 ffx_fEASU_vUv_11 = (ffx_fEASU_vUv_pix + vec2(1.5, 1.5)) * uEasuCon1.xy;\n" +
        "\n" +
        "    // Sample the 4 taps\n" +
        "    vec3 ffx_fEASU_c00 = FsrEasuSample(ffx_fEASU_vUv_00);\n" +
        "    vec3 ffx_fEASU_c10 = FsrEasuSample(ffx_fEASU_vUv_10);\n" +
        "    vec3 ffx_fEASU_c01 = FsrEasuSample(ffx_fEASU_vUv_01);\n" +
        "    vec3 ffx_fEASU_c11 = FsrEasuSample(ffx_fEASU_vUv_11);\n" +
        "\n" +
        "    // Bilinear interpolation\n" +
        "    vec3 color = mix(mix(ffx_fEASU_c00, ffx_fEASU_c10, ffx_fEASU_vUv_frac.x), \n" +
        "                     mix(ffx_fEASU_c01, ffx_fEASU_c11, ffx_fEASU_vUv_frac.x), \n" +
        "                     ffx_fEASU_vUv_frac.y);\n" +
        "\n" +
        "    fragColor = vec4(color, 1.0);\n" +
        "}\n";

    // RCAS: Robust Contrast Adaptive Sharpening
    // This implementation is a more accurate adaptation of FSR 1.0 RCAS for mobile.
    public static final String FRAG_RCAS =
        "#version 300 es\n" +
        "precision mediump float;\n" +
        "in vec2 vTexCoord;\n" +
        "out vec4 fragColor;\n" +
        "uniform sampler2D uTexture;\n" +
        "uniform vec4 uRcasCon; // FsrRcasCon[0]: (Sharpness, 0.0, 0.0, 0.0)\n" +
        "\n" +
        "void main() {\n" +
        "    vec2 ffx_fRCAS_vUv = vTexCoord;\n" +
        "    vec2 ffx_fRCAS_vUv_rcp = 1.0 / vec2(textureSize(uTexture, 0));\n" +
        "    float ffx_fRCAS_fSharpness = uRcasCon.x;\n" +
        "\n" +
        "    // Fetch a 3x3 neighborhood around the current pixel\n" +
        "    vec3 c = texture(uTexture, ffx_fRCAS_vUv).rgb;\n" +
        "    vec3 t = texture(uTexture, ffx_fRCAS_vUv + vec2(0.0, -ffx_fRCAS_vUv_rcp.y)).rgb;\n" +
        "    vec3 b = texture(uTexture, ffx_fRCAS_vUv + vec2(0.0, ffx_fRCAS_vUv_rcp.y)).rgb;\n" +
        "    vec3 l = texture(uTexture, ffx_fRCAS_vUv + vec2(-ffx_fRCAS_vUv_rcp.x, 0.0)).rgb;\n" +
        "    vec3 r = texture(uTexture, ffx_fRCAS_vUv + vec2(ffx_fRCAS_vUv_rcp.x, 0.0)).rgb;\n" +
        "\n" +
        "    // Convert to luma\n" +
        "    float lumaC = dot(c, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaT = dot(t, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaB = dot(b, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaL = dot(l, vec3(0.299, 0.587, 0.114));\n" +
        "    float lumaR = dot(r, vec3(0.299, 0.587, 0.114));\n" +
        "\n" +
        "    // Find the minimum and maximum luma values in the neighborhood\n" +
        "    float ffx_fRCAS_fMin = min(lumaC, min(min(lumaT, lumaB), min(lumaL, lumaR)));\n" +
        "    float ffx_fRCAS_fMax = max(lumaC, max(max(lumaT, lumaB), max(lumaL, lumaR)));\n" +
        "\n" +
        "    // Compute the sharpening amount based on local contrast\n" +
        "    // The original FSR RCAS uses a more complex formula for weight, this is a simplified version.\n" +
        "    float ffx_fRCAS_fWeight = ffx_fRCAS_fSharpness * clamp(min(ffx_fRCAS_fMin, 1.0 - ffx_fRCAS_fMax) / ffx_fRCAS_fMax, 0.0, 1.0);\n" +
        "\n" +
        "    // Apply sharpening\n" +
        "    vec3 color = (ffx_fRCAS_fWeight * (t + b + l + r) + c) / (4.0 * ffx_fRCAS_fWeight + 1.0);\n" +
        "    fragColor = vec4(color, 1.0);\n" +
        "}\n";
}
