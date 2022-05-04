import 'dart:async';
import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/model/alarm_week_repeat_data.dart';
import 'package:new_alarm_clock/data/shared_preferences/app_state_shared_preferences.dart';
import 'package:new_alarm_clock/data/shared_preferences/id_shared_preferences.dart';
import 'package:new_alarm_clock/service/life_cycle_listener.dart';
import 'package:new_alarm_clock/utils/enum.dart';

import '../main.dart';
import 'date_time_calculator.dart';

class AlarmScheduler {
  String getTimeWithTwoLetter(int time){
    if(time < 10)
      return '0$time';
    else
      return '$time';
  }

  void notifyBeforeAlarm(int alarmId)async{
    AlarmProvider alarmProvider = AlarmProvider();
    AlarmData alarmData = await alarmProvider.getAlarmById(alarmId);

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      //no permission of local notification
      AwesomeNotifications().requestPermissionToSendNotifications();
    }else{
      //show notification
      AwesomeNotifications().createNotification(
          content: NotificationContent( //simgple notification
            id: alarmId,
            channelKey: 'basic', //set configuration with key "basic"
            title: '곧 알람이 울립니다.',
            body: '${alarmData.title} '
                '${getTimeWithTwoLetter(alarmData.alarmDateTime.hour)}:'
                '${getTimeWithTwoLetter(alarmData.alarmDateTime.minute)}',
            payload: {'id':'$alarmId'},
            autoDismissible: false,
          ),
        schedule: NotificationCalendar.fromDate(
            date: alarmData.alarmDateTime.subtract(Duration(minutes: 30))),

          actionButtons: [
            NotificationActionButton(
              key: 'skip_once',
              label: '한 번 건너뛰기',
            )
          ]
      );
    }
  }

  static void removeAlarm(int alarmId){
    print('removed Alarm id in AlarmManager: $alarmId');
    AwesomeNotifications().cancel(alarmId);
    AndroidAlarmManager.cancel(alarmId);
  }

  /*
    To wake up the device and run something on top of the lockscreen,
    this currently requires the hack from here to be implemented:
    https://github.com/flutter/flutter/issues/30555#issuecomment-501597824
  */

  static void callback(int alarmId) async {
    print('Creating a new alarm flag for ID $alarmId');
    createAlarmFlag(alarmId);
  }

  /// Creates a flag file that the main isolate can find on life cycle change
  /// For now just abusing the FileProxy class for testing
  static void createAlarmFlag(int id) async {
    //print('Creating a new alarm flag for ID $id');
    AlarmProvider _alarmProvider = AlarmProvider();
    AlarmData alarm = await _alarmProvider.getAlarmById(id);

    if (alarm.alarmState && Platform.isAndroid) {
      final AppStateSharedPreferences _appStateSharedPreferences = AppStateSharedPreferences();
      print('aaaaaaaaaa ${await _appStateSharedPreferences.getAppState()}');
      await _appStateSharedPreferences.setAppStateToAlarm();

      //딱 이거 넣으니까 wakelock에서 예외 메시지 뜨는데
      //작동은 잘만 함
      appState = await _appStateSharedPreferences.getAppState();

      final IdSharedPreferences _idSharedPreferences = IdSharedPreferences();
      await _idSharedPreferences.setAlarmedId(id);

      restartApp();
      Bringtoforeground.bringAppToForeground();
      return;
    }
  }

  Future<void> newShot(DateTime targetDateTime, int id) async {
    print('insert Alarm with Scheduler');
    print(targetDateTime);
    notifyBeforeAlarm(id);
    await AndroidAlarmManager.oneShotAt(targetDateTime, id, callback,
        alarmClock: true, rescheduleOnReboot: true,
        allowWhileIdle: true, wakeup: true);
  }

  Future<AlarmData> updateAlarmWhenAlarmed(AlarmData alarmData) async{
    AlarmProvider alarmProvider = AlarmProvider();
    //알람 타입이 반복일 때
    if (alarmData.alarmType != RepeatMode.single &&
        alarmData.alarmType != RepeatMode.off) {
      DateTimeCalculator dateTimeCalculator = DateTimeCalculator();

      //말일이면 lastDay 변수 추가해서 처리
      //week이면 weekBool 변수 추가해서 처리
      List<bool> weekBool = [];
      bool lastDay = false;
      if(alarmData.alarmType == RepeatMode.week){
        AlarmWeekRepeatData? alarmWeekRepeatData = await alarmProvider.getAlarmWeekDataById(alarmData.id);
        weekBool.add(alarmWeekRepeatData!.sunday);
        weekBool.add(alarmWeekRepeatData.monday);
        weekBool.add(alarmWeekRepeatData.tuesday);
        weekBool.add(alarmWeekRepeatData.wednesday);
        weekBool.add(alarmWeekRepeatData.thursday);
        weekBool.add(alarmWeekRepeatData.friday);
        weekBool.add(alarmWeekRepeatData.saturday);
      }
      else if(alarmData.alarmType == RepeatMode.month){
        if(alarmData.monthRepeatDay == 29){
          lastDay = true;
        }
      }

      alarmData.alarmDateTime = dateTimeCalculator.addDateTime(
          alarmData.alarmType,
          alarmData.alarmDateTime,
          alarmData.alarmInterval,
          weekBool : weekBool,
          lastDay: lastDay
      );
      print('print ${alarmData.alarmInterval} in alarm scheduler');
      print(alarmData.alarmDateTime);

      if (alarmData.endDay != null) {
        if(alarmData.alarmDateTime.isAfter(alarmData.endDay!)){
          alarmData.alarmState = false;
          alarmData.endDay = null;
        }
      }
    }
    else{
      alarmData.alarmState = false;
    }

    return alarmData;
  }

  Future<AlarmData> skipDayOff(AlarmData alarmData) async{
    AlarmProvider alarmProvider = AlarmProvider();
    var dayOffList = await alarmProvider.getDayOffsById(alarmData.id);
    if(dayOffList.isNotEmpty){
      int hours = alarmData.alarmDateTime.hour;
      int minutes = alarmData.alarmDateTime.minute;
      for(int i=0; i<dayOffList.length; i++){
        dayOffList[i].dayOffDate = dayOffList[i].dayOffDate.add(Duration(
          hours: hours, minutes: minutes
        ));
      }
      dayOffList.sort((a, b) => a.dayOffDate.compareTo(b.dayOffDate));
      // 알람 울렸을 때 제일 작은 dayoff가 알람일보다 전이면 삭제
      // else로 다음꺼 받고
      // dayOff랑 다음 알람이랑 같으면 그 dayOff 삭제하고 다다음 알람으로 설정하고
      // 다다음 알람이 다음 dayOff랑 같으면 또 그 다음으로
      // dayOff가 더 없으면 null
      while(dayOffList.isNotEmpty && dayOffList[0].dayOffDate.isBefore(alarmData.alarmDateTime)){
        var deletedDayOff = dayOffList.removeAt(0);
        deletedDayOff.dayOffDate = deletedDayOff.dayOffDate.subtract(Duration(
            hours: hours, minutes: minutes
        ));
        alarmProvider.deleteDayOff(deletedDayOff.id, deletedDayOff.dayOffDate);
      }

      // 반복 알람으로 얻어지는 알람일인지 확인해야함.
      // 금지일 설정해도 진짜 알람일이 아니라 잘못 설정한 금지일에도
      // 얘들이 건너뛰게해줌.

      while(dayOffList.isNotEmpty && alarmData.alarmDateTime.isAtSameMomentAs(dayOffList[0].dayOffDate)) {
        var deletedDayOff = dayOffList.removeAt(0);
        deletedDayOff.dayOffDate = deletedDayOff.dayOffDate.subtract(Duration(
            hours: hours, minutes: minutes
        ));
        alarmProvider.deleteDayOff(deletedDayOff.id, deletedDayOff.dayOffDate);
        alarmData = await updateAlarmWhenAlarmed(alarmData);
        if (dayOffList.isNotEmpty) {
          while(dayOffList[0].dayOffDate.isBefore(alarmData.alarmDateTime)){
            var deletedDayOff2 = dayOffList.removeAt(0);
            deletedDayOff2.dayOffDate = deletedDayOff2.dayOffDate.subtract(Duration(
                hours: hours, minutes: minutes
            ));
            alarmProvider.deleteDayOff(deletedDayOff2.id, deletedDayOff2.dayOffDate);
            if(dayOffList.isEmpty){
              break;
            }
          }
        }
      }
    }
    return alarmData;
  }

  Future<void> updateAlarm(AlarmData alarmData)async {
    AlarmProvider alarmProvider = AlarmProvider();

    alarmData = await updateAlarmWhenAlarmed(alarmData);
    alarmData = await skipDayOff(alarmData);
    await alarmProvider.updateAlarm(alarmData);
  }
}
