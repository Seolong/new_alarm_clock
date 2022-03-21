import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_list_tile.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/controller/vibration_radio_list_controller.dart';
import 'package:new_alarm_clock/utils/type_converter.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:get/get.dart';

class VibrationListTile extends AlarmDetailListTile {
  VibrationListTile() {
    tileTitle = Text(
      '진동',
      textAlign: TextAlign.start,
      style: TextStyle(
          color: ColorValue.listTileTitleText,
          fontFamily: MyFontFamily.mainFontFamily,
          fontSize: 1000),
    );
    tileSubTitle = GetBuilder<VibrationRadioListController>(
      builder: (_) {
        return Text(
          TypeConverter.convertVibrationNameToString(_.selectedVibration), //알람음 설정
          style: TextStyle(
              color: ColorValue.listTileText,
              fontFamily: MyFontFamily.mainFontFamily,
              fontSize: 1000),
        );
      }
    );
    stateSwitch = GetBuilder<VibrationRadioListController>(
      builder: (_) {
        return Switch(
            value: _.power,
            onChanged: (value) {
              if (_.power) {
                _.listTextColor = _.textColor['inactive']!;
              } else {
                _.listTextColor = _.textColor['active']!;
              }

              _.power = value;
            },
          activeColor: ColorValue.activeSwitch,
        );
      }
    );
  }
}
