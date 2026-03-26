package com.anime4k.screen;

import android.graphics.Bitmap;
import android.opengl.GLES20;
import android.opengl.GLES30;
import android.opengl.GLUtils;
import android.util.Log;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;

/**
 * Anime4K renderer using OpenGL ES 3.0.
 * Supports Anime4K-v3.2 and AMD FSR 1.0.
 */
public class Anime4KRenderer {

    private static final String TAG = "Anime4KRenderer";

    private static final float[] QUAD_VERTICES = {
        -1f, -1f, 0f, 0f,
         1f, -1f, 1f, 0f,
        -1f,  1f, 0f, 1f,
         1f,  1f, 1f, 1f,
    };

    private static final float[] QUAD_VERTICES_FLIPPED = {
        -1f, -1f, 0f, 1f,
         1f, -1f, 1f, 1f,
        -1f,  1f, 0f, 0f,
         1f,  1f, 1f, 0f,
    };

    private FloatBuffer vertexBuffer;
    private FloatBuffer vertexBufferFlipped;

    // Anime4K Shader programs
    private int programLuma;
    private int programGradX1;
    private int programGradY1;
    private int programGradX2;
    private int programGradY2;
    private int programApply;
    private int programPseudoMV;
    private int programPassthrough;

    // FSR Shader programs
    private int programFsrEasu;
    private int programFsrRcas;

    // FBOs and textures
    private int[] fbo = new int[7];
    private int inputTexture;
    private int lumaTexture;
    private int lumadTexture;
    private int lumammTexture;
    private int outputTexture;
    private int lastOutputTexture;
    private int fsrTempTexture;

    private int inputWidth, inputHeight;
    private int outputWidth, outputHeight;
    private float refineStrength = 0.5f;
    private float pseudoMVStrength = 0.5f;
    private boolean fsrEnabled = false;
    private float fsrSharpness = 0.2f;

    private boolean initialized = false;

    // Vertex shader (ES 2.0 style for compatibility)
    private static final String VERTEX_SHADER =
        "attribute vec4 aPosition;\n" +
        "attribute vec2 aTexCoord;\n" +
        "varying vec2 vTexCoord;\n" +
        "void main() {\n" +
        "    gl_Position = aPosition;\n" +
        "    vTexCoord = aTexCoord;\n" +
        "}\n";

    // Pass 1: Extract luma
    private static final String FRAG_LUMA =
        "precision mediump float;\n" +
        "varying vec2 vTexCoord;\n" +
        "uniform sampler2D uTexture;\n" +
        "void main() {\n" +
        "    vec4 c = texture2D(uTexture, vTexCoord);\n" +
        "    float luma = dot(vec3(0.299, 0.587, 0.114), c.rgb);\n" +
        "    gl_FragColor = vec4(luma, 0.0, 0.0, 1.0);\n" +
        "}\n";

    // Pass 2: Gradient X (first pass)
    private static final String FRAG_GRAD_X1 =
        "precision mediump float;\n" +
        "varying vec2 vTexCoord;\n" +
        "uniform sampler2D uLuma;\n" +
        "uniform vec2 uTexelSize;\n" +
        "void main() {\n" +
        "    float l = texture2D(uLuma, vTexCoord + vec2(-uTexelSize.x, 0.0)).r;\n" +
        "    float c = texture2D(uLuma, vTexCoord).r;\n" +
        "    float r = texture2D(uLuma, vTexCoord + vec2(uTexelSize.x, 0.0)).r;\n" +
        "    float xgrad = (-l + r);\n" +
        "    float ygrad = (l + c + c + r);\n" +
        "    gl_FragColor = vec4(xgrad * 0.5 + 0.5, ygrad * 0.25 + 0.5, 0.0, 1.0);\n" +
        "}\n";

