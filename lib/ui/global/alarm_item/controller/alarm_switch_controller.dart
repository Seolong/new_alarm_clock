import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/model/alarm_week_repeat_data.dart';
import 'package:new_alarm_clock/service/alarm_scheduler.dart';
import 'package:new_alarm_clock/service/date_time_calculator.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/utils/enum.dart';

class AlarmSwitchController extends GetxController {
  RxMap<int, bool> switchBoolMap = Map<int, bool>().obs;
  AlarmProvider _alarmProvider = AlarmProvider();

  void setSwitchBool(int id) async {
    AlarmData thisAlarmData = await _alarmProvider.getAlarmById(id);
    AlarmWeekRepeatData? thisAlarmWeekData =
        await _alarmProvider.getAlarmWeekDataById(id);
    if (switchBoolMap[id] == true) {
      switchBoolMap[id] = false;
      thisAlarmData.alarmState = false;
      await Get.find<AlarmListController>().updateAlarm(thisAlarmData);
      //noti 삭제..해야되는데..자꾸 noti 삭제가 안되니까 꼼수쓰기
      //근데 이렇게 1000000일 뒤 설정하니까 올바른 날짜가 아니라면서 자동 삭제되네
      //정신 나갈 것 같아요
      //AlarmScheduler.removeAlarm(id);
      AlarmScheduler().pushNotifyToEnd(id);
      update();
    } else {
      if (thisAlarmData.alarmDateTime.isBefore(DateTime.now())) {
        //끝난 알람 다시 true로 할 때
        List<bool> weekBool = [];
        if (thisAlarmData.alarmType == RepeatMode.week) {
          weekBool.add(thisAlarmWeekData!.sunday);
          weekBool.add(thisAlarmWeekData.monday);
          weekBool.add(thisAlarmWeekData.tuesday);
          weekBool.add(thisAlarmWeekData.wednesday);
          weekBool.add(thisAlarmWeekData.thursday);
          weekBool.add(thisAlarmWeekData.friday);
          weekBool.add(thisAlarmWeekData.saturday);
        }
        while (thisAlarmData.alarmDateTime.isBefore(DateTime.now())) {
          thisAlarmData.alarmDateTime =
              thisAlarmData.alarmDateTime.add(Duration(days: 1));
          thisAlarmData.alarmDateTime = DateTimeCalculator().getStartNearDay(
              thisAlarmData.alarmType, thisAlarmData.alarmDateTime,
              weekBool: weekBool,
              monthDay: thisAlarmData.monthRepeatDay,
              yearRepeatDay: thisAlarmData.alarmDateTime);
        }
      }
      switchBoolMap[id] = true;
      thisAlarmData.alarmState = true;
      //noti 복귀
      AlarmScheduler().notifyBeforeAlarm(id);
      Get.find<AlarmListController>().updateAlarm(thisAlarmData);
      update();
    }
  }
}
