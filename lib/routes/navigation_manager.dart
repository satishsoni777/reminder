import 'package:app_reminder/routes/routes.dart';
import 'package:flutter/material.dart';

class NavigationManager{

  static Future<dynamic>? usageDetails(BuildContext context,dynamic arg){
    Navigator.pushNamed(context, Routes.usageDetails,
    arguments: arg
    );
  }
}