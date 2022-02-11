import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/time_spinner_controller.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:get/get.dart';

class TimeSpinner extends StatelessWidget {
  double fontSize;

  TimeSpinner({required this.fontSize});

  @override
  Widget build(BuildContext context) {
    Get.put(TimeSpinnerController());
    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(
            fontSize: this.fontSize,
            fontFamily: MyFontFamily.mainFontFamily,
            color: ColorValue.timeSpinnerText,
          ),
        ),
      ),
      child: GetBuilder<TimeSpinnerController>(
        builder: (_) {
          return CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (DateTime value) {

              //repeatmode가 defaultMode일 때
              if(value.isBefore(DateTime.now())){
                value = value.add(Duration(days: 1));
              }
              //print(value);
              _.alarmDateTime = value;
              //print(_.alarmDateTime);
              //print(value.toIso8601String());

            },
          );
        }
      ),
    );
  }
}





