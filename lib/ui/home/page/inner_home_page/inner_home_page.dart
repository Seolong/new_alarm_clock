import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_list_controller.dart';
import 'package:new_alarm_clock/ui/home/page/inner_home_page/widgets/alarm_list_view.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

import '../../../../data/model/alarm_data.dart';
import '../../../../utils/values/string_value.dart';

class InnerHomePage extends StatelessWidget {
  final AlarmProvider _alarmProvider = AlarmProvider();

  InnerHomePage() {
    _alarmProvider.initializeDatabase();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Get.find<ColorController>().colorSet.backgroundColor,
      body: Column(
        children: [
          Container(
            height: 65,
            padding: const EdgeInsets.fromLTRB(22.5, 15, 20, 12.5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Get.find<ColorController>().colorSet.mainColor,
                border: Border.all(color: Get.find<ColorController>().colorSet.mainColor,)
            ),
            child: GetBuilder<FolderListController>(
              builder: (_) {
                return Text(
                _.currentFolderName == StringValue.allAlarms
                    ? LocaleKeys.allAlarms.tr()
                    : _.currentFolderName,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Get.find<ColorController>().colorSet.appBarContentColor,
                    fontFamily: MyFontFamily.mainFontFamily,
                    fontWeight: FontWeight.bold
                  ),
                );
              }
            ),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: AlarmListView(),
          )),
        ],
      ),
    );
  }
}
