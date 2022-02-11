import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/day_button_painter.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:get/get.dart';

class DayButton extends StatelessWidget {
  BoxConstraints constraints;
  DayWeek dayName;
  DayOfWeekController controller;

  DayButton(this.constraints, this.dayName, this.controller);

  @override
  Widget build(BuildContext context) {
    var repeatModeController = Get.put(RepeatModeController());
    DayOfWeekController dayOfWeekController = Get.put(DayOfWeekController());
    return GestureDetector(
      child: CustomPaint(
        // CustomPaint를 그리고 이 안에 차트를 그려줍니다..
        size:
        Size(min(constraints.maxWidth, constraints.maxHeight),
            min(constraints.maxWidth, constraints.maxHeight)),//??????????
        painter: DayButtonPainter(dayName, controller),
      ),
      onTap: () {
        //터치하면 자동으로 repeatMode
        if(dayOfWeekController.dayButtonStateMap.containsValue(true)){
          Get.find<RepeatModeController>().setRepeatModeWeek();
        }
        controller.reverseDayButtonState(dayName);
        //일월화수목금토 다 off면 repeatMode가 off로 변경
        if(!dayOfWeekController.dayButtonStateMap.containsValue(true)){
          Get.find<RepeatModeController>().setRepeatModeOff();
        }
        print(repeatModeController.getRepeatMode());
      },
    );
  }
}