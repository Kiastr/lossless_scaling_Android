.class public Lcom/anime4k/screen/TouchForwardingAccessibilityService;
.super Landroid/accessibilityservice/AccessibilityService;
.source "TouchForwardingAccessibilityService.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "TouchForwardA11y"

.field private static instance:Lcom/anime4k/screen/TouchForwardingAccessibilityService;


# instance fields
.field private gestureCallback:Landroid/accessibilityservice/AccessibilityService$GestureResultCallback;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 21
    invoke-direct {p0}, Landroid/accessibilityservice/AccessibilityService;-><init>()V

    .line 29
    new-instance v0, Lcom/anime4k/screen/TouchForwardingAccessibilityService$1;

    invoke-direct {v0, p0}, Lcom/anime4k/screen/TouchForwardingAccessibilityService$1;-><init>(Lcom/anime4k/screen/TouchForwardingAccessibilityService;)V

    iput-object v0, p0, Lcom/anime4k/screen/TouchForwardingAccessibilityService;->gestureCallback:Landroid/accessibilityservice/AccessibilityService$GestureResultCallback;

    return-void
.end method

.method public static getInstance()Lcom/anime4k/screen/TouchForwardingAccessibilityService;
    .locals 1

    .line 69
    sget-object v0, Lcom/anime4k/screen/TouchForwardingAccessibilityService;->instance:Lcom/anime4k/screen/TouchForwardingAccessibilityService;

    return-object v0
.end method

.method public static isServiceRunning()Z
    .locals 1

    .line 76
    sget-object v0, Lcom/anime4k/screen/TouchForwardingAccessibilityService;->instance:Lcom/anime4k/screen/TouchForwardingAccessibilityService;

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method


# virtual methods
.method public onAccessibilityEvent(Landroid/view/accessibility/AccessibilityEvent;)V
    .locals 0
    .param p1, "event"    # Landroid/view/accessibility/AccessibilityEvent;

    .line 51
    return-void
.end method

.method public onDestroy()V
    .locals 2

    .line 60
    const/4 v0, 0x0

    sput-object v0, Lcom/anime4k/screen/TouchForwardingAccessibilityService;->instance:Lcom/anime4k/screen/TouchForwardingAccessibilityService;

    .line 61
    const-string v0, "TouchForwardA11y"

    const-string v1, "Accessibility service destroyed"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 62
    invoke-super {p0}, Landroid/accessibilityservice/AccessibilityService;->onDestroy()V

    .line 63
    return-void
.end method

.method public onInterrupt()V
    .locals 2

    .line 55
    const-string v0, "TouchForwardA11y"

    const-string v1, "Accessibility service interrupted"

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 56
    return-void
.end method

.method public onServiceConnected()V
    .locals 2

    .line 43
    invoke-super {p0}, Landroid/accessibilityservice/AccessibilityService;->onServiceConnected()V

    .line 44
    sput-object p0, Lcom/anime4k/screen/TouchForwardingAccessibilityService;->instance:Lcom/anime4k/screen/TouchForwardingAccessibilityService;

    .line 45
    const-string v0, "TouchForwardA11y"

    const-string v1, "Accessibility service connected"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 46
    return-void
.end method

