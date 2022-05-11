import 'dart:core';
import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/model/alarm_week_repeat_data.dart';
import 'package:new_alarm_clock/main.dart';
import 'package:new_alarm_clock/service/date_time_calculator.dart';
import 'package:new_alarm_clock/utils/enum.dart';


class AlarmListController extends GetxController{
  AlarmProvider alarmProvider = AlarmProvider();
  late Future<List<AlarmData>> alarmFutureList;
  RxList<AlarmData> alarmList = RxList<AlarmData>();
  RxList<AlarmData> currentFolderAlarmList = RxList<AlarmData>();
  AlarmProvider _alarmProvider = AlarmProvider();

  @override
  void onInit() async {
    alarmProvider.initializeDatabase();
    alarmFutureList = alarmProvider.getAllAlarms();
    List<AlarmData> varAlarmList = await alarmFutureList;
    alarmList = varAlarmList.obs;
    if (appState == 'main') {//자꾸 alarmalarm에서 초기화해서 날짜 한번 더 밀어버려서 만듦
      for(AlarmData alarmData in alarmList){
        if(alarmData.alarmState == true && alarmData.alarmDateTime.isBefore(DateTime.now())){
          int id = alarmData.id;
          AlarmWeekRepeatData? thisAlarmWeekData =
            await _alarmProvider.getAlarmWeekDataById(id);
          List<bool> weekBool = [];
          if (alarmData.alarmType == RepeatMode.week) {
            weekBool.add(thisAlarmWeekData!.sunday);
            weekBool.add(thisAlarmWeekData.monday);
            weekBool.add(thisAlarmWeekData.tuesday);
            weekBool.add(thisAlarmWeekData.wednesday);
            weekBool.add(thisAlarmWeekData.thursday);
            weekBool.add(thisAlarmWeekData.friday);
            weekBool.add(thisAlarmWeekData.saturday);
          }
          while (alarmData.alarmDateTime.isBefore(DateTime.now())) {
            alarmData.alarmDateTime =
                alarmData.alarmDateTime.add(Duration(days: 1));
            alarmData.alarmDateTime = DateTimeCalculator().getStartNearDay(
                alarmData.alarmType, alarmData.alarmDateTime,
                weekBool: weekBool,
                monthDay: alarmData.monthRepeatDay,
                yearRepeatDay: alarmData.alarmDateTime);
          }
          updateAlarm(alarmData);
        }
      }
    }

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

  Future<void> updateAlarm(AlarmData alarmData)async {
    await alarmProvider.updateAlarm(alarmData);
    alarmList[alarmList.indexWhere((element) =>
    alarmData.id == element.id)] = alarmData;
    alarmFutureList = alarmProvider.getAllAlarms();
    print('AlarmListController: updateAlarm');
    update();
  }

  Future<void> reorderAlarmInDB(List<AlarmData> alarmListInDB, int oldIndex, int newIndex)async{
    //옮길 때 alarmState가 이전 상태로 되돌아가는 것을 막기 위함.
    alarmListInDB = await alarmProvider.getAllAlarms();

    int newIndexAlarmOrder = alarmListInDB[newIndex].alarmOrder;
    if(newIndex < oldIndex){
      for(int i = newIndex; i<oldIndex; i++){
        alarmListInDB[i].alarmOrder =  alarmListInDB[i+1].alarmOrder;
        await alarmProvider.updateAlarm(alarmListInDB[i]);
      }
    }
    else if(newIndex > oldIndex){
      for(int i = newIndex; i>oldIndex; i--){
        alarmListInDB[i].alarmOrder =  alarmListInDB[i-1].alarmOrder;
        await alarmProvider.updateAlarm(alarmListInDB[i]);
      }
    }
    else{
      assert(false, 'oldIndex and newIndex cannot be same (in AlarmListController)');
    }
    alarmListInDB[oldIndex].alarmOrder = newIndexAlarmOrder;
    await alarmProvider.updateAlarm(alarmListInDB[oldIndex]);


    alarmList.value = await alarmProvider.getAllAlarms();
  }

  void reorderItem(int oldIndex, int newIndex)async{
    if(newIndex > alarmList.length){
      print('옮긴 위치가 alarmList 길이보다 클 수 없습니다.');
      newIndex = alarmList.length;
    }
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    var alarmListInDB = [...alarmList];

    var item = alarmList.removeAt(oldIndex);
    alarmList.insert(newIndex, item);

    await reorderAlarmInDB(alarmListInDB, oldIndex, newIndex);

    update();
  }
}