package com.anime4k.screen;

import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.GestureDescription;
import android.graphics.Path;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;

/* loaded from: classes3.dex */
public class TouchForwardingAccessibilityService extends AccessibilityService {
    private static final String TAG = "TouchForwardA11y";
    private static TouchForwardingAccessibilityService instance;
    private AccessibilityService.GestureResultCallback gestureCallback = new AccessibilityService.GestureResultCallback() { // from class: com.anime4k.screen.TouchForwardingAccessibilityService.1
        @Override // android.accessibilityservice.AccessibilityService.GestureResultCallback
        public void onCompleted(GestureDescription gestureDescription) {
            Log.d(TouchForwardingAccessibilityService.TAG, "Gesture completed successfully");
        }

        @Override // android.accessibilityservice.AccessibilityService.GestureResultCallback
        public void onCancelled(GestureDescription gestureDescription) {
            Log.w(TouchForwardingAccessibilityService.TAG, "Gesture was cancelled");
        }
    };

    @Override // android.accessibilityservice.AccessibilityService
    public void onServiceConnected() {
        super.onServiceConnected();
        instance = this;
        Log.i(TAG, "Accessibility service connected");
    }

    @Override // android.accessibilityservice.AccessibilityService
    public void onAccessibilityEvent(AccessibilityEvent event) {
    }

    @Override // android.accessibilityservice.AccessibilityService
    public void onInterrupt() {
        Log.w(TAG, "Accessibility service interrupted");
    }

    @Override // android.app.Service
    public void onDestroy() {
        instance = null;
        Log.i(TAG, "Accessibility service destroyed");
        super.onDestroy();
    }

    public static TouchForwardingAccessibilityService getInstance() {
        return instance;
    }

    public static boolean isServiceRunning() {
        return instance != null;
    }

    public void performClick(float x, float y) {
        Path clickPath = new Path();
        clickPath.moveTo(x, y);
        GestureDescription.StrokeDescription clickStroke = new GestureDescription.StrokeDescription(clickPath, 0L, 100L);
        GestureDescription.Builder builder = new GestureDescription.Builder();
        builder.addStroke(clickStroke);
        boolean dispatched = dispatchGesture(builder.build(), this.gestureCallback, null);
        Log.d(TAG, "Click dispatched at (" + x + ", " + y + "): " + dispatched);
    }

    public void performLongPress(float x, float y, long duration) {
        Path longPressPath = new Path();
        longPressPath.moveTo(x, y);
        GestureDescription.StrokeDescription longPressStroke = new GestureDescription.StrokeDescription(longPressPath, 0L, Math.max(duration, 500L));
        GestureDescription.Builder builder = new GestureDescription.Builder();
        builder.addStroke(longPressStroke);
        boolean dispatched = dispatchGesture(builder.build(), this.gestureCallback, null);
        Log.d(TAG, "Long press dispatched at (" + x + ", " + y + "), duration=" + duration + ": " + dispatched);
    }

    public void performSwipe(float startX, float startY, float endX, float endY, long duration) {
        Path swipePath = new Path();
        swipePath.moveTo(startX, startY);
        swipePath.lineTo(endX, endY);
        GestureDescription.StrokeDescription swipeStroke = new GestureDescription.StrokeDescription(swipePath, 0L, Math.max(duration, 50L));
        GestureDescription.Builder builder = new GestureDescription.Builder();
        builder.addStroke(swipeStroke);
        boolean dispatched = dispatchGesture(builder.build(), this.gestureCallback, null);
        Log.d(TAG, "Swipe dispatched from (" + startX + "," + startY + ") to (" + endX + "," + endY + "), duration=" + duration + ": " + dispatched);
    }

    public void performPinch(float centerX, float centerY, float startSpan, float endSpan, long duration) {
        float halfStartSpan = startSpan / 2.0f;
        float halfEndSpan = endSpan / 2.0f;
        Path finger1Path = new Path();
        finger1Path.moveTo(centerX - halfStartSpan, centerY);
        finger1Path.lineTo(centerX - halfEndSpan, centerY);
        Path finger2Path = new Path();
        finger2Path.moveTo(centerX + halfStartSpan, centerY);
        finger2Path.lineTo(centerX + halfEndSpan, centerY);
        GestureDescription.StrokeDescription stroke1 = new GestureDescription.StrokeDescription(finger1Path, 0L, Math.max(duration, 50L));
        GestureDescription.StrokeDescription stroke2 = new GestureDescription.StrokeDescription(finger2Path, 0L, Math.max(duration, 50L));
        GestureDescription.Builder builder = new GestureDescription.Builder();
        builder.addStroke(stroke1);
        builder.addStroke(stroke2);
        boolean dispatched = dispatchGesture(builder.build(), this.gestureCallback, null);
        Log.d(TAG, "Pinch dispatched at (" + centerX + "," + centerY + "): " + dispatched);
    }

    public void performGesture(GestureDescription gesture) {
        boolean dispatched = dispatchGesture(gesture, this.gestureCallback, null);
        Log.d(TAG, "Custom gesture dispatched: " + dispatched);
    }
}
