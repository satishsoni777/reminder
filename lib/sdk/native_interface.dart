import 'package:app_reminder/db/shared_pref.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class NativeInterface {
  Future<dynamic> getAppUsageList(String arg);
  Future<dynamic> getInstalledApps();
  List<Application> get getApps;
}

class NativeInterfaceImpl extends NativeInterface with ChangeNotifier {
  final MethodChannel _methodChannel =
      const MethodChannel("com.native.inteface");
  List<Application> _apps = [];
  @override
  Future getAppUsageList(String arg) async {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(hours: 168));
    _methodChannel.invokeMethod("getAppUsage", {"packName": arg}).then(
        (value) => print("Recieve from java $value"));
        _methodChannel.invokeMethod("getRunningApps");
  }

  @override
  Future getInstalledApps() async {
    try {
      final data =
          await SharedPrefImpl.instance.getString(SharPrefKeys.packages);
      if (data != null) {
        notifyListeners();
      }
      _apps = await DeviceApps.getInstalledApplications(
          includeAppIcons: true,
          includeSystemApps: true,
          onlyAppsWithLaunchIntent: true);
      // final aas =
      //     await SharedPrefImpl.instance.setString(SharPrefKeys.packages, _apps);
    } catch (_) {
      //
      //
    }
    notifyListeners();
  }

  @override
  // TODO: implement getApps
  List<Application> get getApps => _apps;
}
