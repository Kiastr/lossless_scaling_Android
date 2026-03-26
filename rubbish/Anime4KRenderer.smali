    .locals 4
    .param p1, "texture"    # I
    .param p2, "screenWidth"    # I
    .param p3, "screenHeight"    # I

    .line 370
    const v0, 0x8d40

    const/4 v1, 0x0

    invoke-static {v0, v1}, Landroid/opengl/GLES20;->glBindFramebuffer(II)V

    .line 371
    invoke-static {v1, v1, p2, p3}, Landroid/opengl/GLES20;->glViewport(IIII)V

    .line 372
    const/4 v0, 0x0

    invoke-static {v0, v0, v0, v0}, Landroid/opengl/GLES20;->glClearColor(FFFF)V

    .line 373
    const/16 v0, 0x4000

    invoke-static {v0}, Landroid/opengl/GLES20;->glClear(I)V

    .line 375
    iget v0, p0, Lcom/anime4k/screen/Anime4KRenderer;->programPassthrough:I

    const/4 v2, 0x1

    new-array v2, v2, [I

    aput p1, v2, v1

    const-string v1, "uTexture"

    filled-new-array {v1}, [Ljava/lang/String;

    move-result-object v1

    iget-object v3, p0, Lcom/anime4k/screen/Anime4KRenderer;->vertexBufferFlipped:Ljava/nio/FloatBuffer;

    invoke-direct {p0, v0, v2, v1, v3}, Lcom/anime4k/screen/Anime4KRenderer;->drawQuadWithBuffer(I[I[Ljava/lang/String;Ljava/nio/FloatBuffer;)V

    .line 376
    return-void
.end method

.method public setRefineStrength(F)V
    .locals 0
    .param p1, "strength"    # F

    .line 236
    iput p1, p0, Lcom/anime4k/screen/Anime4KRenderer;->refineStrength:F