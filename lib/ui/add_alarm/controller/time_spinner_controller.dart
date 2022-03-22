import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'dart:async';

import 'package:new_alarm_clock/utils/enum.dart';

class TimeSpinnerController extends GetxController{
  RxString _alarmDateTime = '2000-01-01T00:00:00.000'.obs;
  AlarmProvider _alarmProvider = AlarmProvider();
  Future<DateTime>? dateTimeFuture;
  RepeatMode repeatMode = RepeatMode.off;

  @override
  void onInit() {
    _alarmDateTime = DateTime.now().toIso8601String().obs;
    dateTimeFuture = null;
    debounce(_alarmDateTime, (_)=>print('$_ changed'), time: Duration(seconds: 1));

    super.onInit();
  }

  set alarmDateTime(DateTime dateTime){
    _alarmDateTime = dateTime.toIso8601String().obs;
    update();
  }

  DateTime get alarmDateTime{
    return DateTime.parse(_alarmDateTime.value);
  }

  Future<void> initDateTimeInEdit(int alarmId)async{
    AlarmData alarmData = await _alarmProvider.getAlarmById(alarmId);
    repeatMode = alarmData.alarmType;
    dateTimeFuture = Future.value(alarmData.alarmDateTime);
    _alarmDateTime = alarmData.alarmDateTime.toIso8601String().obs;
    update();
  }

  void initDateTimeInAdd(){
    _alarmDateTime = DateTime.now().toIso8601String().obs;
    dateTimeFuture = Future.value(DateTime.parse(_alarmDateTime.value));
  }

  void setDayInRepeatOff(DateTime value){
    if (repeatMode == RepeatMode.off) {
      //DateTimePicker의 onDateTimeChanged의 value는 당일에서만 변경할 수 있다.
      //오늘이 21일이라면 21일 00시~23시 59분 59초...가 범위라는 뜻
      //saveButton 누를 때 필연적으로 년월일과 시분초를
      //각각의 controller에서 분리한 뒤 합치는 수밖에 없다.
      if (value.isBefore(DateTime.now())) {
        value = value.add(Duration(days: 1));
        Get.find<StartEndDayController>().setStart(value);
      }
      else if(value.isAfter(DateTime.now())){
        Get.find<StartEndDayController>().setStart(value);
      }
    }
  }
}