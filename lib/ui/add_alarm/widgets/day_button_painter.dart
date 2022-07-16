import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';

class DayButtonPainter extends StatelessWidget {
  Color circleColor = ColorValue.addAlarmPageBackground;
  Color textColor = Colors.black;
  DayWeek name;
  DayOfWeekController controller;

  DayButtonPainter(this.name, this.controller);

  String? convertName(DayWeek dayName) {
    switch (dayName) {
      case DayWeek.Sun:
        return '일';
      case DayWeek.Mon:
        return '월';
      case DayWeek.Tue:
        return '화';
      case DayWeek.Wed:
        return '수';
      case DayWeek.Thu:
        return '목';
      case DayWeek.Fri:
        return '금';
      case DayWeek.Sat:
        return '토';
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
      );
    });
  }
}
