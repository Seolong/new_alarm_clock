import 'dart:async';
import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:flutter/foundation.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/model/alarm_week_repeat_data.dart';
import 'package:new_alarm_clock/data/shared_preferences/app_state_shared_preferences.dart';
import 'package:new_alarm_clock/data/shared_preferences/id_shared_preferences.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';
import 'package:restart_app/restart_app.dart';
import 'package:easy_localization/easy_localization.dart';

import '../main.dart';
import 'date_time_calculator.dart';

class AlarmScheduler {
  String getTimeWithTwoLetter(int time) {
    if (time < 10) {
      return '0$time';
    } else {
      return '$time';
    }
  }

  void notifyBeforeAlarm(int alarmId) async {
    AlarmProvider alarmProvider = AlarmProvider();
    AlarmData alarmData = await alarmProvider.getAlarmById(alarmId);

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      //no permission of local notification
      AwesomeNotifications().requestPermissionToSendNotifications();
    } else {
      //show notification
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            //simple notification
            id: alarmId,
            channelKey: StringValue.notificationChannelKey,
            //set configuration with key "basic"
            title: LocaleKeys.alarmWillGoOffSoon.tr(),
            body: '${alarmData.title} '
                '${getTimeWithTwoLetter(alarmData.alarmDateTime.hour)}:'
                '${getTimeWithTwoLetter(alarmData.alarmDateTime.minute)}',
            payload: {StringValue.id: '$alarmId'},
            autoDismissible: false,
            //actionType: ActionType.SilentBackgroundAction,
            //category: NotificationCategory.Alarm
          ),
          schedule: NotificationCalendar.fromDate(
              date: alarmData.alarmDateTime
                  .subtract(const Duration(minutes: 30))),
          actionButtons: [
            NotificationActionButton(
              key: StringValue.skipButtonKey,
              label: LocaleKeys.skipOnce.tr(),
              actionType: ActionType.SilentBackgroundAction,
            )
          ]);
    }
  }

  void pushNotifyToEnd(int alarmId) async {
    AlarmProvider alarmProvider = AlarmProvider();
    AlarmData alarmData = await alarmProvider.getAlarmById(alarmId);

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      //no permission of local notification
      AwesomeNotifications().requestPermissionToSendNotifications();
    } else {
      //show notification
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              //simple notification
              id: alarmId,
              channelKey: StringValue.notificationChannelKey,
              //set configuration with key "basic"
              title: '',
              body: '',
              payload: {StringValue.id: '$alarmId'},
              autoDismissible: false,
              actionType: ActionType.SilentBackgroundAction,
              category: NotificationCategory.Alarm),
          schedule: NotificationCalendar.fromDate(
              allowWhileIdle: true,
              date: alarmData.alarmDateTime.add(const Duration(days: 100000))),
          actionButtons: [
            NotificationActionButton(
                key: StringValue.skipButtonKey,
                label: '',
                actionType: ActionType.KeepOnTop)
          ]);
    }
  }

  void cancelAlarm(int id) async {
    await AwesomeNotifications().cancel(id);
    await AndroidAlarmManager.cancel(id);
  }

  static void removeAlarm(int alarmId) {
    AlarmProvider alarmProvider = AlarmProvider();
    if (kDebugMode) {
      print('removed Alarm id in AlarmManager: $alarmId');
    }
    alarmProvider.deleteAlarm(alarmId);
    AwesomeNotifications().cancel(alarmId);
    AndroidAlarmManager.cancel(alarmId);
  }

  static Future<void> removeAllAlarm() async {
    AlarmProvider alarmProvider = AlarmProvider();
    List<AlarmData> alarmList = await alarmProvider.getAllAlarms();
    for (var element in alarmList) {
      AndroidAlarmManager.cancel(element.id);
      alarmProvider.deleteAlarm(element.id);
    }
    AwesomeNotifications().cancelAll();
  }

  /*
    To wake up the device and run something on top of the lockscreen,
    this currently requires the hack from here to be implemented:
    https://github.com/flutter/flutter/issues/30555#issuecomment-501597824
  */

  static void callback(int alarmId) async {
    if (kDebugMode) {
      print('Creating a new alarm flag for ID $alarmId');
    }
    createAlarmFlag(alarmId);
  }

  /// Creates a flag file that the main isolate can find on life cycle change
  /// For now just abusing the FileProxy class for testing
  static void createAlarmFlag(int id) async {
    //print('Creating a new alarm flag for ID $id');
    AlarmProvider alarmProvider = AlarmProvider();
    AlarmData alarm = await alarmProvider.getAlarmById(id);

    if (alarm.alarmState && Platform.isAndroid) {
      final AppStateSharedPreferences appStateSharedPreferences =
          AppStateSharedPreferences();
      await appStateSharedPreferences.setAppStateToAlarm();

      //딱 이거 넣으니까 wakelock에서 예외 메시지 뜨는데
      //작동은 잘만 함
      appState = await appStateSharedPreferences.getAppState();

      final IdSharedPreferences idSharedPreferences = IdSharedPreferences();
      await idSharedPreferences.setAlarmedId(id);

      Restart.restartApp();
      Bringtoforeground.bringAppToForeground();
    }
  }

  Future<void> newShot(DateTime targetDateTime, int id) async {
    if (kDebugMode) {
      print('insert Alarm with Scheduler');
      print(targetDateTime);
    }
    notifyBeforeAlarm(id);
    await AndroidAlarmManager.oneShotAt(targetDateTime, id, callback,
        alarmClock: true,
        rescheduleOnReboot: true,
        allowWhileIdle: true,
        wakeup: true);
  }

  Future<AlarmData> updateAlarmWhenAlarmed(AlarmData alarmData) async {
    AlarmProvider alarmProvider = AlarmProvider();
    //알람 타입이 반복일 때
    if (alarmData.alarmType != RepeatMode.single &&
        alarmData.alarmType != RepeatMode.off) {
      DateTimeCalculator dateTimeCalculator = DateTimeCalculator();

      //말일이면 lastDay 변수 추가해서 처리
      //week이면 weekBool 변수 추가해서 처리
      List<bool> weekBool = [];
      bool lastDay = false;
      if (alarmData.alarmType == RepeatMode.week) {
        AlarmWeekRepeatData? alarmWeekRepeatData =
            await alarmProvider.getAlarmWeekDataById(alarmData.id);
        weekBool.add(alarmWeekRepeatData!.sunday);
        weekBool.add(alarmWeekRepeatData.monday);
        weekBool.add(alarmWeekRepeatData.tuesday);
        weekBool.add(alarmWeekRepeatData.wednesday);
        weekBool.add(alarmWeekRepeatData.thursday);
        weekBool.add(alarmWeekRepeatData.friday);
        weekBool.add(alarmWeekRepeatData.saturday);
      } else if (alarmData.alarmType == RepeatMode.month) {
        if (alarmData.monthRepeatDay == 29) {
          lastDay = true;
        }
      }

      alarmData.alarmDateTime = dateTimeCalculator.addDateTime(
          alarmData.alarmType, alarmData.alarmDateTime, alarmData.alarmInterval,
          weekBool: weekBool, lastDay: lastDay);
      if (kDebugMode) {
        print('print ${alarmData.alarmInterval} in alarm scheduler');
        print(alarmData.alarmDateTime);
      }

      if (alarmData.endDay != null) {
        if (alarmData.alarmDateTime.isAfter(alarmData.endDay!)) {
          alarmData.alarmState = false;
          alarmData.endDay = null;
        }
      }
    } else {
      alarmData.alarmState = false;
    }

    return alarmData;
  }

  Future<AlarmData> skipDayOff(AlarmData alarmData) async {
    AlarmProvider alarmProvider = AlarmProvider();
    var dayOffList = await alarmProvider.getDayOffsById(alarmData.id);
    if (dayOffList.isNotEmpty) {
      int hours = alarmData.alarmDateTime.hour;
      int minutes = alarmData.alarmDateTime.minute;

      void deleteFirstDayOff() {
        var deletedDayOff = dayOffList.removeAt(0);
        //AlarmData.dayOff의 값으로 되돌리는 것
        deletedDayOff.dayOffDate = deletedDayOff.dayOffDate
            .subtract(Duration(hours: hours, minutes: minutes));
        alarmProvider.deleteDayOff(deletedDayOff.id, deletedDayOff.dayOffDate);
      }

      void deleteDayOffsBeforeCurrentAlarm() {
        while (dayOffList.isNotEmpty &&
            dayOffList[0].dayOffDate.isBefore(alarmData.alarmDateTime)) {
          deleteFirstDayOff();
        }
      }

      //AlarmData.dayOff는 ~년 ~월 ~일까지만 나온다. ~시 ~분은 안 쓰여있다.
      for (int i = 0; i < dayOffList.length; i++) {
        dayOffList[i].dayOffDate = dayOffList[i]
            .dayOffDate
            .add(Duration(hours: hours, minutes: minutes));
      }

      dayOffList.sort((a, b) => a.dayOffDate.compareTo(b.dayOffDate));
      deleteDayOffsBeforeCurrentAlarm();

      while (dayOffList.isNotEmpty &&
          alarmData.alarmDateTime.isAtSameMomentAs(dayOffList[0].dayOffDate)) {
        deleteFirstDayOff();
        alarmData = await updateAlarmWhenAlarmed(alarmData);
        deleteDayOffsBeforeCurrentAlarm();
      }
    }
    return alarmData;
  }

  Future<void> updateToNextAlarm(AlarmData alarmData) async {
    AlarmProvider alarmProvider = AlarmProvider();

    alarmData = await updateAlarmWhenAlarmed(alarmData);
    alarmData = await skipDayOff(alarmData);
    if (kDebugMode) {
      print('AlarmScheduler: alarm to ${alarmData.alarmDateTime}');
    }
    await alarmProvider.updateAlarm(alarmData);
    cancelAlarm(alarmData.id);
    await newShot(alarmData.alarmDateTime, alarmData.id);
  }
}
