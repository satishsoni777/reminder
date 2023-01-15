import 'package:usage_stats/usage_stats.dart';

class UsageInfoModel {
  UsageInfoModel({
    this.appName,
    this.usageInfo,
    this.timeDuration,
    this.percentage,
    this.appIcon,
    this.date,
  });
  UsageInfo? usageInfo;
  String? appName;
  String? timeDuration;
  double? percentage;
  dynamic? appIcon;
  String? date;
}
