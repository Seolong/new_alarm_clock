import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/controller/repeat_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/widget/repeat_container.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';

import '../../global/color_controller.dart';
import '../../global/custom_switch.dart';
import '../../global/custom_switch_list_tile.dart';

class RepeatPage extends StatelessWidget {
  final String repeatInterval = '반복 주기';
  final String repeatNum = '반복 횟수';

  @override
  Widget build(BuildContext context) {
    Get.put(RepeatRadioListController());
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: SizeValue.appBarLeftPadding),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        title: Text(LocaleKeys.snooze.tr()),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(
            horizontal: SizeValue.alarmDetailPageHorizontalPadding,
            vertical: SizeValue.alarmDetailPageVerticalPadding
        ),
        child: Column(
          children: [
            GetBuilder<RepeatRadioListController>(
              builder: (_) => CustomSwitchListTile(
                title: AutoSizeText(
                    _.power ? LocaleKeys.on.tr() : LocaleKeys.off.tr(),
                    bold: true,
                    color: _.power
                        ? Get.find<ColorController>().colorSet.mainColor
                        : Colors.grey),
                value: _.power,
                switchWidget: CustomSwitch(
                  touchAreaHeight: 55,
                  value: _.power,
                  onChanged: (value) {
                    _.power = value;
                  },
                  thumbColor: [
                    Get.find<ColorController>().colorSet.lightMainColor,
                    Get.find<ColorController>().colorSet.mainColor,
                    Get.find<ColorController>().colorSet.deepMainColor,
                  ],
                  activeColor:
                  Get.find<ColorController>().colorSet.switchTrackColor,
                ),
                onChanged: (bool value) {
                  _.power = value;
                },
              ),
            ),
            Divider(),
            //주기 박스
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              child: RepeatContainer(repeatInterval, LocaleKeys.repeatInterval.tr()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              child: RepeatContainer(repeatNum, LocaleKeys.repeatNum.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
