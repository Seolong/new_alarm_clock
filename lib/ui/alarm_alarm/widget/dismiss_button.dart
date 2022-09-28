import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/service/alarm_scheduler.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

import '../controller/alarm_alarm_controller.dart';

class DismissButton extends StatelessWidget {
  Color buttonColor = Get.find<ColorController>().colorSet.mainColor;
  Color buttonOutsideColor = Colors.transparent;
  int alarmId = -1;
  AlarmScheduler alarmScheduler = AlarmScheduler();
  final AlarmAlarmController _alarmAlarmController = AlarmAlarmController();

  DismissButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _alarmAlarmController.offAlarmWithButton();
      },
      child: Container(
        height: 50,
        width: 200,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          gradient: LinearGradient(colors: [
            Get.find<ColorController>().colorSet.deepMainColor,
            Get.find<ColorController>().colorSet.lightMainColor,
          ]),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 0.5,
              blurRadius: 1.5,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Text(
          '알람 끄기',
          textScaleFactor: 1.0,
          style: TextStyle(
            fontSize: 18,
            color: Get.find<ColorController>().colorSet.appBarContentColor,
            fontFamily: MyFontFamily.mainFontFamily
          ),
        ),
      ),
    );
  }
}
