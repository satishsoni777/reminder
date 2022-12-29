package com.example.app_reminder;
import android.app.ActivityManager;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
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

public class MainActivity extends FlutterActivity implements  OnItemSelectedListener {
    UsageStatsManager usageStatsManager;

    private static final String CHANNEL = "com.native.inteface";
    private static final String TAG = "UsageStatsActivity";
    private static final boolean localLOGV = false;
    private UsageStatsManager mUsageStatsManager;
    private LayoutInflater mInflater;
    private UsageStatsAdapter mAdapter;
    private PackageManager mPm;
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            usageStatsManager=(UsageStatsManager)getApplication().getApplicationContext().getSystemService(Context.USAGE_STATS_SERVICE);
        }
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                           switch (call.method){
                               case  "getAppState":
                                   getAppUsage(result);
                                   break;
                               case "getAppUsage":
                                   Map<String, Object> arguments = call.arguments();
                                   getUsage(getApplicationContext(),arguments.get("packName").toString());
                                   break;
                               case "getRunningApps":
                                   getRunningApps(getApplicationContext());
                                   break;

                           }
                        }
                );
    }

    public  void getAppUsage(MethodChannel.Result result){
        final long currentTime = System.currentTimeMillis();
        Calendar endTime = Calendar.getInstance();
        endTime.set(Calendar.DATE, 1);
        endTime.set(Calendar.MONTH, 12);
        endTime.set(Calendar.YEAR, 2019);
        long endTimeTimeInMillis=endTime.getTimeInMillis();
        final List<UsageStats> usageStats= usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, 0, System.currentTimeMillis());
        Log.d("Get apps usage Details", String.valueOf(usageStats));


        if(usageStats.isEmpty()){
            result.success(" usageStats Is empty");
        }
    }
    public  void getUsage(Context context, String packageName){
        AppUsageHours appUsageHours= new AppUsageHours();
        AppUsageHours.getUsageHours(getApplicationContext(),packageName, this);
        Log.d("onItemSelected #### ",packageName);
    }
    public  void getRunningApps(Context context){
        List<ActivityManager.RunningTaskInfo> data= AppUsageHours.getRunningTasks(context);
        Log.d("Get running apps ##",data.toString());
    }

    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
        Log.d("onItemSelected #### ",adapterView.toString());
;    }

    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {
        Log.d("onItemSelected #### ",adapterView.toString());
    }
}