    // Pass 3: Gradient Y (first pass)
    private static final String FRAG_GRAD_Y1 =
        "precision mediump float;\n" +
        "varying vec2 vTexCoord;\n" +
        "uniform sampler2D uGrad;\n" +
        "uniform vec2 uTexelSize;\n" +
        "uniform float uRefineStrength;\n" +
        "float power_function(float x) {\n" +
        "    float x2 = x * x;\n" +
        "    float x3 = x2 * x;\n" +
        "    float x4 = x2 * x2;\n" +
        "    float x5 = x2 * x3;\n" +
        "    return 11.68129591*x5 - 42.46906057*x4 + 60.28286266*x3\n" +
        "         - 41.84451327*x2 + 14.05517353*x - 1.081521930;\n" +
        "}\n" +
        "void main() {\n" +
        "    float tx = texture2D(uGrad, vTexCoord + vec2(0.0, -uTexelSize.y)).r * 2.0 - 1.0;\n" +
        "    float cx = texture2D(uGrad, vTexCoord).r * 2.0 - 1.0;\n" +
        "    float bx = texture2D(uGrad, vTexCoord + vec2(0.0, uTexelSize.y)).r * 2.0 - 1.0;\n" +
        "    float ty = texture2D(uGrad, vTexCoord + vec2(0.0, -uTexelSize.y)).g * 4.0 - 2.0;\n" +
        "    float by = texture2D(uGrad, vTexCoord + vec2(0.0, uTexelSize.y)).g * 4.0 - 2.0;\n" +
        "    float xgrad = (tx + cx + cx + bx);\n" +
        "    float ygrad = (-ty + by);\n" +
        "    float sobel = clamp(sqrt(xgrad * xgrad + ygrad * ygrad), 0.0, 1.0);\n" +
        "    float dval = clamp(power_function(sobel) * uRefineStrength, 0.0, 1.0);\n" +
        "    gl_FragColor = vec4(sobel * 0.5 + 0.5, dval, 0.0, 1.0);\n" +
        "}\n";

    // Pass 4: Gradient X (second pass)
    private static final String FRAG_GRAD_X2 =
        "precision mediump float;\n" +
        "varying vec2 vTexCoord;\n" +
        "uniform sampler2D uLumad;\n" +
        "uniform vec2 uTexelSize;\n" +
        "void main() {\n" +
        "    float dval = texture2D(uLumad, vTexCoord).g;\n" +
        "    if (dval < 0.1) {\n" +
        "        gl_FragColor = vec4(0.5, 0.5, 0.0, 1.0);\n" +
        "        return;\n" +
        "    }\n" +
        "    float sobel = texture2D(uLumad, vTexCoord).r * 2.0 - 1.0;\n" +
        "    float l = texture2D(uLumad, vTexCoord + vec2(-uTexelSize.x, 0.0)).r * 2.0 - 1.0;\n" +
        "    float r = texture2D(uLumad, vTexCoord + vec2(uTexelSize.x, 0.0)).r * 2.0 - 1.0;\n" +
        "    float xgrad = (-l + r);\n" +
        "    float ygrad = (l + sobel + sobel + r);\n" +
        "    gl_FragColor = vec4(xgrad * 0.5 + 0.5, ygrad * 0.25 + 0.5, 0.0, 1.0);\n" +
        "}\n";

    // Pass 5: Gradient Y (second pass)
    private static final String FRAG_GRAD_Y2 =
        "precision mediump float;\n" +
        "varying vec2 vTexCoord;\n" +
        "uniform sampler2D uLumad;\n" +
        "uniform sampler2D uLumamm;\n" +
        "uniform vec2 uTexelSize;\n" +
        "void main() {\n" +
        "    float dval = texture2D(uLumad, vTexCoord).g;\n" +
        "    if (dval < 0.1) {\n" +
        "        gl_FragColor = vec4(0.5, 0.5, 0.0, 1.0);\n" +
        "        return;\n" +
        "    }\n" +
        "    float tx = texture2D(uLumamm, vTexCoord + vec2(0.0, -uTexelSize.y)).r * 2.0 - 1.0;\n" +
        "    float cx = texture2D(uLumamm, vTexCoord).r * 2.0 - 1.0;\n" +
        "    float bx = texture2D(uLumamm, vTexCoord + vec2(0.0, uTexelSize.y)).r * 2.0 - 1.0;\n" +
        "    float ty = texture2D(uLumamm, vTexCoord + vec2(0.0, -uTexelSize.y)).g * 4.0 - 2.0;\n" +
        "    float by = texture2D(uLumamm, vTexCoord + vec2(0.0, uTexelSize.y)).g * 4.0 - 2.0;\n" +
        "    float xgrad = (tx + cx + cx + bx);\n" +
        "    float ygrad = (-ty + by);\n" +
        "    float norm = sqrt(xgrad * xgrad + ygrad * ygrad);\n" +
        "    if (norm <= 0.001) {\n" +
        "        gl_FragColor = vec4(0.5, 0.5, 0.0, 1.0);\n" +
        "        return;\n" +
        "    }\n" +
        "    gl_FragColor = vec4(xgrad / norm * 0.5 + 0.5, ygrad / norm * 0.5 + 0.5, 0.0, 1.0);\n" +
        "}\n";

