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
  dynamic intervalType;

  MonthRepeatContainer() {
    intervalType = GetBuilder<IntervalTextFieldController>(
      builder: (_) {
        return Text(
          plural(LocaleKeys.month_args, _.getInterval()),
          style: TextStyle(
              fontSize: SizeValue.intervalTypeTextSize,
              color: Get.find<ColorController>().colorSet.mainTextColor
          ),
        );
      }
    );
    bottomColumn = Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: GetBuilder<MonthRepeatDayController>(builder: (_) {
            return Text(
              _.monthRepeatDayText,
              style: TextStyle(
                  color: Get.find<ColorController>().colorSet.mainTextColor,
                  fontSize: SizeValue.monthRepeatDayText),
            );
          }),
        ),
        Container(
          height: 50,
        ),
        ChoiceDayButton(),
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 7.5),
          height: ButtonSize.medium - 4,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 1, minHeight: 1),
              child: Text(
                LocaleKeys.chooseRepeatDay.tr(),
                style: TextStyle(color: Colors.grey, fontSize: 1000),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
