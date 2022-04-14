import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:vibration/vibration.dart';

class RepeatRadioListController extends GetxController{
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

  void setAlarmIntervalWithInt(int value){
    switch(value){

    }
  }

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

  String getIntervalAsString(AlarmInterval interval){//radio에 text 표시용
    switch(interval){
      case AlarmInterval.five:
        return '5분';
      case AlarmInterval.ten:
        return '10분';
      case AlarmInterval.fifteen:
        return '15분';
    }
  }

  int getIntervalAsInt(){//DB 저장용
    switch(_alarmInterval){
      case AlarmInterval.five:
        return 5;
      case AlarmInterval.ten:
        return 10;
      case AlarmInterval.fifteen:
        return 15;
    }
  }

  String getRepeatNumAsString(RepeatNum num){
    switch(num){
      case RepeatNum.two:
        return '2회';
      case RepeatNum.three:
        return '3회';
      case RepeatNum.infinite:
        return '계속 반복';
    }
  }

  int getRepeatNumAsInt(){
    switch(_repeatNum){
      case RepeatNum.two:
        return 2;
      case RepeatNum.three:
        return 3;
      case RepeatNum.infinite:
        return 12;
    }
  }
}