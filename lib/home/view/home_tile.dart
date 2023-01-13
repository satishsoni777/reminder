import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:app_reminder/home/model/UsageInfoModel.dart';
import 'package:app_reminder/utils/string_util.dart';

class HomeTile extends StatelessWidget {
  const HomeTile({Key? key, this.usageInfoModel}) : super(key: key);
  final UsageInfoModel? usageInfoModel;
  @override
  Widget build(BuildContext context) {
    usageInfoModel;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      margin: const EdgeInsets.symmetric(vertical: 14),
      child: InkWell(
        onTap: () {},
        child: Column(children: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:1.0),
                child: SizedBox(
                  width: 44,
                  child: Image.memory(Uint8List.fromList(usageInfoModel!.appIcon))
                ),
              ),
              
              Text(usageInfoModel?.appName ?? ''),
              const Spacer(),
              Text(usageInfoModel?.timeDuration ?? '')
            ],
          ),
          LayoutBuilder(builder: (context, cntr) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 44,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 4,
                  color: Colors.blue,
                  width: cntr.maxWidth * usageInfoModel!.percentage!,
                ),
                const Spacer(),
                Text((usageInfoModel!.percentage! * 100).getStringAsFixed + "%")
              ],
            );
          })
        ]),
      ),
    );
  }
}
