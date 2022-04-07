import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';

class AlarmSwitchController extends GetxController{
  RxMap<int, bool> switchBoolMap = Map<int, bool>().obs;
  AlarmProvider _alarmProvider = AlarmProvider();

  void setSwitchBool(int id) async{
    AlarmData thisAlarmData = await _alarmProvider.getAlarmById(id);
    if(switchBoolMap[id] == true){
      switchBoolMap[id] = false;
      thisAlarmData.alarmState = false;
    }
    else{
      //끝난 알람 다시 true로 할 때
      if(thisAlarmData.alarmDateTime.isBefore(DateTime.now())){
        while(thisAlarmData.alarmDateTime.isBefore(DateTime.now())){
          thisAlarmData.alarmDateTime = thisAlarmData.alarmDateTime.add(Duration(days: 1));
        }
      }
      switchBoolMap[id] = true;
      thisAlarmData.alarmState = true;
    }
    Get.find<AlarmListController>().updateAlarm(thisAlarmData);
    update();
  }
}