import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
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


  set alarmInterval(AlarmInterval alarmInterval){
    _alarmInterval = alarmInterval;
    update();
  }
  AlarmInterval get alarmInterval => _alarmInterval;

  void setAlarmIntervalWithInt(int value){
    switch(value){
      case 5:
        _alarmInterval = AlarmInterval.five;
        break;
      case 10:
        _alarmInterval = AlarmInterval.ten;
        break;
      case 15:
        _alarmInterval = AlarmInterval.fifteen;
        break;
      default:
        assert(false, 'setAlarmIntervalWithInt error in RepeatRadioListController');
    }
    update();
  }

  void setRepeatNumWithInt(int value){
    switch(value){
      case 2:
        _repeatNum = RepeatNum.two;
        break;
      case 3:
        _repeatNum = RepeatNum.three;
        break;
      case 12:
        _repeatNum = RepeatNum.infinite;
        break;
      default:
        assert(false, 'setRepeatNumWithInt error in RepeatRadioListController');
    }
    update();
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

  @override
  void onClose() {
    // TODO: implement onClose
    Vibration.cancel();
    super.onClose();
  }

  String getIntervalAsString(AlarmInterval interval){//radio에 text 표시용
    String result;
    switch(interval){
      case AlarmInterval.five:
        result = '5';
        break;
      case AlarmInterval.ten:
        result = '10';
        break;
      case AlarmInterval.fifteen:
        result = '15';
    }
    result += LocaleKeys.minutes.tr();
    return result;
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
    String result;
    switch(num){
      case RepeatNum.two:
        result = '2';
        break;
      case RepeatNum.three:
        result = '3';
        break;
      case RepeatNum.infinite:
        return LocaleKeys.continuously.tr();
    }
    result += LocaleKeys.times.tr();
    return result;
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