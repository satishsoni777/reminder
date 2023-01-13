import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app_reminder/home/controller/home_controller.dart';
import 'package:app_reminder/home/view/home_tile.dart';
import 'package:app_reminder/sdk/native_interface.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NativeInterface nativeInterface;
  late HomePageController homePageController;
  @override
  void initState() {
    nativeInterface = NativeInterfaceImpl();
    homePageController = HomePageControllerImp();
    nativeInterface.getInstalledApps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nativeInterface.getAppUsageList('arg');
        },
      ),
      body: ChangeNotifierProvider<NativeInterfaceImpl>.value(
          value: nativeInterface as NativeInterfaceImpl,
          builder: (context, snapshot) {
            {
              return Consumer(builder: (context, NativeInterfaceImpl snapshot, p) {
                if (snapshot.usageInfo.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        const CircularProgressIndicator(),
                      ],
                    ),
                  );
                }
                return Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .3,
                      child: Card(),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: nativeInterface.usageInfo.length,
                          itemBuilder: (s, i) {
                            return HomeTile(
                              usageInfoModel: nativeInterface.usageInfo[i],
                            );
                          
                          }),
                    ),
                  ],
                );
              });
            }
          }),
    );
  }
}
