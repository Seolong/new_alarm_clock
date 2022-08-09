import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/controller/vibration_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/widget/vibration_list_view.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/global/custom_switch.dart';
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(LocaleKeys.vibration.tr()),
        ),
        body: SafeArea(
          minimum: EdgeInsets.symmetric(
              horizontal: SizeValue.alarmDetailPageHorizontalPadding,
              vertical: SizeValue.alarmDetailPageVerticalPadding),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeValue.alarmDetailPagePowerPadding),
                child: GetBuilder<VibrationRadioListController>(
                  builder: (_) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.bottomLeft,
                          height: SizeValue.detailPowerTextHeight,
                          child: AutoSizeText(
                              _.power
                                  ? LocaleKeys.on.tr()
                                  : LocaleKeys.off.tr(),
                              bold: true,
                              color: _.power
                                  ? Get.find<ColorController>()
                                  .colorSet
                                  .mainColor
                                  : Colors.grey),
                        ),
                        CustomSwitch(
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
                          activeColor: Get.find<ColorController>()
                              .colorSet
                              .switchTrackColor,
                        )
                      ]),
                ),
              ),
              Divider(),
              //진동 리스트
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: VibrationListView(),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