    // Pass 6: Apply
    private static final String FRAG_APPLY =
        "precision mediump float;\n" +
        "varying vec2 vTexCoord;\n" +
        "uniform sampler2D uTexture;\n" +
        "uniform sampler2D uLumad;\n" +
        "uniform sampler2D uLumamm;\n" +
        "uniform vec2 uTexelSize;\n" +
        "void main() {\n" +
        "    float dval = texture2D(uLumad, vTexCoord).g;\n" +
        "    vec4 original = texture2D(uTexture, vTexCoord);\n" +
        "    if (dval < 0.1) {\n" +
        "        gl_FragColor = original;\n" +
        "        return;\n" +
        "    }\n" +
        "    vec2 dir = texture2D(uLumamm, vTexCoord).rg * 2.0 - 1.0;\n" +
        "    if (abs(dir.x) + abs(dir.y) <= 0.0001) {\n" +
        "        gl_FragColor = original;\n" +
        "        return;\n" +
        "    }\n" +
        "    float xpos = -sign(dir.x);\n" +
        "    float ypos = -sign(dir.y);\n" +
        "    vec4 xval = texture2D(uTexture, vTexCoord + vec2(uTexelSize.x * xpos, 0.0));\n" +
        "    vec4 yval = texture2D(uTexture, vTexCoord + vec2(0.0, uTexelSize.y * ypos));\n" +
        "    float xyratio = abs(dir.x) / (abs(dir.x) + abs(dir.y));\n" +
        "    vec4 avg = xyratio * xval + (1.0 - xyratio) * yval;\n" +
        "    gl_FragColor = avg * dval + original * (1.0 - dval);\n" +
        "}\n";

    // Pass 7: Pseudo-MV Interpolation
    private static final String FRAG_PSEUDO_MV =
        "precision mediump float;\n" +
        "varying vec2 vTexCoord;\n" +
        "uniform sampler2D uTexture;\n" +
        "uniform sampler2D uLastTexture;\n" +
        "uniform sampler2D uLumad;\n" +
        "uniform sampler2D uLumamm;\n" +
        "uniform vec2 uTexelSize;\n" +
        "uniform float uMVStrength;\n" +
        "void main() {\n" +
        "    vec4 current = texture2D(uTexture, vTexCoord);\n" +
        "    float dval = texture2D(uLumad, vTexCoord).g;\n" +
        "    if (dval < 0.1 || uMVStrength <= 0.0) {\n" +
        "        gl_FragColor = current;\n" +
        "        return;\n" +
        "    }\n" +
        "    vec2 dir = texture2D(uLumamm, vTexCoord).rg * 2.0 - 1.0;\n" +
        "    vec2 offset = dir * uTexelSize * 1.5 * uMVStrength;\n" +
        "    vec4 prev1 = texture2D(uLastTexture, vTexCoord + offset);\n" +
        "    vec4 prev2 = texture2D(uLastTexture, vTexCoord - offset);\n" +
        "    vec4 prevAvg = (prev1 + prev2) * 0.5;\n" +
        "    float blend = clamp(dval * 0.5 * uMVStrength, 0.0, 0.8);\n" +
        "    gl_FragColor = mix(current, prevAvg, blend);\n" +
        "}\n";

    private static final String FRAG_PASSTHROUGH =
        "precision mediump float;\n" +
        "varying vec2 vTexCoord;\n" +
        "uniform sampler2D uTexture;\n" +
        "void main() {\n" +
        "    gl_FragColor = texture2D(uTexture, vTexCoord);\n" +
        "}\n";

