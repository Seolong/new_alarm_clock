import 'dart:core';
import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/utils/enum.dart';


class AlarmListController extends GetxController{
  AlarmProvider alarmProvider = AlarmProvider();
  late Future<List<AlarmData>> alarmFutureList;
  RxList<AlarmData> alarmList = RxList<AlarmData>();

  AlarmListController(){
  }

  @override
  void onInit() async {
    alarmProvider.initializeDatabase();
    alarmFutureList = alarmProvider.getAllAlarms();
    List<AlarmData> varAlarmList = await alarmFutureList;
    alarmList = varAlarmList.obs;

    inputAlarm(generateAlarmData(0, title: '출근'));
    inputAlarm(generateAlarmData(1, title: '퇴근'));
    inputAlarm(generateAlarmData(2, title: '퇴근2'));
    inputAlarm(generateAlarmData(3, title: '퇴근3'));
    super.onInit();
  }

  AlarmData generateAlarmData(int pid, {String? title}){
    return AlarmData(
      id: pid,
      alarmType: RepeatMode.off,
      title: title,
      alarmDateTime: DateTime(2022),
      endDay: DateTime(2045),
      alarmState: true,
      folderName: '전체 알람',
      alarmInterval: 0,
      dayOff: DateTime(2045),
      musicBool: false,
      musicPath: 'path',
      vibrationBool: false,
      vibrationName: 'vibName',
      repeatBool: false,
      repeatInterval: 0,
    );
  }

  void inputAlarm(AlarmData alarmData) async{
    await alarmProvider.insertAlarm(alarmData);
    //List에 없을 때만 List에 넣는다
    if(!alarmList.any((e)=>e.id == alarmData.id)){
      alarmList.add(alarmData);
    }
    alarmFutureList = alarmProvider.getAllAlarms();
    update();
  }

  void deleteAlarm(int id){
    alarmProvider.deleteAlarm(id);
    alarmList.removeWhere((element) => element.id == id);
    alarmFutureList = alarmProvider.getAllAlarms();
    update();
  }

  void updateAlarm(AlarmData alarmData){
    alarmProvider.updateAlarm(alarmData);
    alarmList[alarmList.indexWhere((element) =>
      alarmData.id == element.id)] = alarmData;
    alarmFutureList = alarmProvider.getAllAlarms();
    update();
  }
}