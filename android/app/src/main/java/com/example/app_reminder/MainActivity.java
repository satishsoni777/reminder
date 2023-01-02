package com.example.app_reminder;

import android.annotation.SuppressLint;
import android.app.ActivityManager;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;
import android.view.LayoutInflater;

import java.util.Calendar;

import io.flutter.embedding.android.FlutterActivity;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;

import org.json.JSONArray;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity implements OnItemSelectedListener {
    UsageStatsManager usageStatsManager;
    private  final AppUsageHours  appUsageHours=new AppUsageHours();
    private static final String CHANNEL = "com.native.interface";
    private static final String TAG = "UsageStatsActivity";
    private static final boolean localLOGV = false;
    private UsageStatsManager mUsageStatsManager;
    private LayoutInflater mInflater;
    private UsageStatsAdapter mAdapter;
    private PackageManager mPm;
    private static final int SYSTEM_APP_MASK = ApplicationInfo.FLAG_SYSTEM | ApplicationInfo.FLAG_UPDATED_SYSTEM_APP;


    @RequiresApi(api = Build.VERSION_CODES.Q)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            usageStatsManager = (UsageStatsManager) getApplication().getApplicationContext().getSystemService(Context.USAGE_STATS_SERVICE);
        }
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method) {
                                case "getAppState":
                                    getAppUsage(result);
                                    break;
                                case "getAppUsage":
                                    final Map<String, Object> arguments = call.arguments();
                                    getUsage(getApplicationContext(), arguments.get("packName").toString(),result);
                                    break;
                                case "getRunningApps":
                                    getRunningApps(getApplicationContext());
                                    break;
                                case "getInstalledApps":
//                                    getInstalledApps();
                                    break;

                                case "getIconColor":
                                    final Map<String, Object> arg = call.arguments();
                                    try {
                                        appUsageHours.getIconColor(result, getApplicationContext(),arg.get("id").toString());
                                    } catch (PackageManager.NameNotFoundException e) {
                                        e.printStackTrace();
                                    }
                                    break;

                            }
                        }
                );
    }

    public void getAppUsage(MethodChannel.Result result) {
        final long currentTime = System.currentTimeMillis();
        Calendar endTime = Calendar.getInstance();
        endTime.set(Calendar.DATE, 1);
        endTime.set(Calendar.MONTH, 12);
        endTime.set(Calendar.YEAR, 2019);
        long endTimeTimeInMillis = endTime.getTimeInMillis();
        final List<UsageStats> usageStats = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, 0, System.currentTimeMillis());
        Log.d("Get apps usage Details", String.valueOf(usageStats));


        if (usageStats.isEmpty()) {
            result.success(" usageStats Is empty");
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.Q)
    public void getUsage(Context context, String packageName, MethodChannel.Result result) {
        appUsageHours.getUsageHours(getApplicationContext(), packageName, this,result);
        Log.d("onItemSelected #### ", packageName);
    }

    public void getRunningApps(Context context) {
        List<ActivityManager.RunningTaskInfo> data = appUsageHours.getRunningTasks(context, this);
        Log.d("Get running apps ##", data.toString());
    }

    @SuppressLint("LongLogTag")
    public void getInstalledApps() {
        PackageManager packageManager = getPackageManager();
        List<PackageInfo> packages = packageManager.getInstalledPackages(0);
        int countApp=0;
        for (PackageInfo packageInfo : packages) {
            ApplicationInfo applicationInfo = packageInfo.applicationInfo;
            Drawable appLogo = applicationInfo.loadIcon(packageManager);
            if(isSystemApp(packageInfo)){
                countApp++;
            }
            Log.i("Total System Apps installed",String.valueOf(countApp));
            // Use the appLogo Drawable as needed.
            Log.d("### Logo ###", appLogo.toString());
        }
    }
    private boolean isSystemApp(PackageInfo pInfo) {
        return (pInfo.applicationInfo.flags & SYSTEM_APP_MASK) != 0;
    }


    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
        Log.d("onItemSelected #### ", adapterView.toString());
    }

    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {
        Log.d("onItemSelected #### ", adapterView.toString());
    }
}
