import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/time_spinner_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

import '../../global/color_controller.dart';

class TimeSpinner extends StatelessWidget {
  int alarmId;
  double fontSize;
  String mode;

  TimeSpinner(
      {Key? key,
      required this.alarmId,
      required this.fontSize,
      required this.mode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeSpinnerController = Get.put(TimeSpinnerController());
    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(
            fontSize: fontSize,
            fontFamily: MyFontFamily.mainFontFamily,
            color: Get.find<ColorController>().colorSet.mainTextColor,
          ),
        ),
      ),
      child: GetBuilder<TimeSpinnerController>(
          initState: (_) => mode == StringValue.editMode
              ? timeSpinnerController.initDateTimeInEdit(alarmId)
              : timeSpinnerController.initDateTimeInAdd(),
          builder: (_) {
            return FutureBuilder(
                future: timeSpinnerController.dateTimeFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CupertinoDatePicker(
                      initialDateTime: timeSpinnerController.alarmDateTime,
                      mode: CupertinoDatePickerMode.time,
                      onDateTimeChanged: (DateTime value) {
                        if (Get.find<RepeatModeController>().repeatMode ==
                            RepeatMode.off) {
                          _.setDayInRepeatOff(value);
                        }
                        _.alarmDateTime = value;
                      },
                    );
                  }
                  return const Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
