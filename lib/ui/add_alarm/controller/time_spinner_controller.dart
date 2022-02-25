import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'dart:async';

class TimeSpinnerController extends GetxController{
  RxString _alarmDateTime = '2000-01-01T00:00:00.000'.obs;
  AlarmProvider _alarmProvider = AlarmProvider();
  late Future<DateTime>? dateTimeFuture;

  @override
  void onInit() {
    _alarmDateTime = DateTime.now().toIso8601String().obs;
    dateTimeFuture = null;

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
    dateTimeFuture = Future.value(alarmData.alarmDateTime);
    _alarmDateTime = alarmData.alarmDateTime.toIso8601String().obs;
    update();
  }

  void initDateTimeInAdd(){
    _alarmDateTime = DateTime.now().toIso8601String().obs;
    dateTimeFuture = Future.value(DateTime.parse(_alarmDateTime.value));
  }
}