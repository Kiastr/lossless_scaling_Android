.class public Lcom/anime4k/screen/MainActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "MainActivity.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/anime4k/screen/MainActivity$SimpleSeekBarListener;
    }
.end annotation


# static fields
.field private static final REQUEST_MEDIA_PROJECTION:I = 0x3e9

.field private static final REQUEST_OVERLAY_PERMISSION:I = 0x3ea


# instance fields
.field private accessibilityButton:Lcom/google/android/material/button/MaterialButton;

.field private accessibilityStatusText:Landroid/widget/TextView;

.field private accessibilitySwitch:Landroid/widget/Switch;

.field private fpsReceiver:Landroid/content/BroadcastReceiver;

.field private fpsText:Landroid/widget/TextView;

.field private intervalSeekBar:Landroid/widget/SeekBar;

.field private intervalValue:Landroid/widget/TextView;

.field private isRunning:Z

.field private prefs:Landroid/content/SharedPreferences;

.field private scaleSeekBar:Landroid/widget/SeekBar;

.field private scaleValue:Landroid/widget/TextView;

.field private statusText:Landroid/widget/TextView;

.field private strengthSeekBar:Landroid/widget/SeekBar;

.field private strengthValue:Landroid/widget/TextView;

.field private toggleButton:Lcom/google/android/material/button/MaterialButton;


