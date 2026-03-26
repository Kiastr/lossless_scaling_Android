    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.fragment.app.FragmentActivity, androidx.activity.ComponentActivity, android.app.Activity
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1002) {
            if (Settings.canDrawOverlays(this)) {
                startUpscaling();
                return;
            } else {
                Toast.makeText(this, "需要悬浮窗权限才能运行", 0).show();
                return;
            }
        }
        if (requestCode == 1001) {
            if (resultCode == -1 && data != null) {
                Intent serviceIntent = new Intent(this, (Class<?>) OverlayService.class);
                serviceIntent.setAction("START");
                serviceIntent.putExtra("resultCode", resultCode);
                serviceIntent.putExtra("data", data);
                serviceIntent.putExtra("scale", this.scaleSeekBar.getProgress());
                serviceIntent.putExtra("strength", this.strengthSeekBar.getProgress());
                serviceIntent.putExtra("interval", this.intervalSeekBar.getProgress());
                serviceIntent.putExtra("useAccessibility", false);
                startForegroundService(serviceIntent);
                this.isRunning = true;
                updateUI();
                moveTaskToBack(true);
                return;
            }
            Toast.makeText(this, "需要屏幕录制权限", 0).show();
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void updateUI() {
        if (this.isRunning) {
            this.toggleButton.setText("停止超分");
            this.toggleButton.setBackgroundTintList(ColorStateList.valueOf(-3185031));
            this.statusText.setText("运行中");
            this.statusText.setTextColor(-16524603);
            return;
        }
        this.toggleButton.setText("启动超分");
        this.toggleButton.setBackgroundTintList(ColorStateList.valueOf(-10354450));
        this.statusText.setText("已停止");
        this.statusText.setTextColor(-1);
        this.fpsText.setText("FPS: --");
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // androidx.appcompat.app.AppCompatActivity, androidx.fragment.app.FragmentActivity, android.app.Activity
    public void onDestroy() {
        super.onDestroy();
        try {
            unregisterReceiver(this.fpsReceiver);
        } catch (Exception e) {
        }
    }

    /* loaded from: classes3.dex */
    static abstract class SimpleSeekBarListener implements SeekBar.OnSeekBarChangeListener {
        SimpleSeekBarListener() {
        }

        @Override // android.widget.SeekBar.OnSeekBarChangeListener
        public void onStartTrackingTouch(SeekBar seekBar) {
        }

        @Override // android.widget.SeekBar.OnSeekBarChangeListener
        public void onStopTrackingTouch(SeekBar seekBar) {
        }
    }
}
