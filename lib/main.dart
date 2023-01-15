import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:app_usage/app_usage.dart';

import 'package:app_reminder/home/view/home.dart';
import 'package:app_reminder/routes/routes.dart';
import 'package:app_reminder/sdk/native_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(
          // primarySwatch: Colors.blue,
        ),
        onGenerateRoute: onGenerateRoute,
        home: HomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<AppUsageInfo> _infos = [];
  List<AppUsageInfo> infoList = [];

  NativeInterface? nativeInterface;
  @override
  void initState() {
    nativeInterface = NativeInterfaceImpl();
    nativeInterface?.getInstalledApps();
    getUsageStats();
    super.initState();
  }

  void getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(hours: 216000));
      infoList = await AppUsage().getAppUsage(startDate, endDate);
      setState(() => _infos = infoList);
      for (var info in infoList) {
        if (kDebugMode) print(info.toString());
      }
    } on AppUsageException catch (exception) {
      if (kDebugMode) print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
