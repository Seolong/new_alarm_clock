import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/interval_text_field_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/month_repeat_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/widget_month/choice_day_button.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

import '../../../global/color_controller.dart';

class MonthRepeatContainer extends RepeatContainer {
  MonthRepeatContainer({Key? key}) : super(key: key) {
    intervalType = GetBuilder<IntervalTextFieldController>(builder: (_) {
      return Text(
        plural(LocaleKeys.month_args, _.getInterval()),
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
            decoration: boxDecoration,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GetBuilder<MonthRepeatDayController>(builder: (_) {
                      return Text(
                        _.monthRepeatDayText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Get.find<ColorController>()
                                .colorSet
                                .mainTextColor,
                            fontSize: 20),
                      );
                    }),
                  ),
                  Column(
                    children: [
                      ChoiceDayButton(),
                      Text(
                        LocaleKeys.chooseRepeatDay.tr(),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