    public Anime4KRenderer() {
        ByteBuffer bb = ByteBuffer.allocateDirect(QUAD_VERTICES.length * 4);
        bb.order(ByteOrder.nativeOrder());
        vertexBuffer = bb.asFloatBuffer();
        vertexBuffer.put(QUAD_VERTICES);
        vertexBuffer.position(0);

        ByteBuffer bb2 = ByteBuffer.allocateDirect(QUAD_VERTICES_FLIPPED.length * 4);
        bb2.order(ByteOrder.nativeOrder());
        vertexBufferFlipped = bb2.asFloatBuffer();
        vertexBufferFlipped.put(QUAD_VERTICES_FLIPPED);
        vertexBufferFlipped.position(0);
    }

    public void setRefineStrength(float strength) { this.refineStrength = strength; }
    public void setPseudoMVStrength(float strength) { this.pseudoMVStrength = strength; }
    public void setFsrEnabled(boolean enabled) { this.fsrEnabled = enabled; }
    public void setFsrSharpness(float sharpness) { this.fsrSharpness = sharpness; }

    public void init(int inW, int inH, int outW, int outH) {
        if (initialized) release();

        this.inputWidth = inW;
        this.inputHeight = inH;
        this.outputWidth = outW;
        this.outputHeight = outH;

        programLuma = createProgram(VERTEX_SHADER, FRAG_LUMA);
        programGradX1 = createProgram(VERTEX_SHADER, FRAG_GRAD_X1);
        programGradY1 = createProgram(VERTEX_SHADER, FRAG_GRAD_Y1);
        programGradX2 = createProgram(VERTEX_SHADER, FRAG_GRAD_X2);
        programGradY2 = createProgram(VERTEX_SHADER, FRAG_GRAD_Y2);
        programApply = createProgram(VERTEX_SHADER, FRAG_APPLY);
        programPseudoMV = createProgram(VERTEX_SHADER, FRAG_PSEUDO_MV);
        programPassthrough = createProgram(VERTEX_SHADER, FRAG_PASSTHROUGH);

        // FSR Shaders
        programFsrEasu = createProgram(FSRShaders.VERTEX_SHADER, FSRShaders.FRAG_EASU);
        programFsrRcas = createProgram(FSRShaders.VERTEX_SHADER, FSRShaders.FRAG_RCAS);

        fbo = new int[7];
        GLES30.glGenFramebuffers(7, fbo, 0);

        inputTexture = createTexture(inputWidth, inputHeight);
        lumaTexture = createTexture(inputWidth, inputHeight);
        lumadTexture = createTexture(outputWidth, outputHeight);
        lumammTexture = createTexture(outputWidth, outputHeight);
        outputTexture = createTexture(outputWidth, outputHeight);
        lastOutputTexture = createTexture(outputWidth, outputHeight);
        fsrTempTexture = createTexture(outputWidth, outputHeight);

        attachTextureToFBO(fbo[0], lumaTexture);
        attachTextureToFBO(fbo[1], lumadTexture);
        attachTextureToFBO(fbo[2], lumadTexture); // reuse
        attachTextureToFBO(fbo[3], lumammTexture);
        attachTextureToFBO(fbo[4], outputTexture);
        attachTextureToFBO(fbo[5], lastOutputTexture);
        attachTextureToFBO(fbo[6], fsrTempTexture);

        initialized = true;
        Log.d(TAG, "Initialized GLES 3.0: " + inW + "x" + inH + " -> " + outW + "x" + outH);
    }

    public int process(Bitmap bitmap) {
        if (!initialized) return 0;

        GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, inputTexture);
        GLUtils.texSubImage2D(GLES30.GL_TEXTURE_2D, 0, 0, 0, bitmap);

        int currentTexture = inputTexture;

        // Always run Anime4K luma and gradient passes if Pseudo-MV is enabled,
        // regardless of whether FSR is enabled, to provide edge data for Pseudo-MV.
        if (pseudoMVStrength > 0.0f || !fsrEnabled) {
            // Pass 1: Luma
            GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, fbo[0]);
            GLES30.glViewport(0, 0, inputWidth, inputHeight);
            drawQuadWithProgram(programLuma, new int[]{inputTexture}, new String[]{"uTexture"});

