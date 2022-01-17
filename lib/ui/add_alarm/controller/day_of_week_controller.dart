import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';

class DayOfWeekController extends GetxController{
  RxMap<DayWeek, bool> dayButtonStateMap = Map<DayWeek, bool>().obs;


  @override
  void onInit() {
    for(var value in DayWeek.values){
      dayButtonStateMap[value] = false; //수정이면 다 false, 추가면 DB에서
    }

    super.onInit();
  }

  bool getDayButtonState(DayWeek day){
    return dayButtonStateMap[day]!;
  }

  void reverseDayButtonState(DayWeek day){
    dayButtonStateMap[day] = !dayButtonStateMap[day]!;
    update();
  }

  Color getButtonStateColor(bool state){
    return state ? ColorValue.dayButtonActive : ColorValue.addAlarmPageBackground;
  }

  Color getButtonTextColor(bool state){
    return state ? ColorValue.dayButtonActive : Colors.black;
  }

}