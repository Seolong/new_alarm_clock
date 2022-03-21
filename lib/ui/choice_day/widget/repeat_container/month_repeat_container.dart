import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/month_repaet_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/widget_month/choice_day_button.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart';

class MonthRepeatContainer extends RepeatContainer {
  late IconButton startDayButton;
  late Text startDayText;
  late Text intervalType;

  MonthRepeatContainer() {
    intervalType = Text(
      '개월마다',
      style: TextStyle(fontSize: SizeValue.intervalTypeTextSize),
    );
    bottomColumn = Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: GetBuilder<MonthRepeatDayController>(
            builder: (_) {
              return Text( _.monthRepeatDayText.value,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: SizeValue.monthRepeatDayText),
              );
            }
          ),
        ),
        Container(height: 75,),
        ChoiceDayButton(),
        Container(
          padding: EdgeInsets.fromLTRB(0, 7.5, 0, 7.5),
          height: ButtonSize.medium + 4,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: ConstrainedBox(
              constraints:
              BoxConstraints(minWidth: 1, minHeight: 1),
              child: Text(
                '반복 날짜 선택',
                style: TextStyle(
                    color: Colors.black87, fontSize: 1000),
              ),
            ),
          ),
        ),

      ],

    );
  }
}
