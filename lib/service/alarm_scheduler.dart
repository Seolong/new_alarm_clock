import 'dart:async';
import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/shared_preferences/app_state_shared_preferences.dart';
import 'package:new_alarm_clock/data/shared_preferences/id_shared_preferences.dart';

import '../main.dart';

class AlarmScheduler {

  static void removeAlarm(int alarmId){
    print('removed Alarm id in AlarmManager: $alarmId');
    AndroidAlarmManager.cancel(alarmId);
  }

  /*
    To wake up the device and run something on top of the lockscreen,
    this currently requires the hack from here to be implemented:
    https://github.com/flutter/flutter/issues/30555#issuecomment-501597824
  */

  static void callback(int alarmId) async {
    final AppStateSharedPreferences _appStateSharedPreferences = AppStateSharedPreferences();
    await _appStateSharedPreferences.setAppStateToAlarm();

    final IdSharedPreferences _idSharedPreferences = IdSharedPreferences();
    await _idSharedPreferences.setAlarmedId(alarmId);

    print('Creating a new alarm flag for ID $alarmId');
    createAlarmFlag(alarmId);
  }

  /// Creates a flag file that the main isolate can find on life cycle change
  /// For now just abusing the FileProxy class for testing
  static void createAlarmFlag(int id) async {
    print('Creating a new alarm flag for ID $id');
    AlarmProvider _alarmProvider = AlarmProvider();
    AlarmData alarm = await _alarmProvider.getAlarmById(id);

    if (alarm.alarmState && Platform.isAndroid) {
      restartApp();
      Bringtoforeground.bringAppToForeground();
      return;
    }
  }

  Future<void> newShot(DateTime targetDateTime, int id) async {
    print('insert Alarm with Scheduler');
    print(targetDateTime);
    await AndroidAlarmManager.oneShotAt(targetDateTime, id, callback,
        alarmClock: true, rescheduleOnReboot: true,
        allowWhileIdle: true, wakeup: true);
  }
}
