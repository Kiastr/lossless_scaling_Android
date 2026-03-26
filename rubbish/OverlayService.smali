.class public Lcom/anime4k/screen/OverlayService;
.super Landroid/app/Service;
.source "OverlayService.java"


# static fields
.field private static final CHANNEL_ID:Ljava/lang/String; = "anime4k_channel"

.field private static final NOTIFICATION_ID:I = 0x1

.field private static final TAG:Ljava/lang/String; = "OverlayService"


# instance fields
.field private captureHeight:I

.field private captureScale:F

.field private captureWidth:I

.field private eglContext:Landroid/opengl/EGLContext;

.field private eglDisplay:Landroid/opengl/EGLDisplay;

.field private eglOverlaySurface:Landroid/opengl/EGLSurface;

.field private eglSurface:Landroid/opengl/EGLSurface;

.field private fpsStartTime:J

.field private frameCount:I

.field private frameInterval:I

.field private imageReader:Landroid/media/ImageReader;

.field private isRunning:Z

.field private lastFrameTime:J

.field private mediaProjection:Landroid/media/projection/MediaProjection;

.field private overlayOutputSurface:Landroid/view/Surface;

.field private overlayParams:Landroid/view/WindowManager$LayoutParams;

.field private overlaySurfaceView:Landroid/view/SurfaceView;

.field private processingHandler:Landroid/os/Handler;

.field private processingThread:Landroid/os/HandlerThread;

.field private refineStrength:F

.field private renderer:Lcom/anime4k/screen/Anime4KRenderer;

.field private screenDensity:I

.field private screenHeight:I

.field private screenWidth:I

.field private surfaceReady:Z

.field private useAccessibilityMode:Z

.field private virtualDisplay:Landroid/hardware/display/VirtualDisplay;

.field private windowManager:Landroid/view/WindowManager;


# direct methods
.method public static synthetic $r8$lambda$C4tYIXlqkuv9R5FhjeJWJJZnRUE(Lcom/anime4k/screen/OverlayService;)V
    .locals 0

    invoke-direct {p0}, Lcom/anime4k/screen/OverlayService;->processFrame()V

    return-void
.end method

