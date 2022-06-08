import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/controller/vibration_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/widget/vibration_list_view.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/widget_all/app_bar_title.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/global/divider/rounded_divider.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:vibration/vibration.dart';

class VibrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(VibrationRadioListController());
    return WillPopScope(
      onWillPop: () {
        Vibration.cancel();
        Get.back();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: ColorValue.appbarText,
          title: AppBarTitle('진동'),
          backgroundColor: ColorValue.appbar,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
                child: GetBuilder<VibrationRadioListController>(
                  builder: (_) => SwitchListTile(
                    title: Container(
                      alignment: Alignment.bottomLeft,
                      height: SizeValue.detailPowerTextHeight,
                      child: AutoSizeText(_.power ? '사용' : '사용 안 함',
                          bold: true,
                          color:
                              _.power ? ColorValue.activeSwitch : Colors.grey),
                    ),
                    value: _.power,
                    onChanged: (value) {
                      if (_.power) {
                        _.listTextColor = _.textColor['inactive']!;
                        Vibration.cancel();
                      } else {
                        _.listTextColor = _.textColor['active']!;
                      }

                      _.power = value;
                    },
                    activeColor: ColorValue.activeSwitch,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: RoundedDivider(ColorValue.appbar, 7.5),
              ),

              //진동 리스트
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: VibrationListView(),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
