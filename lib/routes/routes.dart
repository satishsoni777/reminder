import 'package:app_reminder/usage_details/usage_details.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  static const usageDetails = '/usageDetails';
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.usageDetails:
      return MaterialPageRoute(builder: (c) =>  UsageDetails(
        packName: settings.arguments.toString(),
      ));
  }
}
