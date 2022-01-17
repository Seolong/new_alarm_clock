import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/day_button_painter.dart';
import 'package:new_alarm_clock/utils/enum.dart';

class DayButton extends StatelessWidget {
  BoxConstraints constraints;
  DayWeek dayName;
  DayOfWeekController controller;

  DayButton(this.constraints, this.dayName, this.controller);

  @override
  Widget build(BuildContext context) {
    //DayOfWeekController controller = Get.put(DayOfWeekController());
    return GestureDetector(
      child: CustomPaint(
        // CustomPaint를 그리고 이 안에 차트를 그려줍니다..
        size:
        Size(min(constraints.maxWidth, constraints.maxHeight),
            min(constraints.maxWidth, constraints.maxHeight)),//??????????
        painter: DayButtonPainter(dayName, controller),
      ),
      onTap: () {
        controller.reverseDayButtonState(dayName);
      },
    );
  }
}