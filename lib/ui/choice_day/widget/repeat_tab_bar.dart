import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_tab_bar_view.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class RepeatTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repeatModeController = Get.put(RepeatModeController());
    return DefaultTabController(
      length: 4,
      initialIndex: repeatModeController.subIndex.value,
      child: Builder(builder: (context) {
        final tabController = DefaultTabController.of(context)!;
        repeatModeController.setRepeatMode(1, tabController.index);
        tabController.addListener(() {
          repeatModeController.setRepeatMode(1, tabController.index);
        });
        return Column(children: [
          TabBar(
            labelStyle: const TextStyle(
              fontFamily: MyFontFamily.mainFontFamily,
              fontWeight: FontWeight.bold,
            ),
            indicator: MaterialIndicator(
                color: Get.find<ColorController>().colorSet.lightMainColor),
            indicatorColor: Get.find<ColorController>().colorSet.lightMainColor,
            labelColor: Get.find<ColorController>().colorSet.lightMainColor,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            tabs: <Widget>[
              Tab(
                text: LocaleKeys.day.tr(),
              ),
              Tab(
                text: LocaleKeys.week.tr(),
              ),
              Tab(
                text: LocaleKeys.month.tr(),
              ),
              Tab(
                text: LocaleKeys.year.tr(),
              ),
            ],
          ),
          Expanded(child: RepeatTabBarView())
        ]);
      }),
    );
  }
}
