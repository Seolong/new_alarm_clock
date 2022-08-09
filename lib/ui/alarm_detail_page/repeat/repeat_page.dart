import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/controller/repeat_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/widget/RepeatContainer.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/widget_all/app_bar_title.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';

import '../../global/color_controller.dart';

class RepeatPage extends StatelessWidget {
  final String repeatInterval = '반복 주기';
  final String repeatNum = '반복 횟수';

  @override
  Widget build(BuildContext context) {
    Get.put(RepeatRadioListController());
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorValue.appbarText,
        title: AppBarTitle(LocaleKeys.snooze.tr()),
        backgroundColor: Get.find<ColorController>().colorSet.mainColor,
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(
            horizontal: SizeValue.alarmDetailPageHorizontalPadding,
            vertical: SizeValue.alarmDetailPageVerticalPadding
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeValue.alarmDetailPagePowerPadding
              ),
              child: GetBuilder<RepeatRadioListController>(
                builder: (_) => SwitchListTile(
                  title: Container(
                    alignment: Alignment.bottomLeft,
                    height: SizeValue.detailPowerTextHeight,
                    child: AutoSizeText(_.power ? LocaleKeys.on.tr() : LocaleKeys.off.tr(),
                        bold: true,
                        color: _.power ? Get.find<ColorController>().colorSet.mainColor : Colors.grey),
                  ),
                  value: _.power,
                  onChanged: (value) {
                    _.power = value;
                  },
                  activeColor: Get.find<ColorController>().colorSet.mainColor,
                ),
              ),
            ),

            //주기 박스
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              child: RepeatContainer(repeatInterval, LocaleKeys.repeatInterval.tr()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              child: RepeatContainer(repeatNum, LocaleKeys.repeatNum.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
