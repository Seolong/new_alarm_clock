import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/day_button.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart';

class WeekRepeatContainer extends RepeatContainer {
  late IconButton startDayButton;
  late Text startDayText;
  late Text intervalType;

  WeekRepeatContainer(){
    intervalType = Text(
        '주마다',
      style: TextStyle(
          fontSize: SizeValue.intervalTypeTextSize
      ),
    );
    bottomColumn = Column(
      children: [
        Container(
          height: 100,
          //슬라이드해서 week컨테이너로 가면 일~월이 회색이길래..
          child: GetBuilder<RepeatModeController>(
            builder: (context) {
              return GetBuilder<DayOfWeekController>(
                builder: (_) => LayoutBuilder(
                  builder: (BuildContext context,
                      BoxConstraints constraints) =>
                      Row(
                        children: [
                          Expanded(
                              child:
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: DayButton(constraints, DayWeek.Sun, _),
                              )),
                          Expanded(
                              child:
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: DayButton(constraints, DayWeek.Mon, _),
                              )),
                          Expanded(
                              child:
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: DayButton(constraints, DayWeek.Tue, _),
                              )),
                          Expanded(
                              child:
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: DayButton(constraints, DayWeek.Wed, _),
                              )),
                          Expanded(
                              child:
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: DayButton(constraints, DayWeek.Thu, _),
                              )),
                          Expanded(
                              child:
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: DayButton(constraints, DayWeek.Fri, _),
                              )),
                          Expanded(
                              child:
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: DayButton(constraints, DayWeek.Sat, _),
                              )),
                        ],
                      ),
                ),
              );
            }
          ),
        ),
      ],
    );
  }
}
