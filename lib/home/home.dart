import 'package:app_reminder/routes/navigation_manager.dart';
import 'package:app_reminder/sdk/native_interface.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NativeInterface nativeInterface;
  @override
  void initState() {
    nativeInterface = NativeInterfaceImpl();
    nativeInterface.getInstalledApps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
      ),
      body: ChangeNotifierProvider<NativeInterfaceImpl>.value(
          value: nativeInterface as NativeInterfaceImpl,
          builder: (context, snapshot) {
            {
              return Consumer(
                  builder: (context, NativeInterfaceImpl snapshot, p) {
                if (snapshot.getApps.isEmpty) {
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
                return ListView.builder(
                    itemCount: nativeInterface.getApps.length,
                    itemBuilder: (s, i) {
                      return ListTile(
                        title: Text(
                          nativeInterface.getApps[i].appName,
                        ),
                        onTap: () {
                        NavigationManager.usageDetails(context,
                      nativeInterface.getApps[i].packageName,
                        );
                        },
                      );
                    });
              });
            }
          }),
    );
  }
}
