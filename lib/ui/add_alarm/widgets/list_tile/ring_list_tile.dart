import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/global/custom_switch.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class RingListTile extends AlarmDetailListTile {
  RingListTile() {
    tileTitle = Text(
      LocaleKeys.sound.tr(),
      textAlign: TextAlign.start,
      style: Theme.of(Get.context!).textTheme.titleMedium!,
    );
    tileSubTitle = GetBuilder<RingRadioListController>(builder: (_) {
      return Text(
        _.getNameOfSong(_.selectedMusicPath), //알람음 설정
        style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
            color: Get.find<ColorController>().colorSet.mainColor,
        ),
      );
    });
    stateSwitch = GetBuilder<RingRadioListController>(builder: (_) {
      return CustomSwitch(
        value: _.power,
        onChanged: (value) {
          _.power = value;
        },
        thumbColor: [
          Get.find<ColorController>().colorSet.lightMainColor,
          Get.find<ColorController>().colorSet.mainColor,
          Get.find<ColorController>().colorSet.deepMainColor,
        ],
        activeColor: Get.find<ColorController>().colorSet.switchTrackColor,
      );
    });
  }
}
