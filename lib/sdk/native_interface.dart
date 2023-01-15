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
  int get totalTimeUsage;
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
    _methodChannel.invokeMethod("getIconColor", {"id": "com.jungleegames.poker"}).then((value) => print("Recieve from java ${value}"));
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
      List<EventInfo> eventsInfo = [];
      List<dynamic> apps = [];
      List<UsageInfo> usageInfo = [];
      Future.wait<dynamic>([_getInstalledApps(), _queryUsageStats(DateTime.now()), _queryEventStats(DateTime.now())])
          .then((List responses) => {
                apps.addAll(responses.first),
                usageInfo.addAll(responses[1]),
                eventsInfo.addAll(responses.last),
                if (eventsInfo.isNotEmpty) _totalTime = int.parse(eventsInfo.first.totalTime!),
                if (apps.isNotEmpty)
                  for (var element in apps)
                    {
                      for (var element1 in usageInfo)
                        {
                          if (element.packageName == element1.packageName && double.parse(element1.totalTimeInForeground!) != 0.0)
                            {
                              _usageInfo.add(UsageInfoModel(
                                  usageInfo: element1,
                                  appName: element.appName,
                                  appIcon: element.icon,
                                  percentage: (double.parse(element1.totalTimeInForeground!) / _totalTime.toDouble()),
                                  timeDuration: TimeUtils.prettyDuration(Duration(milliseconds: int.parse(element1.totalTimeInForeground!)))))
                            }
                        }
                    },
                if (_usageInfo.isNotEmpty)
                  {
                    _usageInfo
                        .sort((a, b) => int.parse(b.usageInfo!.totalTimeInForeground!).compareTo(int.parse(a.usageInfo!.totalTimeInForeground!))),
                  },
                addAll(),
              })
          .catchError((e) => {print(e), throw e});
    } catch (_) {
      //
      //
    }
  }

  @override
  List<UsageInfoModel> get usageInfo => _usageInfo;

  @override
  int get totalTimeUsage => throw UnimplementedError();

  Future _getInstalledApps() async {
    return DeviceApps.getInstalledApplications(includeAppIcons: true, includeSystemApps: true, onlyAppsWithLaunchIntent: true);
  }

  Future _queryUsageStats(DateTime endDate) async {
    DateTime startDate = endDate.subtract(const Duration(hours: 1));
    return UsageStats.queryUsageStats(startDate, endDate);
  }

  Future _queryEventStats(DateTime endDate) async {
    DateTime startDate = endDate.subtract(const Duration(hours: 1));
    return (UsageStats.queryEventStats(startDate, endDate));
  }

  void addAll() {
    int temp = 0;
    for (int i = 0; i < _usageInfo.length; i++) {
      if (_usageInfo[i].usageInfo?.packageName== _usageInfo[i].usageInfo?.packageName && i == 0) {
        temp = int.parse(_usageInfo[i].usageInfo!.totalTimeInForeground!) + int.parse(_usageInfo[i + 1].usageInfo!.totalTimeInForeground!);
      }
      if(_usageInfo[i] == _usageInfo[i + 1]){
        temp=int.parse(_usageInfo[i].usageInfo!.totalTimeInForeground!)+temp;
      }
    }
    notifyListeners();
  }
}
