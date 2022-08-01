import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/controller/repeat_radio_list_controller.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

class RepeatListTile extends AlarmDetailListTile{
  RepeatListTile(){
    tileTitle = Text(
      LocaleKeys.snooze.tr(),
      textAlign: TextAlign.start,
      style: TextStyle(
          fontFamily: MyFontFamily.mainFontFamily,
          color: ColorValue.listTileTitleText,
          fontSize: 1000
      ),
    );
    tileSubTitle = GetBuilder<RepeatRadioListController>(
      builder: (_) {
        return Text(
          '${_.getIntervalAsString(_.alarmInterval)}'
              ', ${_.getRepeatNumAsString(_.repeatNum)}', //알람음 설정
          style: TextStyle(
              fontFamily: MyFontFamily.mainFontFamily,
              fontSize: 1000,
              color: ColorValue.listTileText
          ),
        );
      }
    );
    stateSwitch = GetBuilder<RepeatRadioListController>(
        builder: (_) {
          return Switch(
            value: _.power,
            onChanged: (value) {
              if (_.power) {
                _.listTextColor = _.textColor[StringValue.inactive]!;
              } else {
                _.listTextColor = _.textColor[StringValue.active]!;
              }

              _.power = value;
            },
            activeColor: ColorValue.activeSwitch,
          );
        }
    );
  }
}