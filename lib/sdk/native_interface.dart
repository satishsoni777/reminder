import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:device_apps/device_apps.dart';
import 'package:usage_stats/usage_stats.dart';

import 'package:app_reminder/db/shared_pref.dart';
import 'package:app_reminder/home/model/UsageInfoModel.dart';
import 'package:app_reminder/utils/utils.dart';

abstract class NativeInterface {
  Future<dynamic> getAppUsageList(String arg);
  Future<dynamic> getInstalledApps();
  List<UsageInfoModel> get usageInfo;
  int get totalTimeUes;
}

class NativeInterfaceImpl extends NativeInterface with ChangeNotifier {
  final MethodChannel _methodChannel = const MethodChannel("com.native.interface");
  List<UsageInfoModel> _usageInfo = [];
  int _totalTime = 0;
  @override
  Future getAppUsageList(String arg) async {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(hours: 1));
    final hasUsagePermission = await UsageStats.checkUsagePermission();
    if (!(hasUsagePermission ?? false)) {
      await UsageStats.grantUsagePermission();
      final l = await UsageStats.queryEventStats(startDate, endDate);
    } else {
      final l = await UsageStats.queryUsageStats(startDate, endDate);
      l.first.totalTimeInForeground;
    }
    // AppUsage()
    //     .getAppUsage(startDate, endDate)
    //     .then((value) => print("z############${value}"));
    // _methodChannel.invokeMethod("getAppUsage", {"packName": arg}).then(
    // (value) => print("Recieve from java ${value}"));
    // _methodChannel.invokeMethod("getInstalledApps");
  }

  @override
  Future getInstalledApps() async {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(hours: 1));
    try {
      final data = await SharedPrefImpl.instance.getString(SharPrefKeys.packages);
      if (data != null) {
        notifyListeners();
      }
      final apps = await DeviceApps.getInstalledApplications(includeAppIcons: true, includeSystemApps: true, onlyAppsWithLaunchIntent: true);
      final usageInfo = await UsageStats.queryUsageStats(startDate, endDate);
      String totalTimeUsedForTheDay = '';
      totalTimeUsedForTheDay = (await UsageStats.queryEventStats(startDate, endDate)).first.totalTime!;
      _totalTime = int.parse(totalTimeUsedForTheDay);
      for (var element in apps) {
        for (var element1 in usageInfo) {
          if (element.packageName == element1.packageName) {
            // totalTimeUsedForTheDay = totalTimeUsedForTheDay + int.parse(element1.totalTimeInForeground!);
            _usageInfo.add(UsageInfoModel(
                usageInfo: element1,
                appName: element.appName,
                timeDuration: TimeUtils.prettyDuration(Duration(milliseconds: int.parse(element1.totalTimeInForeground!)))));
          }
        }
      }
    } catch (_) {
      //
      //
    }
    _usageInfo.sort((a, b) => int.parse(b.usageInfo!.totalTimeInForeground!).compareTo(int.parse(a.usageInfo!.totalTimeInForeground!)));
    notifyListeners();
  }

  @override
  // TODO: implement getApps
  // List<Application> get getApps => _apps;

  @override
  // TODO: implement usageInfo
  List<UsageInfoModel> get usageInfo => _usageInfo;
  @override
  // TODO: implement totalTimeUes
  int get totalTimeUes => throw UnimplementedError();
}
