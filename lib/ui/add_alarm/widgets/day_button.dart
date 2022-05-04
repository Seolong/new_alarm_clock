import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/day_button_painter.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/interval_text_field_controller.dart';
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
      child: DayButtonPainter(dayName, controller),

      onTap: () {
        controller.reverseDayButtonState(dayName);
        //터치하면 자동으로 repeatMode Week
        if(dayOfWeekController.dayButtonStateMap.containsValue(true)){
          if(Get.find<RepeatModeController>().repeatMode == RepeatMode.off){
            Get.find<IntervalTextFieldController>().textEditingController.text = '1';
          }
          Get.find<RepeatModeController>().setRepeatModeWeek();
        }
        //일월화수목금토 다 off면 repeatMode가 off로 변경
        else{
          Get.find<RepeatModeController>().setRepeatModeOff();
          Get.find<IntervalTextFieldController>().textEditingController.text = '';
        }
        print(repeatModeController.getRepeatMode());
      },
    );
  }
}