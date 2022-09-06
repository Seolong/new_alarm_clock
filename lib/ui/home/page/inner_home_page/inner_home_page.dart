import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_list_controller.dart';
import 'package:new_alarm_clock/ui/home/page/inner_home_page/widgets/alarm_list_view.dart';
import 'package:new_alarm_clock/ui/home/page/inner_home_page/widgets/next_alarm_container.dart';
import 'package:new_alarm_clock/ui/home/page/inner_home_page/widgets/stabilization_button.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

import '../../../../utils/values/string_value.dart';
import '../../../stabilization/controller/permission_controller.dart';

class InnerHomePage extends StatelessWidget {
  final AlarmProvider _alarmProvider = AlarmProvider();

  InnerHomePage({Key? key}) : super(key: key) {
    _alarmProvider.initializeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PermissionController());
    return Scaffold(
      extendBody: true,
      backgroundColor: Get.find<ColorController>().colorSet.backgroundColor,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 70.0,
          collapsedHeight: 70.0,
          toolbarHeight: 60.0,
          centerTitle: true,
          titleTextStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Get.find<ColorController>().colorSet.appBarContentColor,
              fontFamily: MyFontFamily.mainFontFamily,
              fontWeight: FontWeight.bold),
          title: GetBuilder<FolderListController>(builder: (_) {
            return Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Text(
                _.currentFolderName == StringValue.allAlarms
                    ? LocaleKeys.allAlarms.tr()
                    : _.currentFolderName,
              ),
            );
          }),
        ),
        SliverToBoxAdapter(
          child: NextAlarmContainer(),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if(index == 0){
              return FutureBuilder(
                future: Get.find<PermissionController>().warningSharedPreference.getIsIgnoreValue(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return const SizedBox.shrink();
                  }else if(snapshot.data == true){
                    return const SizedBox.shrink();
                  }else if(snapshot.data == false){
                    return const StabilizationButton();
                  }
                  return const Text('Error!');
                }
              );
            }
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: AlarmListView(),
            );
          }, childCount: 2),
        ),
      ]),
    );
  }
}