.method static bridge synthetic -$$Nest$fputoverlayOutputSurface(Lcom/anime4k/screen/OverlayService;Landroid/view/Surface;)V
    .locals 0

    iput-object p1, p0, Lcom/anime4k/screen/OverlayService;->overlayOutputSurface:Landroid/view/Surface;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputsurfaceReady(Lcom/anime4k/screen/OverlayService;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/anime4k/screen/OverlayService;->surfaceReady:Z

    return-void
.end method

.method public constructor <init>()V
    .locals 3

    invoke-direct {p0}, Landroid/app/Service;-><init>()V

    const/high16 v0, 0x3f000000    # 0.5f

    iput v0, p0, Lcom/anime4k/screen/OverlayService;->captureScale:F

    iput v0, p0, Lcom/anime4k/screen/OverlayService;->refineStrength:F

    const/16 v0, 0x64

    iput v0, p0, Lcom/anime4k/screen/OverlayService;->frameInterval:I

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/anime4k/screen/OverlayService;->isRunning:Z

    const-wide/16 v1, 0x0

    iput-wide v1, p0, Lcom/anime4k/screen/OverlayService;->lastFrameTime:J

    iput v0, p0, Lcom/anime4k/screen/OverlayService;->frameCount:I

    iput-wide v1, p0, Lcom/anime4k/screen/OverlayService;->fpsStartTime:J

    iput-boolean v0, p0, Lcom/anime4k/screen/OverlayService;->surfaceReady:Z

    iput-boolean v0, p0, Lcom/anime4k/screen/OverlayService;->useAccessibilityMode:Z

    return-void
.end method

.method private createNotification()Landroid/app/Notification;
    .locals 11

    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/anime4k/screen/MainActivity;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .local v0, "notificationIntent":Landroid/content/Intent;
    const/4 v1, 0x0

    const/high16 v2, 0x4000000

    invoke-static {p0, v1, v0, v2}, Landroid/app/PendingIntent;->getActivity(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v1

    .local v1, "pendingIntent":Landroid/app/PendingIntent;
    new-instance v3, Landroid/content/Intent;

    const-class v4, Lcom/anime4k/screen/OverlayService;

    invoke-direct {v3, p0, v4}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .local v3, "stopIntent":Landroid/content/Intent;
    const-string v4, "STOP"

    invoke-virtual {v3, v4}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    const/4 v4, 0x1

    invoke-static {p0, v4, v3, v2}, Landroid/app/PendingIntent;->getService(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v2

    .local v2, "stopPendingIntent":Landroid/app/PendingIntent;
    new-instance v6, Landroid/app/Notification$Builder;

    const-string v7, "anime4k_channel"

    invoke-direct {v6, p0, v7}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    .local v6, "builder":Landroid/app/Notification$Builder;
    const-string v7, "Anime4K \u5c4f\u5e55\u8d85\u5206\u8fd0\u884c\u4e2d"

    invoke-virtual {v6, v7}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v7

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "\u6355\u83b7: "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    iget v9, p0, Lcom/anime4k/screen/OverlayService;->captureWidth:I

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v8

    const-string v9, "x"

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    iget v10, p0, Lcom/anime4k/screen/OverlayService;->captureHeight:I

    invoke-virtual {v8, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v8

    const-string v10, " \u2192 \u8f93\u51fa: "

    invoke-virtual {v8, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    iget v10, p0, Lcom/anime4k/screen/OverlayService;->screenWidth:I

    invoke-virtual {v8, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    iget v9, p0, Lcom/anime4k/screen/OverlayService;->screenHeight:I

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v7, v8}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v7

    const v8, 0x1080057

    invoke-virtual {v7, v8}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    move-result-object v7

    invoke-virtual {v7, v1}, Landroid/app/Notification$Builder;->setContentIntent(Landroid/app/PendingIntent;)Landroid/app/Notification$Builder;

    move-result-object v7

    const v8, 0x1080023

    const-string v9, "\u505c\u6b62"

    invoke-virtual {v7, v8, v9, v2}, Landroid/app/Notification$Builder;->addAction(ILjava/lang/CharSequence;Landroid/app/PendingIntent;)Landroid/app/Notification$Builder;

    move-result-object v7

    invoke-virtual {v7, v4}, Landroid/app/Notification$Builder;->setOngoing(Z)Landroid/app/Notification$Builder;

    move-result-object v4

    invoke-virtual {v4}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object v4

    return-object v4
.end method

.method private createNotificationChannel()V
    .locals 4

    new-instance v0, Landroid/app/NotificationChannel;

    const-string v1, "Anime4K Screen Service"

    const/4 v2, 0x2

    const-string v3, "anime4k_channel"

    invoke-direct {v0, v3, v1, v2}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V

    .local v0, "channel":Landroid/app/NotificationChannel;
    const-string v1, "Anime4K \u5c4f\u5e55\u8d85\u5206\u670d\u52a1\u8fd0\u884c\u901a\u77e5"

    invoke-virtual {v0, v1}, Landroid/app/NotificationChannel;->setDescription(Ljava/lang/String;)V

    const-class v1, Landroid/app/NotificationManager;

    invoke-virtual {p0, v1}, Lcom/anime4k/screen/OverlayService;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/NotificationManager;

    invoke-virtual {v1, v0}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V

    return-void
.end method

.method private getEGLConfig()Landroid/opengl/EGLConfig;
    .locals 9

    const/16 v0, 0xf
    new-array v1, v0, [I
    fill-array-data v1, :array_1

    const/4 v2, 0x0
    const/4 v8, 0x1
    new-array v3, v8, [Landroid/opengl/EGLConfig;
    const/4 v4, 0x0
    const/4 v5, 0x1
    new-array v6, v8, [I
    const/4 v7, 0x0
    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->eglDisplay:Landroid/opengl/EGLDisplay;

    invoke-static/range {v0 .. v7}, Landroid/opengl/EGL14;->eglChooseConfig(Landroid/opengl/EGLDisplay;[II[Landroid/opengl/EGLConfig;II[II)Z

    const/4 v8, 0x0
    aget-object v0, v3, v8
    return-object v0

    :array_1
    .array-data 4
        0x3024
        0x8
        0x3023
        0x8
        0x3022
        0x8
        0x3021
        0x8
        0x3040
        0x4
        0x3033
        0x25
        0x3038
    .end array-data
.end method

.method private initEGL()V
    .locals 5

    const/16 v0, 0x3098

    invoke-static {v0}, Landroid/opengl/EGL14;->eglGetDisplay(I)Landroid/opengl/EGLDisplay;

    move-result-object v0

    iput-object v0, p0, Lcom/anime4k/screen/OverlayService;->eglDisplay:Landroid/opengl/EGLDisplay;

    const/4 v0, 0x2

    new-array v0, v0, [I

    iget-object v1, p0, Lcom/anime4k/screen/OverlayService;->eglDisplay:Landroid/opengl/EGLDisplay;

    const/4 v2, 0x0

    const/4 v3, 0x1

    invoke-static {v1, v0, v2, v0, v3}, Landroid/opengl/EGL14;->eglInitialize(Landroid/opengl/EGLDisplay;[II[II)Z

    invoke-direct {p0}, Lcom/anime4k/screen/OverlayService;->getEGLConfig()Landroid/opengl/EGLConfig;

    move-result-object v0

    .local v0, "config":Landroid/opengl/EGLConfig;
    const/4 v1, 0x3

    new-array v1, v1, [I

    fill-array-data v1, :array_0

    .local v1, "contextAttribs":[I
    iget-object v3, p0, Lcom/anime4k/screen/OverlayService;->eglDisplay:Landroid/opengl/EGLDisplay;

    sget-object v4, Landroid/opengl/EGL14;->EGL_NO_CONTEXT:Landroid/opengl/EGLContext;

    invoke-static {v3, v0, v4, v1, v2}, Landroid/opengl/EGL14;->eglCreateContext(Landroid/opengl/EGLDisplay;Landroid/opengl/EGLConfig;Landroid/opengl/EGLContext;[II)Landroid/opengl/EGLContext;

    move-result-object v3

    iput-object v3, p0, Lcom/anime4k/screen/OverlayService;->eglContext:Landroid/opengl/EGLContext;

    const/4 v3, 0x5

    new-array v3, v3, [I

    fill-array-data v3, :array_2

    .local v3, "pbufferAttribs":[I
    iget-object v4, p0, Lcom/anime4k/screen/OverlayService;->eglDisplay:Landroid/opengl/EGLDisplay;

    invoke-static {v4, v0, v3, v2}, Landroid/opengl/EGL14;->eglCreatePbufferSurface(Landroid/opengl/EGLDisplay;Landroid/opengl/EGLConfig;[II)Landroid/opengl/EGLSurface;

    move-result-object v2

    iput-object v2, p0, Lcom/anime4k/screen/OverlayService;->eglSurface:Landroid/opengl/EGLSurface;

    invoke-direct {p0}, Lcom/anime4k/screen/OverlayService;->makePbufferCurrent()V

    return-void

    :array_0
    .array-data 4
        0x3098
        0x2
        0x3038
    .end array-data

    :array_2
    .array-data 4
        0x3057
        0x1
        0x3056
        0x1
        0x3038
    .end array-data
.end method

.method private makePbufferCurrent()V
    .locals 3

    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->eglDisplay:Landroid/opengl/EGLDisplay;

    iget-object v1, p0, Lcom/anime4k/screen/OverlayService;->eglSurface:Landroid/opengl/EGLSurface;

    iget-object v2, p0, Lcom/anime4k/screen/OverlayService;->eglContext:Landroid/opengl/EGLContext;

    invoke-static {v0, v1, v1, v2}, Landroid/opengl/EGL14;->eglMakeCurrent(Landroid/opengl/EGLDisplay;Landroid/opengl/EGLSurface;Landroid/opengl/EGLSurface;Landroid/opengl/EGLContext;)Z

    return-void
.end method

.method private processFrame()V
    .locals 18

    move-object/from16 v1, p0

    iget-boolean v0, v1, Lcom/anime4k/screen/OverlayService;->isRunning:Z

    if-eqz v0, :cond_6

    iget-boolean v0, v1, Lcom/anime4k/screen/OverlayService;->surfaceReady:Z

    if-nez v0, :cond_0

    goto/16 :goto_1

    :cond_0
    const/4 v2, 0x0

    .local v2, "image":Landroid/media/Image;
    :try_start_0
    iget-object v0, v1, Lcom/anime4k/screen/OverlayService;->imageReader:Landroid/media/ImageReader;

    invoke-virtual {v0}, Landroid/media/ImageReader;->acquireLatestImage()Landroid/media/Image;

    move-result-object v0

    move-object v2, v0

    if-nez v2, :cond_1

    invoke-direct/range {p0 .. p0}, Lcom/anime4k/screen/OverlayService;->scheduleNextFrame()V

    return-void

    :cond_1
    invoke-virtual {v2}, Landroid/media/Image;->getPlanes()[Landroid/media/Image$Plane;

    move-result-object v0

    .local v0, "planes":[Landroid/media/Image$Plane;
    const/4 v3, 0x0

    aget-object v4, v0, v3

    invoke-virtual {v4}, Landroid/media/Image$Plane;->getBuffer()Ljava/nio/ByteBuffer;

    move-result-object v4

    .local v4, "buffer":Ljava/nio/ByteBuffer;
    aget-object v5, v0, v3

    invoke-virtual {v5}, Landroid/media/Image$Plane;->getPixelStride()I

    move-result v5

    .local v5, "pixelStride":I
    aget-object v6, v0, v3

    invoke-virtual {v6}, Landroid/media/Image$Plane;->getRowStride()I

    move-result v6

    .local v6, "rowStride":I
    iget v7, v1, Lcom/anime4k/screen/OverlayService;->captureWidth:I

    mul-int v8, v5, v7

    sub-int v8, v6, v8

    .local v8, "rowPadding":I
    div-int v9, v8, v5

    add-int/2addr v7, v9

    iget v9, v1, Lcom/anime4k/screen/OverlayService;->captureHeight:I

    sget-object v10, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v7, v9, v10}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v7

    .local v7, "bitmap":Landroid/graphics/Bitmap;
    invoke-virtual {v7, v4}, Landroid/graphics/Bitmap;->copyPixelsFromBuffer(Ljava/nio/Buffer;)V

    invoke-virtual {v7}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v9

    iget v10, v1, Lcom/anime4k/screen/OverlayService;->captureWidth:I

    if-eq v9, v10, :cond_2

    iget v9, v1, Lcom/anime4k/screen/OverlayService;->captureHeight:I

    invoke-static {v7, v3, v3, v10, v9}, Landroid/graphics/Bitmap;->createBitmap(Landroid/graphics/Bitmap;IIII)Landroid/graphics/Bitmap;

    move-result-object v9

    .local v9, "cropped":Landroid/graphics/Bitmap;
    invoke-virtual {v7}, Landroid/graphics/Bitmap;->recycle()V

    move-object v7, v9

    .end local v9    # "cropped":Landroid/graphics/Bitmap;
    :cond_2
    invoke-virtual {v2}, Landroid/media/Image;->close()V

    const/4 v2, 0x0

    invoke-direct/range {p0 .. p0}, Lcom/anime4k/screen/OverlayService;->makePbufferCurrent()V

    iget-object v9, v1, Lcom/anime4k/screen/OverlayService;->renderer:Lcom/anime4k/screen/Anime4KRenderer;

    invoke-virtual {v9, v7}, Lcom/anime4k/screen/Anime4KRenderer;->process(Landroid/graphics/Bitmap;)I

    move-result v9

    .local v9, "outputTex":I
    invoke-virtual {v7}, Landroid/graphics/Bitmap;->recycle()V

    iget-object v10, v1, Lcom/anime4k/screen/OverlayService;->overlayOutputSurface:Landroid/view/Surface;

    if-eqz v10, :cond_3

    iget-boolean v10, v1, Lcom/anime4k/screen/OverlayService;->surfaceReady:Z

    if-eqz v10, :cond_3

    invoke-direct {v1, v9}, Lcom/anime4k/screen/OverlayService;->renderToOverlay(I)V

    :cond_3
    iget v10, v1, Lcom/anime4k/screen/OverlayService;->frameCount:I

    add-int/lit8 v10, v10, 0x1

    iput v10, v1, Lcom/anime4k/screen/OverlayService;->frameCount:I

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v10

    .local v10, "now":J
    iget-wide v12, v1, Lcom/anime4k/screen/OverlayService;->fpsStartTime:J

    sub-long v14, v10, v12

    const-wide/16 v16, 0x3e8

    cmp-long v14, v14, v16

    if-ltz v14, :cond_4

    iget v14, v1, Lcom/anime4k/screen/OverlayService;->frameCount:I

    int-to-float v14, v14

    const/high16 v15, 0x447a0000    # 1000.0f

    mul-float/2addr v14, v15

    sub-long v12, v10, v12

    long-to-float v12, v12

    div-float/2addr v14, v12

    .local v14, "fps":F
    iput v3, v1, Lcom/anime4k/screen/OverlayService;->frameCount:I

    iput-wide v10, v1, Lcom/anime4k/screen/OverlayService;->fpsStartTime:J

    new-instance v3, Landroid/content/Intent;

    const-string v12, "com.anime4k.screen.FPS_UPDATE"

    invoke-direct {v3, v12}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .local v3, "fpsIntent":Landroid/content/Intent;
    const-string v12, "fps"

    invoke-virtual {v3, v12, v14}, Landroid/content/Intent;->putExtra(Ljava/lang/String;F)Landroid/content/Intent;

    invoke-virtual/range {p0 .. p0}, Lcom/anime4k/screen/OverlayService;->getPackageName()Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v3, v12}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    invoke-virtual {v1, v3}, Lcom/anime4k/screen/OverlayService;->sendBroadcast(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .end local v0    # "planes":[Landroid/media/Image$Plane;
    .end local v3    # "fpsIntent":Landroid/content/Intent;
    .end local v4    # "buffer":Ljava/nio/ByteBuffer;
    .end local v5    # "pixelStride":I
    .end local v6    # "rowStride":I
    .end local v7    # "bitmap":Landroid/graphics/Bitmap;
    .end local v8    # "rowPadding":I
    .end local v9    # "outputTex":I
    .end local v10    # "now":J
    .end local v14    # "fps":F
    :cond_4
    goto :goto_0

    :catch_0
    move-exception v0

    move-object v3, v0

    .local v3, "e":Ljava/lang/Exception;
    const-string v0, "OverlayService"

    const-string v4, "Error processing frame"

    invoke-static {v0, v4, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    if-eqz v2, :cond_5

    :try_start_1
    invoke-virtual {v2}, Landroid/media/Image;->close()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_0

    :catch_1
    move-exception v0

    .end local v3    # "e":Ljava/lang/Exception;
    :cond_5
    :goto_0
    invoke-direct/range {p0 .. p0}, Lcom/anime4k/screen/OverlayService;->scheduleNextFrame()V

    return-void

    .end local v2    # "image":Landroid/media/Image;
    :cond_6
    :goto_1
    invoke-direct/range {p0 .. p0}, Lcom/anime4k/screen/OverlayService;->scheduleNextFrame()V

    return-void
.end method

.method private releaseEGL()V
    .locals 2

    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->eglDisplay:Landroid/opengl/EGLDisplay;

    if-eqz v0, :cond_3

    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->eglOverlaySurface:Landroid/opengl/EGLSurface;

    if-eqz v0, :cond_0

    sget-object v1, Landroid/opengl/EGL14;->EGL_NO_SURFACE:Landroid/opengl/EGLSurface;

    if-eq v0, v1, :cond_0

    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->eglDisplay:Landroid/opengl/EGLDisplay;

    iget-object v1, p0, Lcom/anime4k/screen/OverlayService;->eglOverlaySurface:Landroid/opengl/EGLSurface;

    invoke-static {v0, v1}, Landroid/opengl/EGL14;->eglDestroySurface(Landroid/opengl/EGLDisplay;Landroid/opengl/EGLSurface;)Z

    :cond_0
    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->eglSurface:Landroid/opengl/EGLSurface;

    if-eqz v0, :cond_1

    sget-object v1, Landroid/opengl/EGL14;->EGL_NO_SURFACE:Landroid/opengl/EGLSurface;

    if-eq v0, v1, :cond_1

    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->eglDisplay:Landroid/opengl/EGLDisplay;

    iget-object v1, p0, Lcom/anime4k/screen/OverlayService;->eglSurface:Landroid/opengl/EGLSurface;

    invoke-static {v0, v1}, Landroid/opengl/EGL14;->eglDestroySurface(Landroid/opengl/EGLDisplay;Landroid/opengl/EGLSurface;)Z

    :cond_1
    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->eglContext:Landroid/opengl/EGLContext;

    if-eqz v0, :cond_2

    sget-object v1, Landroid/opengl/EGL14;->EGL_NO_CONTEXT:Landroid/opengl/EGLContext;

    if-eq v0, v1, :cond_2

    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->eglDisplay:Landroid/opengl/EGLDisplay;

    iget-object v1, p0, Lcom/anime4k/screen/OverlayService;->eglContext:Landroid/opengl/EGLContext;

    invoke-static {v0, v1}, Landroid/opengl/EGL14;->eglDestroyContext(Landroid/opengl/EGLDisplay;Landroid/opengl/EGLContext;)Z

    :cond_2
    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->eglDisplay:Landroid/opengl/EGLDisplay;

    invoke-static {v0}, Landroid/opengl/EGL14;->eglTerminate(Landroid/opengl/EGLDisplay;)Z

    :cond_3
    return-void
.end method

.method private renderToOverlay(I)V
    .locals 5
    .param p1, "texture"    # I

    :try_start_0
    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->eglOverlaySurface:Landroid/opengl/EGLSurface;

    if-eqz v0, :cond_0

    sget-object v1, Landroid/opengl/EGL14;->EGL_NO_SURFACE:Landroid/opengl/EGLSurface;

    if-ne v0, v1, :cond_1

    :cond_0
    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->overlayOutputSurface:Landroid/view/Surface;

    if-eqz v0, :cond_1

    const/4 v0, 0x1

    new-array v0, v0, [I

    const/16 v1, 0x3038

    const/4 v2, 0x0

    aput v1, v0, v2

    .local v0, "surfaceAttribs":[I
    iget-object v1, p0, Lcom/anime4k/screen/OverlayService;->eglDisplay:Landroid/opengl/EGLDisplay;

    invoke-direct {p0}, Lcom/anime4k/screen/OverlayService;->getEGLConfig()Landroid/opengl/EGLConfig;

    move-result-object v3

    iget-object v4, p0, Lcom/anime4k/screen/OverlayService;->overlayOutputSurface:Landroid/view/Surface;

    invoke-static {v1, v3, v4, v0, v2}, Landroid/opengl/EGL14;->eglCreateWindowSurface(Landroid/opengl/EGLDisplay;Landroid/opengl/EGLConfig;Ljava/lang/Object;[II)Landroid/opengl/EGLSurface;

    move-result-object v1

    iput-object v1, p0, Lcom/anime4k/screen/OverlayService;->eglOverlaySurface:Landroid/opengl/EGLSurface;

    .end local v0    # "surfaceAttribs":[I
    :cond_1
    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->eglOverlaySurface:Landroid/opengl/EGLSurface;

    if-eqz v0, :cond_3

    sget-object v1, Landroid/opengl/EGL14;->EGL_NO_SURFACE:Landroid/opengl/EGLSurface;

    if-ne v0, v1, :cond_2

    goto :goto_0

    :cond_2
    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->eglDisplay:Landroid/opengl/EGLDisplay;

    iget-object v1, p0, Lcom/anime4k/screen/OverlayService;->eglOverlaySurface:Landroid/opengl/EGLSurface;

    iget-object v2, p0, Lcom/anime4k/screen/OverlayService;->eglContext:Landroid/opengl/EGLContext;

    invoke-static {v0, v1, v1, v2}, Landroid/opengl/EGL14;->eglMakeCurrent(Landroid/opengl/EGLDisplay;Landroid/opengl/EGLSurface;Landroid/opengl/EGLSurface;Landroid/opengl/EGLContext;)Z

    const/16 v0, 0x4000

    invoke-static {v0}, Landroid/opengl/GLES20;->glClear(I)V

    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->renderer:Lcom/anime4k/screen/Anime4KRenderer;

    iget v1, p0, Lcom/anime4k/screen/OverlayService;->screenWidth:I

    iget v2, p0, Lcom/anime4k/screen/OverlayService;->screenHeight:I

    invoke-virtual {v0, p1, v1, v2}, Lcom/anime4k/screen/Anime4KRenderer;->renderToScreen(III)V

    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->eglDisplay:Landroid/opengl/EGLDisplay;

    iget-object v1, p0, Lcom/anime4k/screen/OverlayService;->eglOverlaySurface:Landroid/opengl/EGLSurface;

    invoke-static {v0, v1}, Landroid/opengl/EGL14;->eglSwapBuffers(Landroid/opengl/EGLDisplay;Landroid/opengl/EGLSurface;)Z

    invoke-direct {p0}, Lcom/anime4k/screen/OverlayService;->makePbufferCurrent()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :cond_3
    :goto_0
    return-void

    :catch_0
    move-exception v0

    .local v0, "e":Ljava/lang/Exception;
    const-string v1, "OverlayService"

    const-string v2, "Error rendering to overlay"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    iget-object v1, p0, Lcom/anime4k/screen/OverlayService;->eglOverlaySurface:Landroid/opengl/EGLSurface;

    if-eqz v1, :cond_4

    sget-object v2, Landroid/opengl/EGL14;->EGL_NO_SURFACE:Landroid/opengl/EGLSurface;

    if-eq v1, v2, :cond_4

    iget-object v1, p0, Lcom/anime4k/screen/OverlayService;->eglDisplay:Landroid/opengl/EGLDisplay;

    iget-object v2, p0, Lcom/anime4k/screen/OverlayService;->eglOverlaySurface:Landroid/opengl/EGLSurface;

    invoke-static {v1, v2}, Landroid/opengl/EGL14;->eglDestroySurface(Landroid/opengl/EGLDisplay;Landroid/opengl/EGLSurface;)Z

    const/4 v1, 0x0

    iput-object v1, p0, Lcom/anime4k/screen/OverlayService;->eglOverlaySurface:Landroid/opengl/EGLSurface;

    .end local v0    # "e":Ljava/lang/Exception;
    :cond_4
    :goto_1
    return-void
.end method

.method private scheduleNextFrame()V
    .locals 4

    iget-boolean v0, p0, Lcom/anime4k/screen/OverlayService;->isRunning:Z

    if-nez v0, :cond_0

    return-void

    :cond_0
    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->processingHandler:Landroid/os/Handler;

    new-instance v1, Lcom/anime4k/screen/OverlayService$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0}, Lcom/anime4k/screen/OverlayService$$ExternalSyntheticLambda1;-><init>(Lcom/anime4k/screen/OverlayService;)V

    iget v2, p0, Lcom/anime4k/screen/OverlayService;->frameInterval:I

    int-to-long v2, v2

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

.method private startCapture(ILandroid/content/Intent;)V
    .locals 11
    .param p1, "resultCode"    # I
    .param p2, "data"    # Landroid/content/Intent;

    new-instance v0, Landroid/os/HandlerThread;

    const-string v1, "Anime4K-Processing"

    invoke-direct {v0, v1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lcom/anime4k/screen/OverlayService;->processingThread:Landroid/os/HandlerThread;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    new-instance v0, Landroid/os/Handler;

    iget-object v1, p0, Lcom/anime4k/screen/OverlayService;->processingThread:Landroid/os/HandlerThread;

    invoke-virtual {v1}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/anime4k/screen/OverlayService;->processingHandler:Landroid/os/Handler;

    const-string v0, "media_projection"

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/OverlayService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/media/projection/MediaProjectionManager;

    .local v0, "projectionManager":Landroid/media/projection/MediaProjectionManager;
    invoke-virtual {v0, p1, p2}, Landroid/media/projection/MediaProjectionManager;->getMediaProjection(ILandroid/content/Intent;)Landroid/media/projection/MediaProjection;

    move-result-object v1

    iput-object v1, p0, Lcom/anime4k/screen/OverlayService;->mediaProjection:Landroid/media/projection/MediaProjection;

    new-instance v2, Lcom/anime4k/screen/OverlayService$2;

    invoke-direct {v2, p0}, Lcom/anime4k/screen/OverlayService$2;-><init>(Lcom/anime4k/screen/OverlayService;)V

    iget-object v3, p0, Lcom/anime4k/screen/OverlayService;->processingHandler:Landroid/os/Handler;

    invoke-virtual {v1, v2, v3}, Landroid/media/projection/MediaProjection;->registerCallback(Landroid/media/projection/MediaProjection$Callback;Landroid/os/Handler;)V

    iget v1, p0, Lcom/anime4k/screen/OverlayService;->captureWidth:I

    iget v2, p0, Lcom/anime4k/screen/OverlayService;->captureHeight:I

    const/4 v3, 0x1

    const/4 v4, 0x2

    invoke-static {v1, v2, v3, v4}, Landroid/media/ImageReader;->newInstance(IIII)Landroid/media/ImageReader;

    move-result-object v1

    iput-object v1, p0, Lcom/anime4k/screen/OverlayService;->imageReader:Landroid/media/ImageReader;

    iget-object v2, p0, Lcom/anime4k/screen/OverlayService;->mediaProjection:Landroid/media/projection/MediaProjection;

    const-string v3, "Anime4KCapture"

    iget v4, p0, Lcom/anime4k/screen/OverlayService;->captureWidth:I

    iget v5, p0, Lcom/anime4k/screen/OverlayService;->captureHeight:I

    iget v6, p0, Lcom/anime4k/screen/OverlayService;->screenDensity:I

    const/16 v7, 0x10

    invoke-virtual {v1}, Landroid/media/ImageReader;->getSurface()Landroid/view/Surface;

    move-result-object v8

    const/4 v9, 0x0

    iget-object v10, p0, Lcom/anime4k/screen/OverlayService;->processingHandler:Landroid/os/Handler;

    invoke-virtual/range {v2 .. v10}, Landroid/media/projection/MediaProjection;->createVirtualDisplay(Ljava/lang/String;IIIILandroid/view/Surface;Landroid/hardware/display/VirtualDisplay$Callback;Landroid/os/Handler;)Landroid/hardware/display/VirtualDisplay;

    move-result-object v1

    iput-object v1, p0, Lcom/anime4k/screen/OverlayService;->virtualDisplay:Landroid/hardware/display/VirtualDisplay;

    iget-object v1, p0, Lcom/anime4k/screen/OverlayService;->processingHandler:Landroid/os/Handler;

    new-instance v2, Lcom/anime4k/screen/OverlayService$$ExternalSyntheticLambda0;

    invoke-direct {v2, p0}, Lcom/anime4k/screen/OverlayService$$ExternalSyntheticLambda0;-><init>(Lcom/anime4k/screen/OverlayService;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private startOverlay()V
    .locals 10

    # Create SurfaceView
    new-instance v0, Landroid/view/SurfaceView;
    invoke-direct {v0, p0}, Landroid/view/SurfaceView;-><init>(Landroid/content/Context;)V
    iput-object v0, p0, Lcom/anime4k/screen/OverlayService;->overlaySurfaceView:Landroid/view/SurfaceView;

    # v1.3.3: MINIMAL FIX - Only use TYPE_APPLICATION_OVERLAY with alpha=0.7
    const/16 v1, 0x7f6
    iget-object v2, p0, Lcom/anime4k/screen/OverlayService;->windowManager:Landroid/view/WindowManager;
    
    # FLAG_NOT_FOCUSABLE | FLAG_NOT_TOUCHABLE | FLAG_LAYOUT_IN_SCREEN | FLAG_LAYOUT_NO_LIMITS | FLAG_HARDWARE_ACCELERATED
    const v8, 0x1000318

    # Alpha = 0.7f (Safe threshold for Android 12+ touch passthrough)
    # 0x3f333333 = 0.7f
    const v9, 0x3f333333

    new-instance v3, Landroid/view/WindowManager$LayoutParams;
    invoke-direct {v3}, Landroid/view/WindowManager$LayoutParams;-><init>()V
    const/4 v4, -0x1
    iput v4, v3, Landroid/view/WindowManager$LayoutParams;->width:I
    iput v4, v3, Landroid/view/WindowManager$LayoutParams;->height:I
    iput v1, v3, Landroid/view/WindowManager$LayoutParams;->type:I
    iput v8, v3, Landroid/view/WindowManager$LayoutParams;->flags:I
    const/4 v4, -0x3
    iput v4, v3, Landroid/view/WindowManager$LayoutParams;->format:I

    iput-object v3, p0, Lcom/anime4k/screen/OverlayService;->overlayParams:Landroid/view/WindowManager$LayoutParams;

    const v4, 0x800033
    iput v4, v3, Landroid/view/WindowManager$LayoutParams;->gravity:I
    const/4 v4, 0x0
    iput v4, v3, Landroid/view/WindowManager$LayoutParams;->x:I
    iput v4, v3, Landroid/view/WindowManager$LayoutParams;->y:I

    # Force alpha = 0.7 on Android 12+
    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I
    const/16 v5, 0x1f
    if-lt v4, v5, :cond_skip_alpha
    iput v9, v3, Landroid/view/WindowManager$LayoutParams;->alpha:F
    :cond_skip_alpha

    iget-object v4, p0, Lcom/anime4k/screen/OverlayService;->overlaySurfaceView:Landroid/view/SurfaceView;
    invoke-virtual {v4}, Landroid/view/SurfaceView;->getHolder()Landroid/view/SurfaceHolder;
    move-result-object v4
    new-instance v5, Lcom/anime4k/screen/OverlayService$1;
    invoke-direct {v5, p0}, Lcom/anime4k/screen/OverlayService$1;-><init>(Lcom/anime4k/screen/OverlayService;)V
    invoke-interface {v4, v5}, Landroid/view/SurfaceHolder;->addCallback(Landroid/view/SurfaceHolder$Callback;)V

    # v1.3.3: Try setZOrderOnTop(false) to see if it helps with touch on some devices
    iget-object v4, p0, Lcom/anime4k/screen/OverlayService;->overlaySurfaceView:Landroid/view/SurfaceView;
    const/4 v5, 0x0
    invoke-virtual {v4, v5}, Landroid/view/SurfaceView;->setZOrderOnTop(Z)V

    iget-object v4, p0, Lcom/anime4k/screen/OverlayService;->overlaySurfaceView:Landroid/view/SurfaceView;
    invoke-virtual {v4}, Landroid/view/SurfaceView;->getHolder()Landroid/view/SurfaceHolder;
    move-result-object v4
    const/4 v5, -0x3
    invoke-interface {v4, v5}, Landroid/view/SurfaceHolder;->setFormat(I)V

    iget-object v4, p0, Lcom/anime4k/screen/OverlayService;->overlaySurfaceView:Landroid/view/SurfaceView;
    iget-object v5, p0, Lcom/anime4k/screen/OverlayService;->overlayParams:Landroid/view/WindowManager$LayoutParams;
    invoke-interface {v2, v4, v5}, Landroid/view/WindowManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    iput-object v2, p0, Lcom/anime4k/screen/OverlayService;->windowManager:Landroid/view/WindowManager;

    return-void
.end method


# virtual methods
.method synthetic lambda$onDestroy$1$com-anime4k-screen-OverlayService()V
    .locals 1

    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->renderer:Lcom/anime4k/screen/Anime4KRenderer;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Lcom/anime4k/screen/Anime4KRenderer;->release()V

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/anime4k/screen/OverlayService;->renderer:Lcom/anime4k/screen/Anime4KRenderer;

    :cond_0
    invoke-direct {p0}, Lcom/anime4k/screen/OverlayService;->releaseEGL()V

    return-void
.end method

.method synthetic lambda$startCapture$0$com-anime4k-screen-OverlayService()V
    .locals 5

    invoke-direct {p0}, Lcom/anime4k/screen/OverlayService;->initEGL()V

    new-instance v0, Lcom/anime4k/screen/Anime4KRenderer;

    invoke-direct {v0}, Lcom/anime4k/screen/Anime4KRenderer;-><init>()V

    iput-object v0, p0, Lcom/anime4k/screen/OverlayService;->renderer:Lcom/anime4k/screen/Anime4KRenderer;

    iget v1, p0, Lcom/anime4k/screen/OverlayService;->refineStrength:F

    invoke-virtual {v0, v1}, Lcom/anime4k/screen/Anime4KRenderer;->setRefineStrength(F)V

    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->renderer:Lcom/anime4k/screen/Anime4KRenderer;

    iget v1, p0, Lcom/anime4k/screen/OverlayService;->captureWidth:I

    iget v2, p0, Lcom/anime4k/screen/OverlayService;->captureHeight:I

    iget v3, p0, Lcom/anime4k/screen/OverlayService;->screenWidth:I

    iget v4, p0, Lcom/anime4k/screen/OverlayService;->screenHeight:I

    invoke-virtual {v0, v1, v2, v3, v4}, Lcom/anime4k/screen/Anime4KRenderer;->init(IIII)V

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/anime4k/screen/OverlayService;->isRunning:Z

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/anime4k/screen/OverlayService;->fpsStartTime:J

    invoke-direct {p0}, Lcom/anime4k/screen/OverlayService;->scheduleNextFrame()V

    return-void
.end method

.method public onBind(Landroid/content/Intent;)Landroid/os/IBinder;
    .locals 1
    .param p1, "intent"    # Landroid/content/Intent;

    const/4 v0, 0x0

    return-object v0
.end method

.method public onCreate()V
    .locals 2

    invoke-super {p0}, Landroid/app/Service;->onCreate()V

    const-string v0, "window"

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/OverlayService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/WindowManager;

    iput-object v0, p0, Lcom/anime4k/screen/OverlayService;->windowManager:Landroid/view/WindowManager;

    new-instance v0, Landroid/util/DisplayMetrics;

    invoke-direct {v0}, Landroid/util/DisplayMetrics;-><init>()V

    .local v0, "metrics":Landroid/util/DisplayMetrics;
    iget-object v1, p0, Lcom/anime4k/screen/OverlayService;->windowManager:Landroid/view/WindowManager;

    invoke-interface {v1}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v1

    invoke-virtual {v1, v0}, Landroid/view/Display;->getRealMetrics(Landroid/util/DisplayMetrics;)V

    iget v1, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    iput v1, p0, Lcom/anime4k/screen/OverlayService;->screenWidth:I

    iget v1, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    iput v1, p0, Lcom/anime4k/screen/OverlayService;->screenHeight:I

    iget v1, v0, Landroid/util/DisplayMetrics;->densityDpi:I

    iput v1, p0, Lcom/anime4k/screen/OverlayService;->screenDensity:I

    invoke-direct {p0}, Lcom/anime4k/screen/OverlayService;->createNotificationChannel()V

    return-void
.end method

.method public onDestroy()V
    .locals 4

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/anime4k/screen/OverlayService;->isRunning:Z

    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->virtualDisplay:Landroid/hardware/display/VirtualDisplay;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/hardware/display/VirtualDisplay;->release()V

    iput-object v1, p0, Lcom/anime4k/screen/OverlayService;->virtualDisplay:Landroid/hardware/display/VirtualDisplay;

    :cond_0
    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->mediaProjection:Landroid/media/projection/MediaProjection;

    if-eqz v0, :cond_1

    invoke-virtual {v0}, Landroid/media/projection/MediaProjection;->stop()V

    iput-object v1, p0, Lcom/anime4k/screen/OverlayService;->mediaProjection:Landroid/media/projection/MediaProjection;

    :cond_1
    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->imageReader:Landroid/media/ImageReader;

    if-eqz v0, :cond_2

    invoke-virtual {v0}, Landroid/media/ImageReader;->close()V

    iput-object v1, p0, Lcom/anime4k/screen/OverlayService;->imageReader:Landroid/media/ImageReader;

    :cond_2
    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->processingHandler:Landroid/os/Handler;

    if-eqz v0, :cond_3

    new-instance v2, Lcom/anime4k/screen/OverlayService$$ExternalSyntheticLambda2;

    invoke-direct {v2, p0}, Lcom/anime4k/screen/OverlayService$$ExternalSyntheticLambda2;-><init>(Lcom/anime4k/screen/OverlayService;)V

    invoke-virtual {v0, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :cond_3
    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->overlaySurfaceView:Landroid/view/SurfaceView;

    if-eqz v0, :cond_4

    :try_start_0
    iget-object v2, p0, Lcom/anime4k/screen/OverlayService;->windowManager:Landroid/view/WindowManager;

    invoke-interface {v2, v0}, Landroid/view/WindowManager;->removeView(Landroid/view/View;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .local v0, "e":Ljava/lang/Exception;
    const-string v2, "OverlayService"

    const-string v3, "Error removing overlay"

    invoke-static {v2, v3, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .end local v0    # "e":Ljava/lang/Exception;
    :goto_0
    iput-object v1, p0, Lcom/anime4k/screen/OverlayService;->overlaySurfaceView:Landroid/view/SurfaceView;

    :cond_4
    iget-object v0, p0, Lcom/anime4k/screen/OverlayService;->processingThread:Landroid/os/HandlerThread;

    if-eqz v0, :cond_5

    invoke-virtual {v0}, Landroid/os/HandlerThread;->quitSafely()Z

    iput-object v1, p0, Lcom/anime4k/screen/OverlayService;->processingThread:Landroid/os/HandlerThread;

    :cond_5
    new-instance v0, Landroid/content/Intent;

    const-string v1, "com.anime4k.screen.SERVICE_STOPPED"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .local v0, "intent":Landroid/content/Intent;
    invoke-virtual {p0}, Lcom/anime4k/screen/OverlayService;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/OverlayService;->sendBroadcast(Landroid/content/Intent;)V

    invoke-super {p0}, Landroid/app/Service;->onDestroy()V

    return-void
.end method

.method public onStartCommand(Landroid/content/Intent;II)I
    .locals 8
    .param p1, "intent"    # Landroid/content/Intent;
    .param p2, "flags"    # I
    .param p3, "startId"    # I

    const/4 v0, 0x2

    if-nez p1, :cond_0

    return v0

    :cond_0
    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v1

    .local v1, "action":Ljava/lang/String;
    const-string v2, "STOP"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-virtual {p0}, Lcom/anime4k/screen/OverlayService;->stopSelf()V

    return v0

    :cond_1
    const-string v2, "START"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2

    const-string v2, "resultCode"

    const/4 v3, 0x0

    invoke-virtual {p1, v2, v3}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v2

    .local v2, "resultCode":I
    const-string v4, "data"

    invoke-virtual {p1, v4}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object v4

    check-cast v4, Landroid/content/Intent;

    .local v4, "data":Landroid/content/Intent;
    const-string v5, "scale"

    const/16 v6, 0x32

    invoke-virtual {p1, v5, v6}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v5

    int-to-float v5, v5

    const/high16 v7, 0x42c80000    # 100.0f

    div-float/2addr v5, v7

    iput v5, p0, Lcom/anime4k/screen/OverlayService;->captureScale:F

    const-string v5, "strength"

    invoke-virtual {p1, v5, v6}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v5

    int-to-float v5, v5

    div-float/2addr v5, v7

    iput v5, p0, Lcom/anime4k/screen/OverlayService;->refineStrength:F

    const-string v5, "interval"

    const/16 v6, 0x64

    invoke-virtual {p1, v5, v6}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v5

    iput v5, p0, Lcom/anime4k/screen/OverlayService;->frameInterval:I

    const-string v5, "useAccessibility"

    invoke-virtual {p1, v5, v3}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result v3

    iput-boolean v3, p0, Lcom/anime4k/screen/OverlayService;->useAccessibilityMode:Z

    iget v3, p0, Lcom/anime4k/screen/OverlayService;->screenWidth:I

    int-to-float v3, v3

    iget v5, p0, Lcom/anime4k/screen/OverlayService;->captureScale:F

    mul-float/2addr v3, v5

    float-to-int v3, v3

    iput v3, p0, Lcom/anime4k/screen/OverlayService;->captureWidth:I

    iget v6, p0, Lcom/anime4k/screen/OverlayService;->screenHeight:I

    int-to-float v6, v6

    mul-float/2addr v6, v5

    float-to-int v5, v6

    iput v5, p0, Lcom/anime4k/screen/OverlayService;->captureHeight:I

    div-int/2addr v3, v0

    mul-int/2addr v3, v0

    iput v3, p0, Lcom/anime4k/screen/OverlayService;->captureWidth:I

    div-int/2addr v5, v0

    mul-int/2addr v5, v0

    iput v5, p0, Lcom/anime4k/screen/OverlayService;->captureHeight:I

    const/4 v3, 0x1

    invoke-direct {p0}, Lcom/anime4k/screen/OverlayService;->createNotification()Landroid/app/Notification;

    move-result-object v5

    invoke-virtual {p0, v3, v5}, Lcom/anime4k/screen/OverlayService;->startForeground(ILandroid/app/Notification;)V

    invoke-direct {p0}, Lcom/anime4k/screen/OverlayService;->startOverlay()V

    invoke-direct {p0, v2, v4}, Lcom/anime4k/screen/OverlayService;->startCapture(ILandroid/content/Intent;)V

    .end local v2    # "resultCode":I
    .end local v4    # "data":Landroid/content/Intent;
    :cond_2
    return v0
.end method
