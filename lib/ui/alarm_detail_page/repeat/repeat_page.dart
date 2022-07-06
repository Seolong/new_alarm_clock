import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/controller/repeat_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/widget/RepeatContainer.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/widget_all/app_bar_title.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';
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
        title: AppBarTitle('반복'),
        backgroundColor: Get.find<ColorController>().colorSet.mainColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
              child: GetBuilder<RepeatRadioListController>(
                builder: (_) => SwitchListTile(
                  title: Container(
                    alignment: Alignment.bottomLeft,
                    height: SizeValue.detailPowerTextHeight,
                    child: AutoSizeText(_.power ? '사용' : '사용 안 함',
                        bold: true,
                        color: _.power ? Get.find<ColorController>().colorSet.mainColor : Colors.grey),
                  ),
                  value: _.power,
                  onChanged: (value) {
                    if (_.power) {
                      _.listTextColor = _.textColor['inactive']!;
                    } else {
                      _.listTextColor = _.textColor['active']!;
                    }

                    _.power = value;
                  },
                  activeColor: Get.find<ColorController>().colorSet.mainColor,
                ),
              ),
            ),

            //주기 박스
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              child: RepeatContainer(repeatInterval),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              child: RepeatContainer(repeatNum),
            ),
          ],
        ),
      ),
    );
  }
}
