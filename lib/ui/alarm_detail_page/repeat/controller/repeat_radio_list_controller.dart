import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:vibration/vibration.dart';

class RepeatRadioListController extends GetxController{
  //알람 수정이면 db에서 가져오고 알람 추가면 default 값으로 VibrationName.long으로
  AlarmInterval _alarmInterval = AlarmInterval.five;
  RepeatNum _repeatNum = RepeatNum.three;
  RxBool _power = false.obs;//DB에서 가져오기
  Map<String, Color> textColor = {
    'active': Colors.black,
    'inactive': Colors.grey
  };
  RxMap<String, Color> _listTextColor = {'text': Colors.black}.obs;


  set alarmInterval(AlarmInterval alarmInterval){
    _alarmInterval = alarmInterval;
    update();
  }
  AlarmInterval get alarmInterval => _alarmInterval;

  set repeatNum(RepeatNum repeatNum){
    _repeatNum = repeatNum;
    update();
  }
  RepeatNum get repeatNum => _repeatNum;

  set power(bool value){
    _power(value);
    //switch가 안 움직이면 대개 update()를 빼먹어서다.
    update();
  }

  bool get power => _power.value;

  set listTextColor(Color color){
    _listTextColor['text'] = color;
    update();
  }

  Color get listTextColor => _listTextColor['text']!;

  @override
  void onClose() {
    // TODO: implement onClose
    Vibration.cancel();
    super.onClose();
  }

  String convertInterval(AlarmInterval alarmInterval){
    switch(alarmInterval){
      case AlarmInterval.five:
        return '5분';
      case AlarmInterval.ten:
        return '10분';
      case AlarmInterval.fifteen:
        return '15분';
    }
  }

  String convertRepeatNum(RepeatNum repeatNum){
    switch(repeatNum){
      case RepeatNum.two:
        return '2회';
      case RepeatNum.three:
        return '3회';
      case RepeatNum.infinite:
        return '계속 반복';
    }
  }
}