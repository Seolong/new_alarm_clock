import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/interval_text_field_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/year_repeat_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/widget_all/calendar_container.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

import '../../../global/color_controller.dart';

class YearRepeatContainer extends RepeatContainer {
  dynamic intervalType;

  YearRepeatContainer() {
    Get.put(YearRepeatDayController());
    intervalType = GetBuilder<IntervalTextFieldController>(
      builder: (_) {
        return Text(
          plural(LocaleKeys.year_args, _.getInterval()),
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
          padding: const EdgeInsets.only(top: 20),
          child: GetBuilder<YearRepeatDayController>(builder: (_) {
            return Text(
              '${_.getYearRepeatDay_monthDay()}',
              style: TextStyle(
                  fontSize: SizeValue.yearRepeatDayText,
                  color: Get.find<ColorController>().colorSet.mainTextColor
              ),
            );
          }),
        ),
        Container(
          height: 50,
        ),
        GetBuilder<YearRepeatDayController>(builder: (_) {
          return InkWell(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              onTap: () async {
                var dateTime = await Get.dialog(AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    content: CalendarContainer(_.yearRepeatDay)));
                _.yearRepeatDay = dateTime;
              },
              child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.today,
                    size: ButtonSize.large,
                    color: Get.find<ColorController>().colorSet.deepMainColor,
                  )));
        }),
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 7.5),
          height: ButtonSize.medium * 2 - 15,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 1, minHeight: 1),
              child: Text(
                '${LocaleKeys.chooseRepeatDay.tr()}\n${LocaleKeys.monthAndDay.tr()}',
                style: TextStyle(color: Colors.grey, fontSize: 1000),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
