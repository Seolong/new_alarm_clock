import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_week_repeat_data.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';

class DayOfWeekController extends GetxController{
  Map<DayWeek, bool> dayButtonStateMap = Map<DayWeek, bool>();
  AlarmProvider _alarmProvider = AlarmProvider();

  @override
  void onInit() {
    for(var value in DayWeek.values){
      dayButtonStateMap[value] = false; //추가면 다 false, 수정이면 DB에서
    }

    super.onInit();
  }

  Future<void> initWhenEditMode(int alarmId) async{
    AlarmWeekRepeatData? weekRepeatData = await _alarmProvider.getAlarmWeekDataById(alarmId);

    if(weekRepeatData != null) {
      dayButtonStateMap[DayWeek.Sun] = weekRepeatData.sunday;
      dayButtonStateMap[DayWeek.Mon] = weekRepeatData.monday;
      dayButtonStateMap[DayWeek.Tue] = weekRepeatData.tuesday;
      dayButtonStateMap[DayWeek.Wed] = weekRepeatData.wednesday;
      dayButtonStateMap[DayWeek.Thu] = weekRepeatData.thursday;
      dayButtonStateMap[DayWeek.Fri] = weekRepeatData.friday;
      dayButtonStateMap[DayWeek.Sat] = weekRepeatData.saturday;
    }

    update();
  }

  bool getDayButtonState(DayWeek day){
    return dayButtonStateMap[day]!;
  }

  void reverseDayButtonState(DayWeek day){
    dayButtonStateMap[day] = !dayButtonStateMap[day]!;
    update();
  }

  void resetAllDayButtonStateToFalse(){
    dayButtonStateMap.forEach((key, value) {dayButtonStateMap[key] = false;});
    update();
  }

  Color getButtonStateColor(bool state){
    return state ? Get.find<ColorController>().colorSet.mainColor : ColorValue.addAlarmPageBackground;
  }

  Color getButtonTextColor(bool state){
    if(Get.find<RepeatModeController>().repeatMode == RepeatMode.single ||
    Get.find<RepeatModeController>().repeatMode == RepeatMode.day ||
        Get.find<RepeatModeController>().repeatMode == RepeatMode.month ||
        Get.find<RepeatModeController>().repeatMode == RepeatMode.year){
      return Colors.black12;
    }
    return state ? Get.find<ColorController>().colorSet.mainColor : Colors.black;
  }

}