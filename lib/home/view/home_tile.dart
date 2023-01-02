import 'package:flutter/material.dart';

import 'package:app_reminder/home/model/UsageInfoModel.dart';

class HomeTile extends StatelessWidget {
  const HomeTile({Key? key, this.usageInfoModel}) : super(key: key);
  final UsageInfoModel? usageInfoModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      margin: const EdgeInsets.symmetric(vertical: 14),
      child: InkWell(
        onTap: () {},
        child: Column(children: <Widget>[
          Row(
            children: [
              const Icon(Icons.app_blocking),
              const SizedBox(
                width: 20,
              ),
              Text(usageInfoModel?.appName ?? ''),
              const Spacer(),
              Text(usageInfoModel?.timeDuration ?? '')
            ],
          ),
          LayoutBuilder(
            builder: (context, cntr) {
              print(cntr);
              return Container(
                height: 6,
              );
            }
          )
        ]),
      ),
    );
  }
}
