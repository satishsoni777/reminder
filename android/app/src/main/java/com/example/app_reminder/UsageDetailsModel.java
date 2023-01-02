package com.example.app_reminder;


import android.app.usage.UsageStats;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;

import androidx.annotation.RequiresApi;

public class UsageDetailsModel {
    @RequiresApi(api = Build.VERSION_CODES.Q)
    UsageDetailsModel(UsageStats usageStats, Context context) throws PackageManager.NameNotFoundException {
        this.packageName = usageStats.getPackageName();
        this.getFirstTimeStamp = usageStats.getFirstTimeStamp();
        this.getLastTimeStamp = usageStats.getLastTimeUsed();
        this.getTotalTimeInForeground = usageStats.getTotalTimeInForeground();
        this.getTotalTimeVisible = usageStats.getTotalTimeVisible();
        this.getLastTimeForegroundServiceUsed = usageStats.getLastTimeForegroundServiceUsed();
        PackageManager packageManager = context.getPackageManager();
        ApplicationInfo ai = packageManager.getApplicationInfo(packageName, 0);
        this.name = (String) packageManager.getApplicationLabel(ai);
    }

    final long getFirstTimeStamp;
    final long getLastTimeStamp;
    final String packageName;
    final long getTotalTimeInForeground;
    final long getTotalTimeVisible;
    final long getLastTimeForegroundServiceUsed;
    final String name;
}
//    public String getPackageName() {
//        throw new RuntimeException("Stub!");
//    }
//
//    public long getFirstTimeStamp() {
//        throw new RuntimeException("Stub!");
//    }
//
//    public long getLastTimeStamp() {
//        throw new RuntimeException("Stub!");
//    }
//
//    public long getLastTimeUsed() {
//        throw new RuntimeException("Stub!");
//    }
//
//    public long getLastTimeVisible() {
//        throw new RuntimeException("Stub!");
//    }
//
//    public long getTotalTimeInForeground() {
//        throw new RuntimeException("Stub!");
//    }
//
//    public long getTotalTimeVisible() {
//        throw new RuntimeException("Stub!");
//    }
//
//    public long getLastTimeForegroundServiceUsed() {
//        throw new RuntimeException("Stub!");
//    }
//
//    public long getTotalTimeForegroundServiceUsed() {
//        throw new RuntimeException("Stub!");
