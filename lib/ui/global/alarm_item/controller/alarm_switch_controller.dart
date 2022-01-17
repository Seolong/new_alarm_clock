import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';

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
      switchBoolMap[id] = true;
      thisAlarmData.alarmState = true;
    }
    _alarmProvider.updateAlarm(thisAlarmData);
    update();
  }
}