import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/interval_text_field_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

import '../../../global/color_controller.dart';

class DayRepeatContainer extends RepeatContainer {
  dynamic intervalType;

  DayRepeatContainer(){
    intervalType = GetBuilder<IntervalTextFieldController>(
      builder: (_) {
        return Text(
            plural(LocaleKeys.day_args, _.getInterval()),
          style: TextStyle(
              fontSize: SizeValue.intervalTypeTextSize,
            color: Get.find<ColorController>().colorSet.mainTextColor
          ),
        );
      }
    );
    bottomColumn = Column();
  }
}
