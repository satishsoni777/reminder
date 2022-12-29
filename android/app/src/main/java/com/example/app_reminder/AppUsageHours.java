package com.example.app_reminder;
import android.Manifest;
import android.accessibilityservice.AccessibilityService;
import android.annotation.SuppressLint;
import android.app.ActivityManager;
import android.app.AppOpsManager;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import java.util.Calendar;
import java.util.List;
import android.app.AppOpsManager;
//import android.app.usage.AppUsageStatistics;
//import android.app.usage.AppUsageStatisticsManager;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.os.Build;
import android.os.Process;
import android.provider.Settings;
import android.util.Log;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

public class AppUsageHours {
    private static final int REQUEST_PACKAGE_USAGE_STATS = 1;
    public static List<ActivityManager.RunningTaskInfo> getRunningTasks(Context context) {
        ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        return activityManager.getRunningTasks(Integer.MAX_VALUE);
    }
    public static long getUsageHours(Context context, String packageName, MainActivity mainActivity) {
        // Check if the usage stats permission is granted
        final boolean l=hasUsageStatsPermission(context, packageName);
        Log.e("#########","");
//        if (!hasUsageStatsPermission(context,packageName)) {
//            return 0;
//        }

        // Get the usage stats manager
        UsageStatsManager usageStatsManager = (UsageStatsManager) context.getSystemService(Context.USAGE_STATS_SERVICE);

        // Get the current time
        Calendar cal = Calendar.getInstance();
        long endTime = System.currentTimeMillis();
        // Subtract one week from the current time
        cal.add(Calendar.WEEK_OF_YEAR, -100);
        long startTime = cal.getTimeInMillis();

        // Get the usage stats for the app
        final List<UsageStats> stats = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_BEST, startTime, endTime);
        Log.d("### Usage Details ###",stats.toString());
        // Find the app in the usage stats
        if ( stats.isEmpty()) {
            Intent intent = new Intent(context, mainActivity.getClass());
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
           context.getApplicationContext().startActivities(new Intent[]{new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)});
        }
        for (UsageStats usageStats : stats) {
            if (usageStats.getPackageName().equals(packageName)) {
                // Return the usage time in hours
                return usageStats.getTotalTimeInForeground() / (1000 * 60 * 60);
            }
        }

        // App was not found in the usage stats
        return 0;
    }

    private static  boolean hasUsageStatsPermission(Context context, String arg) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
            AppOpsManager appOps = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
            int mode = appOps.checkOpNoThrow("android:get_usage_stats",
                    android.os.Process.myUid(), context.getPackageName());
            return mode == AppOpsManager.MODE_ALLOWED;
        }
        return false;
    }



}