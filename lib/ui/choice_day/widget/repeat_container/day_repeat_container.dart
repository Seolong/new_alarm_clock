import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';

class DayRepeatContainer extends RepeatContainer {
  late IconButton startDayButton;
  late Text startDayText;
  late Text intervalType;

  DayRepeatContainer(){
    intervalType = Text(
        '일마다',
      style: TextStyle(
          fontSize: SizeValue.intervalTypeTextSize
      ),
    );
    bottomColumn = Column();
  }
}
