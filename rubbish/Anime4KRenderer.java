
    private void drawQuad(int program, int[] textures, String[] uniformNames) {
        drawQuadWithBuffer(program, textures, uniformNames, this.vertexBuffer);
    }

    private void drawQuadWithBuffer(int program, int[] textures, String[] uniformNames, FloatBuffer vbuf) {
        GLES20.glUseProgram(program);
        int posLoc = GLES20.glGetAttribLocation(program, "aPosition");
        int texLoc = GLES20.glGetAttribLocation(program, "aTexCoord");
        vbuf.position(0);
        GLES20.glEnableVertexAttribArray(posLoc);
        GLES20.glVertexAttribPointer(posLoc, 2, 5126, false, 16, (Buffer) vbuf);
        vbuf.position(2);
        GLES20.glEnableVertexAttribArray(texLoc);
        GLES20.glVertexAttribPointer(texLoc, 2, 5126, false, 16, (Buffer) vbuf);
        for (int i = 0; i < textures.length; i++) {
            GLES20.glActiveTexture(33984 + i);
            GLES20.glBindTexture(3553, textures[i]);
            int uLoc = GLES20.glGetUniformLocation(program, uniformNames[i]);
            GLES20.glUniform1i(uLoc, i);
        }
        GLES20.glDrawArrays(5, 0, 4);
        GLES20.glDisableVertexAttribArray(posLoc);
        GLES20.glDisableVertexAttribArray(texLoc);
    }

    private void setTexelSize(int program, int w, int h) {
        int loc = GLES20.glGetUniformLocation(program, "uTexelSize");
        if (loc >= 0) {
            GLES20.glUniform2f(loc, 1.0f / w, 1.0f / h);
        }
    }

    private int createTexture(int width, int height) {
        int[] tex = new int[1];
        GLES20.glGenTextures(1, tex, 0);
        GLES20.glBindTexture(3553, tex[0]);
        GLES20.glTexParameteri(3553, 10241, 9729);
        GLES20.glTexParameteri(3553, 10240, 9729);
        GLES20.glTexParameteri(3553, 10242, 33071);
        GLES20.glTexParameteri(3553, 10243, 33071);
        GLES20.glTexImage2D(3553, 0, 6408, width, height, 0, 6408, 5121, null);
        return tex[0];
    }

    private void attachTextureToFBO(int fboId, int texId) {
        GLES20.glBindFramebuffer(36160, fboId);
        GLES20.glFramebufferTexture2D(36160, 36064, 3553, texId, 0);
        GLES20.glBindFramebuffer(36160, 0);
    }

    private int createProgram(String vertexSource, String fragmentSource) {
        int vertexShader = loadShader(35633, vertexSource);
        int fragmentShader = loadShader(35632, fragmentSource);
        int program = GLES20.glCreateProgram();
        GLES20.glAttachShader(program, vertexShader);
        GLES20.glAttachShader(program, fragmentShader);
        GLES20.glLinkProgram(program);
        int[] linkStatus = new int[1];
        GLES20.glGetProgramiv(program, 35714, linkStatus, 0);
        if (linkStatus[0] != 1) {
            Log.e(TAG, "Program link error: " + GLES20.glGetProgramInfoLog(program));
            GLES20.glDeleteProgram(program);
            return 0;
        }
        GLES20.glDeleteShader(vertexShader);
        GLES20.glDeleteShader(fragmentShader);
        return program;
    }

    private int loadShader(int type, String source) {
        int shader = GLES20.glCreateShader(type);
        GLES20.glShaderSource(shader, source);
        GLES20.glCompileShader(shader);
        int[] compiled = new int[1];
        GLES20.glGetShaderiv(shader, 35713, compiled, 0);
        if (compiled[0] != 1) {
            Log.e(TAG, "Shader compile error: " + GLES20.glGetShaderInfoLog(shader));
            GLES20.glDeleteShader(shader);
            return 0;
        }
        return shader;
    }

    public void release() {
        if (this.initialized) {
            GLES20.glDeleteProgram(this.programLuma);
            GLES20.glDeleteProgram(this.programGradX1);
            GLES20.glDeleteProgram(this.programGradY1);
            GLES20.glDeleteProgram(this.programGradX2);
            GLES20.glDeleteProgram(this.programGradY2);
            GLES20.glDeleteProgram(this.programApply);
            GLES20.glDeleteProgram(this.programPassthrough);
            GLES20.glDeleteFramebuffers(5, this.fbo, 0);
            GLES20.glDeleteTextures(5, new int[]{this.inputTexture, this.lumaTexture, this.lumadTexture, this.lumammTexture, this.outputTexture}, 0);
            this.initialized = false;
        }
    }
}
