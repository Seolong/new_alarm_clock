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
  YearRepeatContainer({Key? key}) : super(key: key) {
    Get.put(YearRepeatDayController());
    intervalType = GetBuilder<IntervalTextFieldController>(builder: (_) {
      return Text(
        plural(LocaleKeys.year_args, _.getInterval()),
        style: TextStyle(
            fontSize: SizeValue.intervalTypeTextSize,
            color: Get.find<ColorController>().colorSet.mainTextColor),
      );
    });
    bottomColumn = Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Material(
            elevation: 1.5,
            color: Get.find<ColorController>().colorSet.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GetBuilder<YearRepeatDayController>(builder: (_) {
                      return Text(
                        _.getYearRepeatDay_monthDay(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            color: Get.find<ColorController>().colorSet.mainTextColor),
                      );
                    }),
                  ),
                  Column(
                    children: [
                      GetBuilder<YearRepeatDayController>(builder: (_) {
                        return InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            onTap: () async {
                              var dateTime = await Get.dialog(AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: CalendarContainer(_.yearRepeatDay)));
                              _.yearRepeatDay = dateTime;
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.today,
                                  size: ButtonSize.large,
                                  color: Get.find<ColorController>().colorSet.deepMainColor,
                                )));
                      }),
                      Text(
                        '${LocaleKeys.chooseRepeatDay.tr()}\n${LocaleKeys.monthAndDay.tr()}',
                        style: const TextStyle(color: Colors.grey, fontSize: 15),
                        textAlign: TextAlign.center,
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
