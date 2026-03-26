package com.anime4k.screen;

import android.content.Context;
import android.os.Handler;
import android.os.SystemClock;
import android.util.Log;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

/* loaded from: classes3.dex */
public class TouchInterceptView extends SurfaceView {
    private static final long LONG_PRESS_TIMEOUT = 500;
    private static final String TAG = "TouchInterceptView";
    private static final long TAP_TIMEOUT = 200;
    private static final int TOUCH_SLOP = 10;
    private long downTime;
    private float downX;
    private float downY;
    private Handler handler;
    private boolean isDragging;
    private boolean isMultiTouch;
    private Runnable longPressRunnable;
    private boolean longPressTriggered;
    private float pinchCenterX;
    private float pinchCenterY;
    private float pinchStartSpan;
    private SurfaceHolder.Callback surfaceCallback;

    public TouchInterceptView(Context context) {
        super(context);
        this.isDragging = false;
        this.isMultiTouch = false;
        this.longPressTriggered = false;
        this.handler = new Handler();
    }

    public void setSurfaceCallback(SurfaceHolder.Callback callback) {
        this.surfaceCallback = callback;
        getHolder().addCallback(callback);
    }

    @Override // android.view.View
    public boolean onTouchEvent(MotionEvent event) {
        TouchForwardingAccessibilityService service = TouchForwardingAccessibilityService.getInstance();
        if (service == null) {
            Log.w(TAG, "Accessibility service not running, touch not forwarded");
            return true;
        }
        int action = event.getActionMasked();
        event.getPointerCount();
        switch (action) {
            case 0:
                handleActionDown(event);
                break;
            case 1:
                handleActionUp(event, service);
                break;
            case 2:
                handleActionMove(event, service);
                break;
            case 3:
                resetTouchState();
                break;
            case 5:
                handlePointerDown(event);
                break;
            case 6:
                handlePointerUp(event);
                break;
        }
        return true;
    }

    private void handleActionDown(MotionEvent event) {
        this.downX = event.getRawX();
        this.downY = event.getRawY();
        this.downTime = SystemClock.uptimeMillis();
        this.isDragging = false;
        this.isMultiTouch = false;
        this.longPressTriggered = false;
        cancelLongPress();
        Runnable runnable = new Runnable() { // from class: com.anime4k.screen.TouchInterceptView$$ExternalSyntheticLambda0
            @Override // java.lang.Runnable
            public final void run() {
                TouchInterceptView.this.m58lambda$handleActionDown$0$comanime4kscreenTouchInterceptView();
            }
        };
        this.longPressRunnable = runnable;
        this.handler.postDelayed(runnable, LONG_PRESS_TIMEOUT);
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    /* renamed from: lambda$handleActionDown$0$com-anime4k-screen-TouchInterceptView, reason: not valid java name */
    public /* synthetic */ void m58lambda$handleActionDown$0$comanime4kscreenTouchInterceptView() {
        if (!this.isDragging && !this.isMultiTouch) {
            this.longPressTriggered = true;
            TouchForwardingAccessibilityService svc = TouchForwardingAccessibilityService.getInstance();
            if (svc != null) {
                svc.performLongPress(this.downX, this.downY, 1000L);
                Log.d(TAG, "Long press detected at (" + this.downX + ", " + this.downY + ")");
            }
        }
    }

    private void handlePointerDown(MotionEvent event) {
        this.isMultiTouch = true;
        cancelLongPress();
        if (event.getPointerCount() == 2) {
            float dx = event.getX(0) - event.getX(1);
            float dy = event.getY(0) - event.getY(1);
            this.pinchStartSpan = (float) Math.sqrt((dx * dx) + (dy * dy));
            this.pinchCenterX = (event.getRawX() + event.getX(1)) / 2.0f;
            this.pinchCenterY = (event.getRawY() + event.getY(1)) / 2.0f;
            this.pinchCenterX = (event.getX(0) + event.getX(1)) / 2.0f;
            this.pinchCenterY = (event.getY(0) + event.getY(1)) / 2.0f;
            int[] location = new int[2];
            getLocationOnScreen(location);
            this.pinchCenterX += location[0];
            this.pinchCenterY += location[1];
        }
    }

    private void handleActionMove(MotionEvent event, TouchForwardingAccessibilityService service) {
        if (this.longPressTriggered) {
            return;
        }
        if (this.isMultiTouch) {
            cancelLongPress();
            return;
        }
        float currentX = event.getRawX();
        float currentY = event.getRawY();
        float deltaX = currentX - this.downX;
        float deltaY = currentY - this.downY;
        float distance = (float) Math.sqrt((deltaX * deltaX) + (deltaY * deltaY));
        if (distance > 10.0f && !this.isDragging) {
            this.isDragging = true;
            cancelLongPress();
        }
    }

    private void handleActionUp(MotionEvent event, TouchForwardingAccessibilityService service) {
        cancelLongPress();
        if (this.longPressTriggered) {
            resetTouchState();
            return;
        }
        float upX = event.getRawX();
        float upY = event.getRawY();
        long elapsed = SystemClock.uptimeMillis() - this.downTime;
        if (this.isMultiTouch) {
            event.getPointerCount();
            resetTouchState();
            return;
        }
        if (this.isDragging) {
            service.performSwipe(this.downX, this.downY, upX, upY, Math.max(elapsed, 50L));
            Log.d(TAG, "Swipe detected from (" + this.downX + "," + this.downY + ") to (" + upX + "," + upY + "), duration=" + elapsed);
        } else {
            float deltaX = upX - this.downX;
            float deltaY = upY - this.downY;
            float distance = (float) Math.sqrt((deltaX * deltaX) + (deltaY * deltaY));
            if (distance <= 10.0f && elapsed <= TAP_TIMEOUT) {
                service.performClick(this.downX, this.downY);
                Log.d(TAG, "Tap detected at (" + this.downX + ", " + this.downY + ")");
            } else if (distance <= 10.0f) {
                service.performClick(this.downX, this.downY);
                Log.d(TAG, "Slow tap detected at (" + this.downX + ", " + this.downY + ")");
            }
        }
        resetTouchState();
    }

    private void handlePointerUp(MotionEvent event) {
        TouchForwardingAccessibilityService service;
        if (event.getPointerCount() == 2 && this.isMultiTouch) {
            float dx = event.getX(0) - event.getX(1);
            float dy = event.getY(0) - event.getY(1);
            float endSpan = (float) Math.sqrt((dx * dx) + (dy * dy));
            float f = this.pinchStartSpan;
            if (f > 0.0f && Math.abs(endSpan - f) > 30.0f && (service = TouchForwardingAccessibilityService.getInstance()) != null) {
                long elapsed = SystemClock.uptimeMillis() - this.downTime;
                service.performPinch(this.pinchCenterX, this.pinchCenterY, this.pinchStartSpan, endSpan, Math.max(elapsed, 300L));
                Log.d(TAG, "Pinch detected: span " + this.pinchStartSpan + " -> " + endSpan);
            }
        }
    }

    @Override // android.view.View
    public void cancelLongPress() {
        Runnable runnable = this.longPressRunnable;
        if (runnable != null) {
            this.handler.removeCallbacks(runnable);
            this.longPressRunnable = null;
        }
    }

    private void resetTouchState() {
        this.isDragging = false;
        this.isMultiTouch = false;
        this.longPressTriggered = false;
        this.pinchStartSpan = 0.0f;
        cancelLongPress();
    }
}
