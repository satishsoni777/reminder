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
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.AppOpsManager;
//import android.app.usage.AppUsageStatistics;
//import android.app.usage.AppUsageStatisticsManager;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.os.Build;
import android.os.Process;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.google.gson.Gson;

import org.json.JSONObject;

import io.flutter.plugin.common.MethodChannel;

public class AppUsageHours {
    private static final int REQUEST_PACKAGE_USAGE_STATS = 1;
    List<UsageStats> stats;

    public List<ActivityManager.RunningTaskInfo> getRunningTasks(Context context, MainActivity mainActivity) {
        Intent[] intents = {
                new Intent(context, mainActivity.getActivity().getClass()),
        };
        intents[0].setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivities(intents);
        ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        return activityManager.getRunningTasks(Integer.MAX_VALUE);
    }

    @RequiresApi(api = Build.VERSION_CODES.Q)
    public long getUsageHours(Context context, String packageName, MainActivity mainActivity, MethodChannel.Result result) {
        // Check if the usage stats permission is granted
        final boolean l = hasUsageStatsPermission(context, packageName);
        Log.e("#########", String.valueOf(l));
        if (!UsagePermissionUtils.hasUsagePermission(context)) {
            UsagePermissionUtils.requestUsagePermission(context);
        }

        // Get the usage stats manager
        UsageStatsManager usageStatsManager = (UsageStatsManager) context.getSystemService(Context.USAGE_STATS_SERVICE);

        // Get the current time
        Calendar cal = Calendar.getInstance();
        long endTime = System.currentTimeMillis();
        // Subtract one week from the current time
        cal.add(Calendar.WEEK_OF_YEAR, -100);
        long startTime = cal.getTimeInMillis();
        // Get the usage stats for the app
        stats = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_BEST, startTime, endTime);

        Gson gson = new Gson();
        UsageDetailsModel usageDetailsModel;
        ArrayList<String> locationTags = new ArrayList<String>();
        int i=0;
        for (UsageStats u : stats){
            if(!isSystemApp(context,u.getPackageName())){
                stats.remove(i);
            }
            i++;
        }
        for (UsageStats usageStats : stats) {
            try {
                usageDetailsModel = new UsageDetailsModel(
                        usageStats,context
                );
                locationTags.add(gson.toJson(usageDetailsModel));

            } catch (Exception e) {
                Log.d("Exception AppUsageHours",String.valueOf(e));
            }
        }
        result.success(gson.toJson(locationTags));
        return 0;
    }

    private boolean hasUsageStatsPermission(Context context, String arg) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
            AppOpsManager appOps = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
            int mode = appOps.checkOpNoThrow("android:get_usage_stats",
                    android.os.Process.myUid(), context.getPackageName());
            return mode == AppOpsManager.MODE_ALLOWED;
        }
        return false;
    }
    private  boolean isSystemApp(Context context, String packageName){
        boolean isSystemApp=false;
        PackageManager packageManager = context.getPackageManager();
        try {
            ApplicationInfo appInfo = packageManager.getApplicationInfo(packageName, 0);
             isSystemApp = (appInfo.flags & ApplicationInfo.FLAG_SYSTEM) != 0;
            if (isSystemApp) {
                // The app is a system app
            } else {
                // The app is not a system app
            }
        } catch (PackageManager.NameNotFoundException e) {
            // Handle the exception
        }
        return  isSystemApp;
    }
    public   void getIconColor(MethodChannel.Result result, Context context, String id) throws PackageManager.NameNotFoundException {
        PackageManager packageManager =context.getPackageManager();
       final int as= context.getResources().getIdentifier("ic_launcher","drawable",id);
        String iconColorHex="";
        try {
            Bitmap icon = BitmapFactory.decodeResource(packageManager.getResourcesForApplication(id), packageManager.getApplicationInfo(id, 0).icon);
            int pixel = icon.getPixel(icon.getWidth() / 2, icon.getHeight() / 2);
            int red = (pixel >> 16) & 0xff;
            int green = (pixel >> 8) & 0xff;
            int blue = pixel & 0xff;
            int iconColor = (0xff << 24) | (red << 16) | (green << 8) | blue;
            Log.d("", "Icon color: " + Integer.toHexString(iconColor));
            iconColorHex=Integer.toHexString(iconColor);
        } catch (PackageManager.NameNotFoundException e) {
            result.success(null);
        }
        Map<String,String>map;
        HashMap<String,String> data =new HashMap<String,String>();
        data.put("iconColor",iconColorHex);
        result.success(data);

    }
}