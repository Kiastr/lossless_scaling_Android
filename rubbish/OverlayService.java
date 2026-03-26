            EGLSurface eGLSurface2 = this.eglOverlaySurface;
            if (eGLSurface2 != null && eGLSurface2 != EGL14.EGL_NO_SURFACE) {
                EGLDisplay eGLDisplay = this.eglDisplay;
                EGLSurface eGLSurface3 = this.eglOverlaySurface;
                EGL14.eglMakeCurrent(eGLDisplay, eGLSurface3, eGLSurface3, this.eglContext);
                GLES20.glClear(16384);
                this.renderer.renderToScreen(texture, this.screenWidth, this.screenHeight);
                EGL14.eglSwapBuffers(this.eglDisplay, this.eglOverlaySurface);
                makePbufferCurrent();
            }
        } catch (Exception e) {
            Log.e(TAG, "Error rendering to overlay", e);
            EGLSurface eGLSurface4 = this.eglOverlaySurface;
            if (eGLSurface4 != null && eGLSurface4 != EGL14.EGL_NO_SURFACE) {
                EGL14.eglDestroySurface(this.eglDisplay, this.eglOverlaySurface);
                this.eglOverlaySurface = null;
            }
        }
    }

    private void initEGL() {
        EGLDisplay eglGetDisplay = EGL14.eglGetDisplay(0);
        this.eglDisplay = eglGetDisplay;
        int[] version = new int[2];
        EGL14.eglInitialize(eglGetDisplay, version, 0, version, 1);
        EGLConfig config = getEGLConfig();
        int[] contextAttribs = {12440, 2, 12344};
        this.eglContext = EGL14.eglCreateContext(this.eglDisplay, config, EGL14.EGL_NO_CONTEXT, contextAttribs, 0);
        int[] pbufferAttribs = {12375, 1, 12374, 1, 12344};
        this.eglSurface = EGL14.eglCreatePbufferSurface(this.eglDisplay, config, pbufferAttribs, 0);
        makePbufferCurrent();
    }

    private void makePbufferCurrent() {
        EGLDisplay eGLDisplay = this.eglDisplay;
        EGLSurface eGLSurface = this.eglSurface;
        EGL14.eglMakeCurrent(eGLDisplay, eGLSurface, eGLSurface, this.eglContext);
    }

    private EGLConfig getEGLConfig() {
        int[] configAttribs = {12324, 8, 12323, 8, 12322, 8, 12321, 8, 12352, 4, 12339, 5, 12344};
        EGLConfig[] configs = new EGLConfig[1];
        int[] numConfigs = new int[1];
        EGL14.eglChooseConfig(this.eglDisplay, configAttribs, 0, configs, 0, 1, numConfigs, 0);
        return configs[0];
    }

    private void releaseEGL() {
        if (this.eglDisplay != null) {
            EGLSurface eGLSurface = this.eglOverlaySurface;
            if (eGLSurface != null && eGLSurface != EGL14.EGL_NO_SURFACE) {
                EGL14.eglDestroySurface(this.eglDisplay, this.eglOverlaySurface);
            }
            EGLSurface eGLSurface2 = this.eglSurface;
            if (eGLSurface2 != null && eGLSurface2 != EGL14.EGL_NO_SURFACE) {
                EGL14.eglDestroySurface(this.eglDisplay, this.eglSurface);
            }
            EGLContext eGLContext = this.eglContext;
            if (eGLContext != null && eGLContext != EGL14.EGL_NO_CONTEXT) {
                EGL14.eglDestroyContext(this.eglDisplay, this.eglContext);
            }
            EGL14.eglTerminate(this.eglDisplay);
        }
    }

    private void createNotificationChannel() {
        NotificationChannel channel = new NotificationChannel(CHANNEL_ID, "Anime4K Screen Service", 2);
        channel.setDescription("Anime4K 屏幕超分服务运行通知");
        NotificationManager manager = (NotificationManager) getSystemService(NotificationManager.class);
        manager.createNotificationChannel(channel);
    }

    private Notification createNotification() {
        Intent notificationIntent = new Intent(this, (Class<?>) MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 67108864);
        Intent stopIntent = new Intent(this, (Class<?>) OverlayService.class);
        stopIntent.setAction("STOP");
        PendingIntent stopPendingIntent = PendingIntent.getService(this, 1, stopIntent, 67108864);
        String touchMode = this.useAccessibilityMode ? "无障碍触控" : "传统穿透";
        Notification.Builder builder = new Notification.Builder(this, CHANNEL_ID);
        return builder.setContentTitle("Anime4K 屏幕超分运行中").setContentText("捕获: " + this.captureWidth + "x" + this.captureHeight + " → 输出: " + this.screenWidth + "x" + this.screenHeight + " | " + touchMode).setSmallIcon(android.R.drawable.ic_menu_view).setContentIntent(pendingIntent).addAction(android.R.drawable.ic_media_pause, "停止", stopPendingIntent).setOngoing(true).build();
    }

    @Override // android.app.Service
    public void onDestroy() {
        this.isRunning = false;
        VirtualDisplay virtualDisplay = this.virtualDisplay;
        if (virtualDisplay != null) {
            virtualDisplay.release();
            this.virtualDisplay = null;
        }
        MediaProjection mediaProjection = this.mediaProjection;
        if (mediaProjection != null) {
            mediaProjection.stop();
            this.mediaProjection = null;
        }
        ImageReader imageReader = this.imageReader;
        if (imageReader != null) {
            imageReader.close();
            this.imageReader = null;
        }
        Handler handler = this.processingHandler;
        if (handler != null) {
            handler.post(new Runnable() { // from class: com.anime4k.screen.OverlayService$$ExternalSyntheticLambda2
                @Override // java.lang.Runnable
                public final void run() {
                    OverlayService.this.m56lambda$onDestroy$1$comanime4kscreenOverlayService();
                }
            });
        }
        SurfaceView surfaceView = this.overlaySurfaceView;
        if (surfaceView != null) {
            try {
                this.windowManager.removeView(surfaceView);
            } catch (Exception e) {
                Log.e(TAG, "Error removing overlay", e);
            }
            this.overlaySurfaceView = null;
        }
        HandlerThread handlerThread = this.processingThread;
        if (handlerThread != null) {
            handlerThread.quitSafely();
            this.processingThread = null;
        }
        Intent intent = new Intent("com.anime4k.screen.SERVICE_STOPPED");
        intent.setPackage(getPackageName());
        sendBroadcast(intent);
        super.onDestroy();
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    /* renamed from: lambda$onDestroy$1$com-anime4k-screen-OverlayService, reason: not valid java name */
    public /* synthetic */ void m56lambda$onDestroy$1$comanime4kscreenOverlayService() {
        Anime4KRenderer anime4KRenderer = this.renderer;
        if (anime4KRenderer != null) {
            anime4KRenderer.release();
            this.renderer = null;
        }
        releaseEGL();