.method public performClick(FF)V
    .locals 8
    .param p1, "x"    # F
    .param p2, "y"    # F

    .line 85
    nop

    .line 90
    new-instance v0, Landroid/graphics/Path;

    invoke-direct {v0}, Landroid/graphics/Path;-><init>()V

    .line 91
    .local v0, "clickPath":Landroid/graphics/Path;
    invoke-virtual {v0, p1, p2}, Landroid/graphics/Path;->moveTo(FF)V

    .line 93
    new-instance v7, Landroid/accessibilityservice/GestureDescription$StrokeDescription;

    const-wide/16 v3, 0x0

    const-wide/16 v5, 0x64

    move-object v1, v7

    move-object v2, v0

    invoke-direct/range {v1 .. v6}, Landroid/accessibilityservice/GestureDescription$StrokeDescription;-><init>(Landroid/graphics/Path;JJ)V

    .line 96
    .local v1, "clickStroke":Landroid/accessibilityservice/GestureDescription$StrokeDescription;
    new-instance v2, Landroid/accessibilityservice/GestureDescription$Builder;

    invoke-direct {v2}, Landroid/accessibilityservice/GestureDescription$Builder;-><init>()V

    .line 97
    .local v2, "builder":Landroid/accessibilityservice/GestureDescription$Builder;
    invoke-virtual {v2, v1}, Landroid/accessibilityservice/GestureDescription$Builder;->addStroke(Landroid/accessibilityservice/GestureDescription$StrokeDescription;)Landroid/accessibilityservice/GestureDescription$Builder;

    .line 99
    invoke-virtual {v2}, Landroid/accessibilityservice/GestureDescription$Builder;->build()Landroid/accessibilityservice/GestureDescription;

    move-result-object v3

    iget-object v4, p0, Lcom/anime4k/screen/TouchForwardingAccessibilityService;->gestureCallback:Landroid/accessibilityservice/AccessibilityService$GestureResultCallback;

    const/4 v5, 0x0

    invoke-virtual {p0, v3, v4, v5}, Lcom/anime4k/screen/TouchForwardingAccessibilityService;->dispatchGesture(Landroid/accessibilityservice/GestureDescription;Landroid/accessibilityservice/AccessibilityService$GestureResultCallback;Landroid/os/Handler;)Z

    move-result v3

    .line 100
    .local v3, "dispatched":Z
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Click dispatched at ("

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, ", "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "): "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    const-string v5, "TouchForwardA11y"

    invoke-static {v5, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 101
    return-void
.end method

.method public performGesture(Landroid/accessibilityservice/GestureDescription;)V
    .locals 3
    .param p1, "gesture"    # Landroid/accessibilityservice/GestureDescription;

    .line 194
    nop

    .line 196
    iget-object v0, p0, Lcom/anime4k/screen/TouchForwardingAccessibilityService;->gestureCallback:Landroid/accessibilityservice/AccessibilityService$GestureResultCallback;

    const/4 v1, 0x0

    invoke-virtual {p0, p1, v0, v1}, Lcom/anime4k/screen/TouchForwardingAccessibilityService;->dispatchGesture(Landroid/accessibilityservice/GestureDescription;Landroid/accessibilityservice/AccessibilityService$GestureResultCallback;Landroid/os/Handler;)Z

    move-result v0

    .line 197
    .local v0, "dispatched":Z
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Custom gesture dispatched: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "TouchForwardA11y"

    invoke-static {v2, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 198
    return-void
.end method

.method public performLongPress(FFJ)V
    .locals 8
    .param p1, "x"    # F
    .param p2, "y"    # F
    .param p3, "duration"    # J

    .line 110
    nop

    .line 112
    new-instance v0, Landroid/graphics/Path;

    invoke-direct {v0}, Landroid/graphics/Path;-><init>()V

    .line 113
    .local v0, "longPressPath":Landroid/graphics/Path;
    invoke-virtual {v0, p1, p2}, Landroid/graphics/Path;->moveTo(FF)V

    .line 115
    new-instance v7, Landroid/accessibilityservice/GestureDescription$StrokeDescription;

    const-wide/16 v3, 0x0

    .line 116
    const-wide/16 v1, 0x1f4

    invoke-static {p3, p4, v1, v2}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v5

    move-object v1, v7

    move-object v2, v0

    invoke-direct/range {v1 .. v6}, Landroid/accessibilityservice/GestureDescription$StrokeDescription;-><init>(Landroid/graphics/Path;JJ)V

    .line 118
    .local v1, "longPressStroke":Landroid/accessibilityservice/GestureDescription$StrokeDescription;
    new-instance v2, Landroid/accessibilityservice/GestureDescription$Builder;

    invoke-direct {v2}, Landroid/accessibilityservice/GestureDescription$Builder;-><init>()V

    .line 119
    .local v2, "builder":Landroid/accessibilityservice/GestureDescription$Builder;
    invoke-virtual {v2, v1}, Landroid/accessibilityservice/GestureDescription$Builder;->addStroke(Landroid/accessibilityservice/GestureDescription$StrokeDescription;)Landroid/accessibilityservice/GestureDescription$Builder;

    .line 121
    invoke-virtual {v2}, Landroid/accessibilityservice/GestureDescription$Builder;->build()Landroid/accessibilityservice/GestureDescription;

    move-result-object v3

    iget-object v4, p0, Lcom/anime4k/screen/TouchForwardingAccessibilityService;->gestureCallback:Landroid/accessibilityservice/AccessibilityService$GestureResultCallback;

    const/4 v5, 0x0

    invoke-virtual {p0, v3, v4, v5}, Lcom/anime4k/screen/TouchForwardingAccessibilityService;->dispatchGesture(Landroid/accessibilityservice/GestureDescription;Landroid/accessibilityservice/AccessibilityService$GestureResultCallback;Landroid/os/Handler;)Z

    move-result v3

    .line 122
    .local v3, "dispatched":Z
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Long press dispatched at ("

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, ", "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "), duration="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p3, p4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, ": "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    const-string v5, "TouchForwardA11y"

    invoke-static {v5, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 123
    return-void
.end method

.method public performPinch(FFFFJ)V
    .locals 20
    .param p1, "centerX"    # F
    .param p2, "centerY"    # F
    .param p3, "startSpan"    # F
    .param p4, "endSpan"    # F
    .param p5, "duration"    # J

    .line 161
    move-object/from16 v0, p0

    move/from16 v1, p1

    move/from16 v2, p2

    move-wide/from16 v3, p5

    .line 163
    const/high16 v5, 0x40000000    # 2.0f

    div-float v6, p3, v5

    .line 164
    .local v6, "halfStartSpan":F
    div-float v5, p4, v5

    .line 167
    .local v5, "halfEndSpan":F
    new-instance v7, Landroid/graphics/Path;

    invoke-direct {v7}, Landroid/graphics/Path;-><init>()V

    .line 168
    .local v7, "finger1Path":Landroid/graphics/Path;
    sub-float v8, v1, v6

    invoke-virtual {v7, v8, v2}, Landroid/graphics/Path;->moveTo(FF)V

    .line 169
    sub-float v8, v1, v5

    invoke-virtual {v7, v8, v2}, Landroid/graphics/Path;->lineTo(FF)V

    .line 172
    new-instance v8, Landroid/graphics/Path;

    invoke-direct {v8}, Landroid/graphics/Path;-><init>()V

    move-object v15, v8

    .line 173
    .local v15, "finger2Path":Landroid/graphics/Path;
    add-float v8, v1, v6

    invoke-virtual {v15, v8, v2}, Landroid/graphics/Path;->moveTo(FF)V

    .line 174
    add-float v8, v1, v5

    invoke-virtual {v15, v8, v2}, Landroid/graphics/Path;->lineTo(FF)V

    .line 176
    new-instance v14, Landroid/accessibilityservice/GestureDescription$StrokeDescription;

    const-wide/16 v10, 0x0

    .line 177
    const-wide/16 v12, 0x32

    invoke-static {v3, v4, v12, v13}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v16

    move-object v8, v14

    move-object v9, v7

    move/from16 v19, v5

    move/from16 v18, v6

    move-wide v5, v12

    .end local v5    # "halfEndSpan":F
    .end local v6    # "halfStartSpan":F
    .local v18, "halfStartSpan":F
    .local v19, "halfEndSpan":F
    move-wide/from16 v12, v16

    invoke-direct/range {v8 .. v13}, Landroid/accessibilityservice/GestureDescription$StrokeDescription;-><init>(Landroid/graphics/Path;JJ)V

    .line 178
    .local v8, "stroke1":Landroid/accessibilityservice/GestureDescription$StrokeDescription;
    new-instance v16, Landroid/accessibilityservice/GestureDescription$StrokeDescription;

    const-wide/16 v11, 0x0

    .line 179
    invoke-static {v3, v4, v5, v6}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v13

    move-object/from16 v9, v16

    move-object v10, v15

    invoke-direct/range {v9 .. v14}, Landroid/accessibilityservice/GestureDescription$StrokeDescription;-><init>(Landroid/graphics/Path;JJ)V

    move-object/from16 v5, v16

    .line 181
    .local v5, "stroke2":Landroid/accessibilityservice/GestureDescription$StrokeDescription;