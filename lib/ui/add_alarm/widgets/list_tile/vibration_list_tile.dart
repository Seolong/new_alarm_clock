import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_list_tile.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

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
    tileSubTitle = Text(
      'Heartbeat', //알람음 설정
      style: TextStyle(
          color: ColorValue.listTileText,
          fontFamily: MyFontFamily.mainFontFamily,
          fontSize: 1000),
    );
  }
}
