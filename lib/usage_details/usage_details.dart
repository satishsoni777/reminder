import 'package:app_reminder/sdk/native_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsageDetails extends StatefulWidget {
  const UsageDetails({Key? key, required this.packName}) : super(key: key);
  final String packName;
  @override
  State<UsageDetails> createState() => _UsageDetailsState();
}

class _UsageDetailsState extends State<UsageDetails> {
  NativeInterface ?nativeInterface;
  @override
  void initState() {
   nativeInterface=NativeInterfaceImpl();
   nativeInterface?.getAppUsageList(widget.packName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(),
      body: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const ListTile(
            title: Text('Total usage time'),
            trailing: Text('5 hours'),
          ),
          const ListTile(
            title: Text('Screen on time'),
            trailing: Text('3 hours'),
          ),
          ListTile(
            title: Text('Number of unlocks'),
            trailing: Text('50'),
          ),
          ListTile(
            title: Text('Number of notifications'),
            trailing: Text('100'),
          ),
        ],
      ),
    );
  }
}
