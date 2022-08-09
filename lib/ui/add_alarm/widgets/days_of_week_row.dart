import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import '../../../utils/enum.dart';
import '../../../utils/values/string_value.dart';
import '../../choice_day/controller/repeat_mode_controller.dart';
import '../../global/convenience_method.dart';
import '../controller/day_of_week_controller.dart';
import 'day_button.dart';

class DaysOfWeekRow extends StatelessWidget {
  String mode;
  int alarmId;

  DaysOfWeekRow(this.mode, this.alarmId);

  bool _isAbsorb(RepeatModeController repeatModeController) {
    if (repeatModeController.repeatMode == RepeatMode.off ||
        repeatModeController.repeatMode == RepeatMode.week) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(DayOfWeekController());
    return GetBuilder<DayOfWeekController>(
      //editMode에다가 WeekMode여야 한다
      initState: (_) => mode == StringValue.editMode
          ? Get.find<DayOfWeekController>().initWhenEditMode(alarmId)
          : null,
      builder: (_) => LayoutBuilder(
        builder: (BuildContext context,
            BoxConstraints constraints) =>
            GetBuilder<RepeatModeController>(
                builder: (repeatCont) {
                  // off나 week이 아니면 터치 막아버림
                  return GestureDetector(
                    onTap: () {
                      if (_isAbsorb(repeatCont)) {
                        ConvenienceMethod.showSimpleSnackBar(
                            LocaleKeys.notWeekMode.tr());
                      }
                    },
                    child: AbsorbPointer(
                      absorbing: _isAbsorb(repeatCont),
                      child: Row(
                        children: [
                          Expanded(
                              child: DayButton(constraints,
                                  DayWeek.Sun, _)),
                          Expanded(
                              child: DayButton(constraints,
                                  DayWeek.Mon, _)),
                          Expanded(
                              child: DayButton(constraints,
                                  DayWeek.Tue, _)),
                          Expanded(
                              child: DayButton(constraints,
                                  DayWeek.Wed, _)),
                          Expanded(
                              child: DayButton(constraints,
                                  DayWeek.Thu, _)),
                          Expanded(
                              child: DayButton(constraints,
                                  DayWeek.Fri, _)),
                          Expanded(
                              child: DayButton(constraints,
                                  DayWeek.Sat, _)),
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
