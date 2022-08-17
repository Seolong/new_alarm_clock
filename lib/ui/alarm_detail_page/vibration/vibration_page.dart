import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/controller/vibration_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/widget/vibration_list_view.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/global/custom_switch.dart';
import 'package:new_alarm_clock/ui/global/custom_switch_list_tile.dart';
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
          leading: Padding(
            padding: const EdgeInsets.only(left: SizeValue.appBarLeftPadding),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                Vibration.cancel();
                Get.back();
              },
            ),
          ),
          title: Text(LocaleKeys.vibration.tr()),
        ),
        body: SafeArea(
          minimum: EdgeInsets.symmetric(
              horizontal: SizeValue.alarmDetailPageHorizontalPadding,
              vertical: SizeValue.alarmDetailPageVerticalPadding),
          child: Column(
            children: [
              GetBuilder<VibrationRadioListController>(
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
              //진동 리스트
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                child: Container(
                    padding: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Get.find<ColorController>().colorSet.backgroundColor,
                      borderRadius: BorderRadius.circular(7.5),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(175, 175, 175, 100),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 5), // changes position of shadow
                        )
                      ],
                    ),
                    child: VibrationListView()),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
