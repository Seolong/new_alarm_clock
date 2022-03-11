import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

class RepeatListTile extends AlarmDetailListTile{
  RepeatListTile(){
    tileTitle = Text(
      '반복',
      textAlign: TextAlign.start,
      style: TextStyle(
          fontFamily: MyFontFamily.mainFontFamily,
          color: ColorValue.listTileTitleText,
          fontSize: 1000
      ),
    );
    tileSubTitle = Text(
      '5분마다 3회', //알람음 설정
      style: TextStyle(
          fontFamily: MyFontFamily.mainFontFamily,
          fontSize: 1000,
          color: ColorValue.listTileText
      ),
    );
    stateSwitch = Builder(
      builder: (context) {
        return Switch(value: true, onChanged: null);
      }
    );
  }
}