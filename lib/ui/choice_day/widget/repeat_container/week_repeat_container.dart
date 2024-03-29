import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/day_button.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/interval_text_field_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

import '../../../global/color_controller.dart';

class WeekRepeatContainer extends RepeatContainer {
  WeekRepeatContainer({Key? key}) : super(key: key) {
    intervalType = GetBuilder<IntervalTextFieldController>(builder: (_) {
      return Text(
        plural(LocaleKeys.week_args, _.getInterval()),
        style: TextStyle(
            fontSize: SizeValue.intervalTypeTextSize,
            color: Get.find<ColorController>().colorSet.mainTextColor),
      );
    });
    bottomColumn = Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Container(
            height: 100,
            decoration: boxDecoration,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            //슬라이드해서 week컨테이너로 가면 일~월이 회색이길래..
            child: GetBuilder<RepeatModeController>(builder: (context) {
              return GetBuilder<DayOfWeekController>(
                builder: (_) => LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) =>
                      Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: DayButton(constraints, DayWeek.Sun, _),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: DayButton(constraints, DayWeek.Mon, _),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: DayButton(constraints, DayWeek.Tue, _),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: DayButton(constraints, DayWeek.Wed, _),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: DayButton(constraints, DayWeek.Thu, _),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: DayButton(constraints, DayWeek.Fri, _),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: DayButton(constraints, DayWeek.Sat, _),
                      )),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