            // Pass 2: GradX1
            GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, fbo[1]);
            GLES30.glViewport(0, 0, outputWidth, outputHeight);
            GLES30.glUseProgram(programGradX1);
            setTexelSize(programGradX1, inputWidth, inputHeight);
            drawQuadWithProgram(programGradX1, new int[]{lumaTexture}, new String[]{"uLuma"});

            // Pass 3: GradY1
            int tempTex = createTexture(outputWidth, outputHeight);
            GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, fbo[2]);
            GLES30.glFramebufferTexture2D(GLES30.GL_FRAMEBUFFER, GLES30.GL_COLOR_ATTACHMENT0, GLES30.GL_TEXTURE_2D, tempTex, 0);
            GLES30.glViewport(0, 0, outputWidth, outputHeight);
            GLES30.glUseProgram(programGradY1);
            setTexelSize(programGradY1, outputWidth, outputHeight);
            GLES30.glUniform1f(GLES30.glGetUniformLocation(programGradY1, "uRefineStrength"), refineStrength);
            drawQuadWithProgram(programGradY1, new int[]{lumadTexture}, new String[]{"uGrad"});

            GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, fbo[1]);
            drawQuadWithProgram(programPassthrough, new int[]{tempTex}, new String[]{"uTexture"});

            // Pass 4: GradX2
            GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, fbo[3]);
            GLES30.glViewport(0, 0, outputWidth, outputHeight);
            GLES30.glUseProgram(programGradX2);
            setTexelSize(programGradX2, outputWidth, outputHeight);
            drawQuadWithProgram(programGradX2, new int[]{lumadTexture}, new String[]{"uLumad"});

            // Pass 5: GradY2
            int tempTex2 = createTexture(outputWidth, outputHeight);
            GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, fbo[2]);
            GLES30.glFramebufferTexture2D(GLES30.GL_FRAMEBUFFER, GLES30.GL_COLOR_ATTACHMENT0, GLES30.GL_TEXTURE_2D, tempTex2, 0);
            GLES30.glViewport(0, 0, outputWidth, outputHeight);
            GLES30.glUseProgram(programGradY2);
            setTexelSize(programGradY2, outputWidth, outputHeight);
            drawQuadWithProgram(programGradY2, new int[]{lumadTexture, lumammTexture}, new String[]{"uLumad", "uLumamm"});

            GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, fbo[3]);
            drawQuadWithProgram(programPassthrough, new int[]{tempTex2}, new String[]{"uTexture"});

            GLES30.glDeleteTextures(2, new int[]{tempTex, tempTex2}, 0);
        }

        if (fsrEnabled) {
            // EASU: Input -> FSR Temp Texture
            GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, fbo[6]);
            GLES30.glViewport(0, 0, outputWidth, outputHeight);
            GLES30.glUseProgram(programFsrEasu);
            
            // FSR Constants for EASU
            float invInputWidth = 1.0f / inputWidth;
            float invInputHeight = 1.0f / inputHeight;
            float invOutputWidth = 1.0f / outputWidth;
            float invOutputHeight = 1.0f / outputHeight;

            float[] easuCon0 = { (float)inputWidth * invOutputWidth, (float)inputHeight * invOutputHeight, 0.5f * (float)inputWidth * invOutputWidth - 0.5f, 0.5f * (float)inputHeight * invOutputHeight - 0.5f };
            float[] easuCon1 = { invInputWidth, invInputHeight, 0.0f, 0.0f };
            // uEasuCon2 and uEasuCon3 are for more advanced FsrEasuF, not used in this simplified version
            
            GLES30.glUniform4fv(GLES30.glGetUniformLocation(programFsrEasu, "uEasuCon0"), 1, easuCon0, 0);
            GLES30.glUniform4fv(GLES30.glGetUniformLocation(programFsrEasu, "uEasuCon1"), 1, easuCon1, 0);
            
            drawQuadWithProgram(programFsrEasu, new int[]{inputTexture}, new String[]{"uTexture"});
            
            // RCAS: FSR Temp Texture -> Output Texture
            GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, fbo[4]);
            GLES30.glViewport(0, 0, outputWidth, outputHeight);
            GLES30.glUseProgram(programFsrRcas);
            GLES30.glUniform4f(GLES30.glGetUniformLocation(programFsrRcas, "uRcasCon"), fsrSharpness, 0, 0, 0);
            drawQuadWithProgram(programFsrRcas, new int[]{fsrTempTexture}, new String[]{"uTexture"});
            
            currentTexture = outputTexture;
        } else {
            // Anime4K Apply
            GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, fbo[4]);
            GLES30.glViewport(0, 0, outputWidth, outputHeight);
            GLES30.glUseProgram(programApply);
            setTexelSize(programApply, inputWidth, inputHeight);
            drawQuadWithProgram(programApply, new int[]{inputTexture, lumadTexture, lumammTexture}, new String[]{"uTexture", "uLumad", "uLumamm"});
            currentTexture = outputTexture;
        }

        // Pass 7: Pseudo-MV
        if (pseudoMVStrength > 0.0) {
            int nextOutputTex = createTexture(outputWidth, outputHeight);
            GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, fbo[2]); // Reuse fbo[2] for temp output
            GLES30.glFramebufferTexture2D(GLES30.GL_FRAMEBUFFER, GLES30.GL_COLOR_ATTACHMENT0, GLES30.GL_TEXTURE_2D, nextOutputTex, 0);
            GLES30.glViewport(0, 0, outputWidth, outputHeight);
            GLES30.glUseProgram(programPseudoMV);
            setTexelSize(programPseudoMV, outputWidth, outputHeight);
            GLES30.glUniform1f(GLES30.glGetUniformLocation(programPseudoMV, "uMVStrength"), pseudoMVStrength);
            drawQuadWithProgram(programPseudoMV, new int[]{currentTexture, lastOutputTexture, lumadTexture, lumammTexture}, new String[]{"uTexture", "uLastTexture", "uLumad", "uLumamm"});
            
            GLES30.glDeleteTextures(1, new int[]{outputTexture}, 0);
            outputTexture = nextOutputTex;
            GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, fbo[4]);
            GLES30.glFramebufferTexture2D(GLES30.GL_FRAMEBUFFER, GLES30.GL_COLOR_ATTACHMENT0, GLES30.GL_TEXTURE_2D, outputTexture, 0);
            currentTexture = outputTexture;
        }

        // Update lastOutput
        GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, fbo[5]);
        GLES30.glViewport(0, 0, outputWidth, outputHeight);
        drawQuadWithProgram(programPassthrough, new int[]{currentTexture}, new String[]{"uTexture"});

        GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, 0);
        return outputTexture;
    }

    public void renderToScreen(int texture, int screenWidth, int screenHeight) {
        GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, 0);
        GLES30.glViewport(0, 0, screenWidth, screenHeight);
        GLES30.glClearColor(0, 0, 0, 1);
        GLES30.glClear(GLES30.GL_COLOR_BUFFER_BIT);
        drawQuadWithBuffer(programPassthrough, new int[]{texture}, new String[]{"uTexture"}, vertexBufferFlipped);
    }

    private void drawQuadWithProgram(int program, int[] textures, String[] uniformNames) {
        drawQuadWithBuffer(program, textures, uniformNames, vertexBuffer);
    }

    private void drawQuadWithBuffer(int program, int[] textures, String[] uniformNames, FloatBuffer vbuf) {
        GLES30.glUseProgram(program);
        int posLoc = GLES30.glGetAttribLocation(program, "aPosition");
        int texLoc = GLES30.glGetAttribLocation(program, "aTexCoord");
        vbuf.position(0);
        GLES30.glEnableVertexAttribArray(posLoc);
        GLES30.glVertexAttribPointer(posLoc, 2, GLES30.GL_FLOAT, false, 16, vbuf);
        vbuf.position(2);
        GLES30.glEnableVertexAttribArray(texLoc);
        GLES30.glVertexAttribPointer(texLoc, 2, GLES30.GL_FLOAT, false, 16, vbuf);
        for (int i = 0; i < textures.length; i++) {
            GLES30.glActiveTexture(GLES30.GL_TEXTURE0 + i);
            GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, textures[i]);
            GLES30.glUniform1i(GLES30.glGetUniformLocation(program, uniformNames[i]), i);
        }
        GLES30.glDrawArrays(GLES30.GL_TRIANGLE_STRIP, 0, 4);
        GLES30.glDisableVertexAttribArray(posLoc);
        GLES30.glDisableVertexAttribArray(texLoc);
    }

    private void setTexelSize(int program, int w, int h) {
        int loc = GLES30.glGetUniformLocation(program, "uTexelSize");
        if (loc >= 0) GLES30.glUniform2f(loc, 1.0f / w, 1.0f / h);
    }

    private int createTexture(int width, int height) {
        int[] tex = new int[1];
        GLES30.glGenTextures(1, tex, 0);
        GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, tex[0]);
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_MIN_FILTER, GLES30.GL_LINEAR);
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_MAG_FILTER, GLES30.GL_LINEAR);
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_WRAP_S, GLES30.GL_CLAMP_TO_EDGE);
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_WRAP_T, GLES30.GL_CLAMP_TO_EDGE);
        GLES30.glTexImage2D(GLES30.GL_TEXTURE_2D, 0, GLES30.GL_RGBA, width, height, 0, GLES30.GL_RGBA, GLES30.GL_UNSIGNED_BYTE, null);
        return tex[0];
    }

    private void attachTextureToFBO(int fboId, int texId) {
        GLES30.glBindFramebuffer(GLES30.GL_FRAMEBUFFER, fboId);
        GLES30.glFramebufferTexture2D(GLES30.GL_FRAMEBUFFER, GLES30.GL_COLOR_ATTACHMENT0, GLES30.GL_TEXTURE_2D, texId, 0);
    }

    private int createProgram(String vertex, String fragment) {
        int vshader = loadShader(GLES30.GL_VERTEX_SHADER, vertex);
        int fshader = loadShader(GLES30.GL_FRAGMENT_SHADER, fragment);
        int program = GLES30.glCreateProgram();
        GLES30.glAttachShader(program, vshader);
        GLES30.glAttachShader(program, fshader);
        GLES30.glLinkProgram(program);
        int[] linkStatus = new int[1];
        GLES30.glGetProgramiv(program, GLES30.GL_LINK_STATUS, linkStatus, 0);
        if (linkStatus[0] != GLES30.GL_TRUE) {
            Log.e(TAG, "Could not link program: " + GLES30.glGetProgramInfoLog(program));
            GLES30.glDeleteProgram(program);
            return 0;
        }
        return program;
    }

    private int loadShader(int type, String source) {
        int shader = GLES30.glCreateShader(type);
        GLES30.glShaderSource(shader, source);
        GLES30.glCompileShader(shader);
        int[] compiled = new int[1];
        GLES30.glGetShaderiv(shader, GLES30.GL_COMPILE_STATUS, compiled, 0);
        if (compiled[0] == 0) {
            Log.e(TAG, "Could not compile shader " + type + ": " + GLES30.glGetShaderInfoLog(shader));
            GLES30.glDeleteShader(shader);
            return 0;
        }
        return shader;
    }

    public void release() {
        if (!initialized) return;
        GLES30.glDeleteProgram(programLuma);
        GLES30.glDeleteProgram(programGradX1);
        GLES30.glDeleteProgram(programGradY1);
        GLES30.glDeleteProgram(programGradX2);
        GLES30.glDeleteProgram(programGradY2);
        GLES30.glDeleteProgram(programApply);
        GLES30.glDeleteProgram(programPseudoMV);
        GLES30.glDeleteProgram(programPassthrough);
        GLES30.glDeleteProgram(programFsrEasu);
        GLES30.glDeleteProgram(programFsrRcas);
        GLES30.glDeleteTextures(7, new int[]{inputTexture, lumaTexture, lumadTexture, lumammTexture, outputTexture, lastOutputTexture, fsrTempTexture}, 0);
        GLES30.glDeleteFramebuffers(7, fbo, 0);
        initialized = false;
    }
}
