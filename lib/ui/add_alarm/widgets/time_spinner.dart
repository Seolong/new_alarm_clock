import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/time_spinner_controller.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

class TimeSpinner extends StatelessWidget {
  int alarmId;
  double fontSize;
  String mode;

  TimeSpinner(
      {required this.alarmId, required this.fontSize, required this.mode});

  @override
  Widget build(BuildContext context) {
    final timeSpinnerController = Get.put(TimeSpinnerController());
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
                        // //repeatmode가 defaultMode일 때
                        // if (value.isBefore(DateTime.now())) {
                        //   value = value.add(Duration(days: 1));
                        // }
                        //print(value);
                        _.alarmDateTime = value;
                        //print(_.alarmDateTime);
                        //print(value.toIso8601String());
                      },
                    );
                  }
                  return Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(ColorValue.fab),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
