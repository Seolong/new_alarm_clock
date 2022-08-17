import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:get/get.dart' hide Trans;
import '../../global/color_controller.dart';

class DayButtonPainter extends StatelessWidget {
  Color circleColor = Get.find<ColorController>().colorSet.backgroundColor;
  Color textColor = Get.find<ColorController>().colorSet.mainTextColor;
  DayWeek name;
  DayOfWeekController controller;

  DayButtonPainter(this.name, this.controller);

  String? convertName(DayWeek dayName) {
    switch (dayName) {
      case DayWeek.Sun:
        return LocaleKeys.sun.tr();
      case DayWeek.Mon:
        return LocaleKeys.mon.tr();
      case DayWeek.Tue:
        return LocaleKeys.tue.tr();
      case DayWeek.Wed:
        return LocaleKeys.wed.tr();
      case DayWeek.Thu:
        return LocaleKeys.thu.tr();
      case DayWeek.Fri:
        return LocaleKeys.fri.tr();
      case DayWeek.Sat:
        return LocaleKeys.sat.tr();
      default:
        assert(false, 'convertName Error in DayButtonPainter Class');
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DayOfWeekController>(builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(1.75),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 40
          ),
          child: Container(
            padding: EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _.getButtonStateColor(_.dayButtonStateMap[name]!),
                width: 3
              ),
            ),
            child: AutoSizeText(convertName(name)!,
                color: _.getButtonTextColor(controller.dayButtonStateMap[name]!)),
          ),
        ),
      );
    });
  }
}
