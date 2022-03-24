import 'dart:core';
import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';


class AlarmListController extends GetxController{
  AlarmProvider alarmProvider = AlarmProvider();
  late Future<List<AlarmData>> alarmFutureList;
  RxList<AlarmData> alarmList = RxList<AlarmData>();
  RxList<AlarmData> currentFolderAlarmList = RxList<AlarmData>();

  @override
  void onInit() async {
    alarmProvider.initializeDatabase();
    alarmFutureList = alarmProvider.getAllAlarms();
    List<AlarmData> varAlarmList = await alarmFutureList;
    alarmList = varAlarmList.obs;

    update(); //이걸 안 해서 futurebuilder로 승부봤었다.
    super.onInit();
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