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