# direct methods
.method static bridge synthetic -$$Nest$fgetfpsText(Lcom/anime4k/screen/MainActivity;)Landroid/widget/TextView;
    .locals 0

    iget-object p0, p0, Lcom/anime4k/screen/MainActivity;->fpsText:Landroid/widget/TextView;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetprefs(Lcom/anime4k/screen/MainActivity;)Landroid/content/SharedPreferences;
    .locals 0

    iget-object p0, p0, Lcom/anime4k/screen/MainActivity;->prefs:Landroid/content/SharedPreferences;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputisRunning(Lcom/anime4k/screen/MainActivity;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/anime4k/screen/MainActivity;->isRunning:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateIntervalLabel(Lcom/anime4k/screen/MainActivity;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/anime4k/screen/MainActivity;->updateIntervalLabel(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateScaleLabel(Lcom/anime4k/screen/MainActivity;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/anime4k/screen/MainActivity;->updateScaleLabel(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateStrengthLabel(Lcom/anime4k/screen/MainActivity;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/anime4k/screen/MainActivity;->updateStrengthLabel(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateUI(Lcom/anime4k/screen/MainActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/anime4k/screen/MainActivity;->updateUI()V

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 37
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    .line 48
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/anime4k/screen/MainActivity;->isRunning:Z

    .line 52
    new-instance v0, Lcom/anime4k/screen/MainActivity$1;

    invoke-direct {v0, p0}, Lcom/anime4k/screen/MainActivity$1;-><init>(Lcom/anime4k/screen/MainActivity;)V

    iput-object v0, p0, Lcom/anime4k/screen/MainActivity;->fpsReceiver:Landroid/content/BroadcastReceiver;

    return-void
.end method

.method private isAccessibilityServiceEnabled()Z
    .locals 6

    .line 171
    nop

    .line 172
    const-string v0, "accessibility"

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/accessibility/AccessibilityManager;

    .line 173
    .local v0, "am":Landroid/view/accessibility/AccessibilityManager;
    nop

    .line 174
    const/4 v1, -0x1

    invoke-virtual {v0, v1}, Landroid/view/accessibility/AccessibilityManager;->getEnabledAccessibilityServiceList(I)Ljava/util/List;

    move-result-object v1

    .line 176
    .local v1, "enabledServices":Ljava/util/List;, "Ljava/util/List<Landroid/accessibilityservice/AccessibilityServiceInfo;>;"
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lcom/anime4k/screen/MainActivity;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-class v3, Lcom/anime4k/screen/TouchForwardingAccessibilityService;

    .line 177
    invoke-virtual {v3}, Ljava/lang/Class;->getCanonicalName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 179
    .local v2, "expectedId":Ljava/lang/String;
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_1

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/accessibilityservice/AccessibilityServiceInfo;

    .line 180
    .local v4, "info":Landroid/accessibilityservice/AccessibilityServiceInfo;
    invoke-virtual {v4}, Landroid/accessibilityservice/AccessibilityServiceInfo;->getId()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v5, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_0

    .line 181
    const/4 v3, 0x1

    return v3

    .line 183
    .end local v4    # "info":Landroid/accessibilityservice/AccessibilityServiceInfo;
    :cond_0
    goto :goto_0

    .line 186
    :cond_1
    invoke-static {}, Lcom/anime4k/screen/TouchForwardingAccessibilityService;->isServiceRunning()Z

    move-result v3

    return v3
.end method

.method private openAccessibilitySettings()V
    .locals 3

    .line 235
    :try_start_0
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.settings.ACCESSIBILITY_SETTINGS"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 236
    .local v0, "intent":Landroid/content/Intent;
    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 239
    .end local v0    # "intent":Landroid/content/Intent;
    goto :goto_0

    .line 237
    :catch_0
    move-exception v0

    .line 238
    .local v0, "e":Ljava/lang/Exception;
    const-string v1, "\u65e0\u6cd5\u6253\u5f00\u65e0\u969c\u788d\u8bbe\u7f6e"

    const/4 v2, 0x0

    invoke-static {p0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v1

    invoke-virtual {v1}, Landroid/widget/Toast;->show()V

    .line 240
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_0
    return-void
.end method

.method private showAccessibilityGuideDialog()V
    .locals 3

    .line 215
    new-instance v0, Landroidx/appcompat/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroidx/appcompat/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 216
    const-string v1, "\u5f00\u542f\u65e0\u969c\u788d\u670d\u52a1"

    invoke-virtual {v0, v1}, Landroidx/appcompat/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v0

    .line 217
    const-string v1, "\u4e3a\u4e86\u5728 Android 12+ \u4e0a\u6b63\u5e38\u64cd\u63a7\u5e95\u5c42\u5e94\u7528\uff0c\u9700\u8981\u5f00\u542f\u672c\u5e94\u7528\u7684\u65e0\u969c\u788d\u670d\u52a1\u3002\n\n\u6b65\u9aa4\uff1a\n1. \u70b9\u51fb\u300c\u524d\u5f80\u8bbe\u7f6e\u300d\n2. \u627e\u5230\u300cAnime4K Screen \u89e6\u63a7\u8f6c\u53d1\u300d\n3. \u5f00\u542f\u670d\u52a1\u5e76\u786e\u8ba4\n\n\u6b64\u670d\u52a1\u4ec5\u7528\u4e8e\u8f6c\u53d1\u89e6\u6478\u4e8b\u4ef6\uff0c\u4e0d\u4f1a\u6536\u96c6\u4efb\u4f55\u6570\u636e\u3002"

    invoke-virtual {v0, v1}, Landroidx/appcompat/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lcom/anime4k/screen/MainActivity$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lcom/anime4k/screen/MainActivity$$ExternalSyntheticLambda0;-><init>(Lcom/anime4k/screen/MainActivity;)V

    .line 223
    const-string v2, "\u524d\u5f80\u8bbe\u7f6e"

    invoke-virtual {v0, v2, v1}, Landroidx/appcompat/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v0

    .line 226
    const-string v1, "\u7a0d\u540e"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroidx/appcompat/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroidx/appcompat/app/AlertDialog$Builder;

    move-result-object v0

    .line 227
    invoke-virtual {v0}, Landroidx/appcompat/app/AlertDialog$Builder;->show()Landroidx/appcompat/app/AlertDialog;

    .line 228
    return-void
.end method

.method private startUpscaling()V
    .locals 4

    .line 244
    invoke-static {p0}, Landroid/provider/Settings;->canDrawOverlays(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 245
    new-instance v0, Landroid/content/Intent;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "package:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 246
    invoke-virtual {p0}, Lcom/anime4k/screen/MainActivity;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    const-string v2, "android.settings.action.MANAGE_OVERLAY_PERMISSION"

    invoke-direct {v0, v2, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    .line 247
    .local v0, "intent":Landroid/content/Intent;
    const/16 v1, 0x3ea

    invoke-virtual {p0, v0, v1}, Lcom/anime4k/screen/MainActivity;->startActivityForResult(Landroid/content/Intent;I)V

    .line 248
    const-string v1, "\u8bf7\u6388\u4e88\u60ac\u6d6e\u7a97\u6743\u9650"

    const/4 v2, 0x1

    invoke-static {p0, v1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v1

    invoke-virtual {v1}, Landroid/widget/Toast;->show()V

    .line 249
    return-void

    .line 253
    .end local v0    # "intent":Landroid/content/Intent;
    :cond_0
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->accessibilitySwitch:Landroid/widget/Switch;

    invoke-virtual {v0}, Landroid/widget/Switch;->isChecked()Z

    move-result v0

    .line 254
    .local v0, "useAccessibility":Z
    if-eqz v0, :cond_1

    invoke-direct {p0}, Lcom/anime4k/screen/MainActivity;->isAccessibilityServiceEnabled()Z

    move-result v1

    if-nez v1, :cond_1

    .line 255
    invoke-direct {p0}, Lcom/anime4k/screen/MainActivity;->showAccessibilityGuideDialog()V

    .line 256
    return-void

    .line 260
    :cond_1
    nop

    .line 261
    const-string v1, "media_projection"

    invoke-virtual {p0, v1}, Lcom/anime4k/screen/MainActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/media/projection/MediaProjectionManager;

    .line 262
    .local v1, "projectionManager":Landroid/media/projection/MediaProjectionManager;
    invoke-virtual {v1}, Landroid/media/projection/MediaProjectionManager;->createScreenCaptureIntent()Landroid/content/Intent;

    move-result-object v2

    const/16 v3, 0x3e9

    invoke-virtual {p0, v2, v3}, Lcom/anime4k/screen/MainActivity;->startActivityForResult(Landroid/content/Intent;I)V

    .line 264
    return-void
.end method

.method private stopUpscaling()V
    .locals 2

    .line 267
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/anime4k/screen/OverlayService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 268
    .local v0, "intent":Landroid/content/Intent;
    const-string v1, "STOP"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 269
    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 270
    const/4 v1, 0x0

    iput-boolean v1, p0, Lcom/anime4k/screen/MainActivity;->isRunning:Z

    .line 271
    invoke-direct {p0}, Lcom/anime4k/screen/MainActivity;->updateUI()V

    .line 272
    return-void
.end method

.method private updateAccessibilityStatus()V
    .locals 5

    .line 193
    invoke-direct {p0}, Lcom/anime4k/screen/MainActivity;->isAccessibilityServiceEnabled()Z

    move-result v0

    .line 194
    .local v0, "enabled":Z
    iget-object v1, p0, Lcom/anime4k/screen/MainActivity;->accessibilitySwitch:Landroid/widget/Switch;

    invoke-virtual {v1}, Landroid/widget/Switch;->isChecked()Z

    move-result v1

    .line 196
    .local v1, "switchOn":Z
    const-string v2, "\u65e0\u969c\u788d\u8bbe\u7f6e"

    if-eqz v1, :cond_0

    if-eqz v0, :cond_0

    .line 197
    iget-object v3, p0, Lcom/anime4k/screen/MainActivity;->accessibilityStatusText:Landroid/widget/TextView;

    const-string v4, "\u65e0\u969c\u788d\u89e6\u63a7\uff1a\u5df2\u542f\u7528\uff08\u63a8\u8350\uff09"

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 198
    iget-object v3, p0, Lcom/anime4k/screen/MainActivity;->accessibilityStatusText:Landroid/widget/TextView;

    const v4, -0xb350b0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    .line 199
    iget-object v3, p0, Lcom/anime4k/screen/MainActivity;->accessibilityButton:Lcom/google/android/material/button/MaterialButton;

    invoke-virtual {v3, v2}, Lcom/google/android/material/button/MaterialButton;->setText(Ljava/lang/CharSequence;)V

    goto :goto_0

    .line 200
    :cond_0
    if-eqz v1, :cond_1

    if-nez v0, :cond_1

    .line 201
    iget-object v2, p0, Lcom/anime4k/screen/MainActivity;->accessibilityStatusText:Landroid/widget/TextView;

    const-string v3, "\u65e0\u969c\u788d\u89e6\u63a7\uff1a\u672a\u6388\u6743\uff08\u8bf7\u70b9\u51fb\u4e0b\u65b9\u6309\u94ae\u5f00\u542f\uff09"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 202
    iget-object v2, p0, Lcom/anime4k/screen/MainActivity;->accessibilityStatusText:Landroid/widget/TextView;

    const/16 v3, -0x6800

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    .line 203
    iget-object v2, p0, Lcom/anime4k/screen/MainActivity;->accessibilityButton:Lcom/google/android/material/button/MaterialButton;

    const-string v3, "\u524d\u5f80\u5f00\u542f\u65e0\u969c\u788d\u670d\u52a1"

    invoke-virtual {v2, v3}, Lcom/google/android/material/button/MaterialButton;->setText(Ljava/lang/CharSequence;)V

    goto :goto_0

    .line 205
    :cond_1
    iget-object v3, p0, Lcom/anime4k/screen/MainActivity;->accessibilityStatusText:Landroid/widget/TextView;

    const-string v4, "\u89e6\u63a7\u6a21\u5f0f\uff1a\u4f20\u7edf\u7a7f\u900f\uff08Android 12+ \u53ef\u80fd\u4e0d\u53ef\u7528\uff09"

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 206
    iget-object v3, p0, Lcom/anime4k/screen/MainActivity;->accessibilityStatusText:Landroid/widget/TextView;

    const v4, -0x77000001

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    .line 207
    iget-object v3, p0, Lcom/anime4k/screen/MainActivity;->accessibilityButton:Lcom/google/android/material/button/MaterialButton;

    invoke-virtual {v3, v2}, Lcom/google/android/material/button/MaterialButton;->setText(Ljava/lang/CharSequence;)V

    .line 209
    :goto_0
    return-void
.end method

.method private updateIntervalLabel(I)V
    .locals 3
    .param p1, "progress"    # I

    .line 164
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->intervalValue:Landroid/widget/TextView;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "ms"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 165
    return-void
.end method

.method private updateScaleLabel(I)V
    .locals 3
    .param p1, "progress"    # I

    .line 156
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->scaleValue:Landroid/widget/TextView;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "%"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 157
    return-void
.end method

.method private updateStrengthLabel(I)V
    .locals 4
    .param p1, "progress"    # I

    .line 160
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->strengthValue:Landroid/widget/TextView;

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    int-to-float v2, p1

    const/high16 v3, 0x42c80000    # 100.0f

    div-float/2addr v2, v3

    invoke-static {v2}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v2

    const/4 v3, 0x0

    aput-object v2, v1, v3

    const-string v2, "%.2f"

    invoke-static {v2, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 161
    return-void
.end method

.method private updateUI()V
    .locals 2

    .line 313
    iget-boolean v0, p0, Lcom/anime4k/screen/MainActivity;->isRunning:Z

    if-eqz v0, :cond_0

    .line 314
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->toggleButton:Lcom/google/android/material/button/MaterialButton;

    const-string v1, "\u505c\u6b62\u8d85\u5206"

    invoke-virtual {v0, v1}, Lcom/google/android/material/button/MaterialButton;->setText(Ljava/lang/CharSequence;)V

    .line 315
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->toggleButton:Lcom/google/android/material/button/MaterialButton;

    .line 316
    const v1, -0x309987

    invoke-static {v1}, Landroid/content/res/ColorStateList;->valueOf(I)Landroid/content/res/ColorStateList;

    move-result-object v1

    .line 315
    invoke-virtual {v0, v1}, Lcom/google/android/material/button/MaterialButton;->setBackgroundTintList(Landroid/content/res/ColorStateList;)V

    .line 317
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->statusText:Landroid/widget/TextView;

    const-string v1, "\u8fd0\u884c\u4e2d"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 318
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->statusText:Landroid/widget/TextView;

    const v1, -0xfc253b

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    goto :goto_0

    .line 320
    :cond_0
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->toggleButton:Lcom/google/android/material/button/MaterialButton;

    const-string v1, "\u542f\u52a8\u8d85\u5206"

    invoke-virtual {v0, v1}, Lcom/google/android/material/button/MaterialButton;->setText(Ljava/lang/CharSequence;)V

    .line 321
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->toggleButton:Lcom/google/android/material/button/MaterialButton;

    .line 322
    const v1, -0x9dff12

    invoke-static {v1}, Landroid/content/res/ColorStateList;->valueOf(I)Landroid/content/res/ColorStateList;

    move-result-object v1

    .line 321
    invoke-virtual {v0, v1}, Lcom/google/android/material/button/MaterialButton;->setBackgroundTintList(Landroid/content/res/ColorStateList;)V

    .line 323
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->statusText:Landroid/widget/TextView;

    const-string v1, "\u5df2\u505c\u6b62"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 324
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->statusText:Landroid/widget/TextView;

    const/4 v1, -0x1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    .line 325
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->fpsText:Landroid/widget/TextView;

    const-string v1, "FPS: --"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 327
    :goto_0
    return-void
.end method


# virtual methods
.method synthetic lambda$onCreate$0$com-anime4k-screen-MainActivity(Landroid/view/View;)V
    .locals 1
    .param p1, "v"    # Landroid/view/View;

    .line 122
    iget-boolean v0, p0, Lcom/anime4k/screen/MainActivity;->isRunning:Z

    if-eqz v0, :cond_0

    .line 123
    invoke-direct {p0}, Lcom/anime4k/screen/MainActivity;->stopUpscaling()V

    goto :goto_0

    .line 125
    :cond_0
    invoke-direct {p0}, Lcom/anime4k/screen/MainActivity;->startUpscaling()V

    .line 127
    :goto_0
    return-void
.end method

.method synthetic lambda$onCreate$1$com-anime4k-screen-MainActivity(Landroid/view/View;)V
    .locals 0
    .param p1, "v"    # Landroid/view/View;

    .line 135
    invoke-direct {p0}, Lcom/anime4k/screen/MainActivity;->openAccessibilitySettings()V

    .line 136
    return-void
.end method

.method synthetic lambda$showAccessibilityGuideDialog$2$com-anime4k-screen-MainActivity(Landroid/content/DialogInterface;I)V
    .locals 0
    .param p1, "dialog"    # Landroid/content/DialogInterface;
    .param p2, "which"    # I

    .line 224
    invoke-direct {p0}, Lcom/anime4k/screen/MainActivity;->openAccessibilitySettings()V

    .line 225
    return-void
.end method

.method protected onActivityResult(IILandroid/content/Intent;)V
    .locals 4
    .param p1, "requestCode"    # I
    .param p2, "resultCode"    # I
    .param p3, "data"    # Landroid/content/Intent;

    .line 276
    invoke-super {p0, p1, p2, p3}, Landroidx/appcompat/app/AppCompatActivity;->onActivityResult(IILandroid/content/Intent;)V

    .line 278
    const/16 v0, 0x3ea

    const/4 v1, 0x0

    if-ne p1, v0, :cond_1

    .line 279
    invoke-static {p0}, Landroid/provider/Settings;->canDrawOverlays(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 280
    invoke-direct {p0}, Lcom/anime4k/screen/MainActivity;->startUpscaling()V

    goto :goto_0

    .line 282
    :cond_0
    const-string v0, "\u9700\u8981\u60ac\u6d6e\u7a97\u6743\u9650\u624d\u80fd\u8fd0\u884c"

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    goto :goto_0

    .line 284
    :cond_1
    const/16 v0, 0x3e9

    if-ne p1, v0, :cond_3

    .line 285
    const/4 v0, -0x1

    if-ne p2, v0, :cond_2

    if-eqz p3, :cond_2

    .line 286
    new-instance v0, Landroid/content/Intent;

    const-class v2, Lcom/anime4k/screen/OverlayService;

    invoke-direct {v0, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 287
    .local v0, "serviceIntent":Landroid/content/Intent;
    const-string v2, "START"

    invoke-virtual {v0, v2}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 288
    const-string v2, "resultCode"

    invoke-virtual {v0, v2, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 289
    const-string v2, "data"

    invoke-virtual {v0, v2, p3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    .line 290
    iget-object v2, p0, Lcom/anime4k/screen/MainActivity;->scaleSeekBar:Landroid/widget/SeekBar;

    invoke-virtual {v2}, Landroid/widget/SeekBar;->getProgress()I

    move-result v2

    const-string v3, "scale"

    invoke-virtual {v0, v3, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 291
    iget-object v2, p0, Lcom/anime4k/screen/MainActivity;->strengthSeekBar:Landroid/widget/SeekBar;

    invoke-virtual {v2}, Landroid/widget/SeekBar;->getProgress()I

    move-result v2

    const-string v3, "strength"

    invoke-virtual {v0, v3, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 292
    iget-object v2, p0, Lcom/anime4k/screen/MainActivity;->intervalSeekBar:Landroid/widget/SeekBar;

    invoke-virtual {v2}, Landroid/widget/SeekBar;->getProgress()I

    move-result v2

    const-string v3, "interval"

    invoke-virtual {v0, v3, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 293
    const-string v2, "useAccessibility"

    iget-object v3, p0, Lcom/anime4k/screen/MainActivity;->accessibilitySwitch:Landroid/widget/Switch;

    invoke-virtual {v3}, Landroid/widget/Switch;->isChecked()Z

    move-result v3

    invoke-virtual {v0, v2, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    .line 295
    nop

    .line 296
    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 301
    const/4 v1, 0x1

    iput-boolean v1, p0, Lcom/anime4k/screen/MainActivity;->isRunning:Z

    .line 302
    invoke-direct {p0}, Lcom/anime4k/screen/MainActivity;->updateUI()V

    .line 305
    invoke-virtual {p0, v1}, Lcom/anime4k/screen/MainActivity;->moveTaskToBack(Z)Z

    .line 306
    .end local v0    # "serviceIntent":Landroid/content/Intent;
    goto :goto_0

    .line 307
    :cond_2
    const-string v0, "\u9700\u8981\u5c4f\u5e55\u5f55\u5236\u6743\u9650"

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 310
    :cond_3
    :goto_0
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 4
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .line 67
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 68
    const v0, 0x7f0b001c

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->setContentView(I)V

    .line 70
    const-string v0, "anime4k_prefs"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Lcom/anime4k/screen/MainActivity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    iput-object v0, p0, Lcom/anime4k/screen/MainActivity;->prefs:Landroid/content/SharedPreferences;

    .line 72
    const v0, 0x7f0801d6

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Lcom/google/android/material/button/MaterialButton;

    iput-object v0, p0, Lcom/anime4k/screen/MainActivity;->toggleButton:Lcom/google/android/material/button/MaterialButton;

    .line 73
    const v0, 0x7f08000f

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Lcom/google/android/material/button/MaterialButton;

    iput-object v0, p0, Lcom/anime4k/screen/MainActivity;->accessibilityButton:Lcom/google/android/material/button/MaterialButton;

    .line 74
    const v0, 0x7f0801ab

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/anime4k/screen/MainActivity;->statusText:Landroid/widget/TextView;

    .line 75
    const v0, 0x7f0800c6

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/anime4k/screen/MainActivity;->fpsText:Landroid/widget/TextView;

    .line 76
    const v0, 0x7f080168

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/anime4k/screen/MainActivity;->scaleValue:Landroid/widget/TextView;

    .line 77
    const v0, 0x7f0801ae

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/anime4k/screen/MainActivity;->strengthValue:Landroid/widget/TextView;

    .line 78
    const v0, 0x7f0800e3

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/anime4k/screen/MainActivity;->intervalValue:Landroid/widget/TextView;

    .line 79
    const v0, 0x7f080167

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/SeekBar;

    iput-object v0, p0, Lcom/anime4k/screen/MainActivity;->scaleSeekBar:Landroid/widget/SeekBar;

    .line 80
    const v0, 0x7f0801ad

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/SeekBar;

    iput-object v0, p0, Lcom/anime4k/screen/MainActivity;->strengthSeekBar:Landroid/widget/SeekBar;

    .line 81
    const v0, 0x7f0800e2

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/SeekBar;

    iput-object v0, p0, Lcom/anime4k/screen/MainActivity;->intervalSeekBar:Landroid/widget/SeekBar;

    .line 82
    const v0, 0x7f080011

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Switch;

    iput-object v0, p0, Lcom/anime4k/screen/MainActivity;->accessibilitySwitch:Landroid/widget/Switch;

    .line 83
    const v0, 0x7f080010

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/anime4k/screen/MainActivity;->accessibilityStatusText:Landroid/widget/TextView;

    .line 86
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->scaleSeekBar:Landroid/widget/SeekBar;

    iget-object v1, p0, Lcom/anime4k/screen/MainActivity;->prefs:Landroid/content/SharedPreferences;

    const-string v2, "scale"

    const/16 v3, 0x32

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/SeekBar;->setProgress(I)V

    .line 87
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->strengthSeekBar:Landroid/widget/SeekBar;

    iget-object v1, p0, Lcom/anime4k/screen/MainActivity;->prefs:Landroid/content/SharedPreferences;

    const-string v2, "strength"

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/SeekBar;->setProgress(I)V

    .line 88
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->intervalSeekBar:Landroid/widget/SeekBar;

    iget-object v1, p0, Lcom/anime4k/screen/MainActivity;->prefs:Landroid/content/SharedPreferences;

    const-string v2, "interval"

    const/16 v3, 0x64

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/SeekBar;->setProgress(I)V

    .line 91
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->scaleSeekBar:Landroid/widget/SeekBar;

    invoke-virtual {v0}, Landroid/widget/SeekBar;->getProgress()I

    move-result v0

    invoke-direct {p0, v0}, Lcom/anime4k/screen/MainActivity;->updateScaleLabel(I)V

    .line 92
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->strengthSeekBar:Landroid/widget/SeekBar;

    invoke-virtual {v0}, Landroid/widget/SeekBar;->getProgress()I

    move-result v0

    invoke-direct {p0, v0}, Lcom/anime4k/screen/MainActivity;->updateStrengthLabel(I)V

    .line 93
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->intervalSeekBar:Landroid/widget/SeekBar;

    invoke-virtual {v0}, Landroid/widget/SeekBar;->getProgress()I

    move-result v0

    invoke-direct {p0, v0}, Lcom/anime4k/screen/MainActivity;->updateIntervalLabel(I)V

    .line 95
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->scaleSeekBar:Landroid/widget/SeekBar;

    new-instance v1, Lcom/anime4k/screen/MainActivity$2;

    invoke-direct {v1, p0}, Lcom/anime4k/screen/MainActivity$2;-><init>(Lcom/anime4k/screen/MainActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/SeekBar;->setOnSeekBarChangeListener(Landroid/widget/SeekBar$OnSeekBarChangeListener;)V

    .line 103
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->strengthSeekBar:Landroid/widget/SeekBar;

    new-instance v1, Lcom/anime4k/screen/MainActivity$3;

    invoke-direct {v1, p0}, Lcom/anime4k/screen/MainActivity$3;-><init>(Lcom/anime4k/screen/MainActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/SeekBar;->setOnSeekBarChangeListener(Landroid/widget/SeekBar$OnSeekBarChangeListener;)V

    .line 111
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->intervalSeekBar:Landroid/widget/SeekBar;

    new-instance v1, Lcom/anime4k/screen/MainActivity$4;

    invoke-direct {v1, p0}, Lcom/anime4k/screen/MainActivity$4;-><init>(Lcom/anime4k/screen/MainActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/SeekBar;->setOnSeekBarChangeListener(Landroid/widget/SeekBar$OnSeekBarChangeListener;)V

    .line 121
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->toggleButton:Lcom/google/android/material/button/MaterialButton;

    new-instance v1, Lcom/anime4k/screen/MainActivity$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0}, Lcom/anime4k/screen/MainActivity$$ExternalSyntheticLambda1;-><init>(Lcom/anime4k/screen/MainActivity;)V

    invoke-virtual {v0, v1}, Lcom/google/android/material/button/MaterialButton;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 130
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->accessibilityButton:Lcom/google/android/material/button/MaterialButton;

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Lcom/google/android/material/button/MaterialButton;->setVisibility(I)V

    .line 131
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->accessibilitySwitch:Landroid/widget/Switch;

    invoke-virtual {v0, v1}, Landroid/widget/Switch;->setVisibility(I)V

    .line 132
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->accessibilityStatusText:Landroid/widget/TextView;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 134
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->accessibilityButton:Lcom/google/android/material/button/MaterialButton;

    new-instance v1, Lcom/anime4k/screen/MainActivity$$ExternalSyntheticLambda2;

    invoke-direct {v1, p0}, Lcom/anime4k/screen/MainActivity$$ExternalSyntheticLambda2;-><init>(Lcom/anime4k/screen/MainActivity;)V

    invoke-virtual {v0, v1}, Lcom/google/android/material/button/MaterialButton;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 139
    new-instance v0, Landroid/content/IntentFilter;

    invoke-direct {v0}, Landroid/content/IntentFilter;-><init>()V

    .line 140
    .local v0, "filter":Landroid/content/IntentFilter;
    const-string v1, "com.anime4k.screen.FPS_UPDATE"

    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 141
    const-string v1, "com.anime4k.screen.SERVICE_STOPPED"

    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 142
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x21

    if-lt v1, v2, :cond_0

    .line 143
    iget-object v1, p0, Lcom/anime4k/screen/MainActivity;->fpsReceiver:Landroid/content/BroadcastReceiver;

    const/4 v2, 0x4

    invoke-virtual {p0, v1, v0, v2}, Lcom/anime4k/screen/MainActivity;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;I)Landroid/content/Intent;

    goto :goto_0

    .line 145
    :cond_0
    iget-object v1, p0, Lcom/anime4k/screen/MainActivity;->fpsReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {p0, v1, v0}, Lcom/anime4k/screen/MainActivity;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 147
    :goto_0
    return-void
.end method

.method protected onDestroy()V
    .locals 1

    .line 331
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onDestroy()V

    .line 333
    :try_start_0
    iget-object v0, p0, Lcom/anime4k/screen/MainActivity;->fpsReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {p0, v0}, Lcom/anime4k/screen/MainActivity;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 336
    goto :goto_0

    .line 334
    :catch_0
    move-exception v0

    .line 337
    :goto_0
    return-void
.end method

.method protected onResume()V
    .locals 0

    .line 151
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onResume()V

    .line 152
    invoke-direct {p0}, Lcom/anime4k/screen/MainActivity;->updateAccessibilityStatus()V

    .line 153
    return-void
.end method
