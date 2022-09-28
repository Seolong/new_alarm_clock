import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:io' show Platform;
import '../../../data/database/alarm_provider.dart';
import '../../../data/model/alarm_data.dart';
import '../../../data/shared_preferences/app_state_shared_preferences.dart';
import '../../../data/shared_preferences/id_shared_preferences.dart';
import '../../../data/shared_preferences/repeat_count_shared_preferences.dart';
import '../../../service/alarm_scheduler.dart';
import '../../../service/music_handler.dart';

class AlarmAlarmController {
  final AppStateSharedPreferences _appStateSharedPreferences =
      AppStateSharedPreferences();
  final IdSharedPreferences _idSharedPreferences = IdSharedPreferences();
  final RepeatCountSharedPreferences _repeatCountSharedPreferences =
      RepeatCountSharedPreferences();
  final AlarmProvider _alarmProvider = AlarmProvider();
  final MusicHandler _musicHandler = MusicHandler();
  final AlarmScheduler alarmScheduler = AlarmScheduler();

  //삭제가 아닌 state를 off
  Future<void> offAlarmWithButton() async {
    int alarmId = await _idSharedPreferences.getAlarmedId();
    AlarmData alarmData = await _alarmProvider.getAlarmById(alarmId);

    await _repeatCountSharedPreferences.resetRepeatCount();
    await alarmScheduler.updateToNextAlarm(alarmData);

    await _appStateSharedPreferences.setAppStateToMain();
    await Vibration.cancel();
    await _musicHandler.stopMusic();
    await Wakelock.disable();

    //SystemNavigator.pop()하니까 안 될 때가 있더라
    if (Platform.isAndroid) {
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else if (Platform.isIOS) {}
  }

  Future<void> offAlarmWithTimer() async {
    int alarmId = await _idSharedPreferences.getAlarmedId();
    AlarmData alarmData = await _alarmProvider.getAlarmById(alarmId);

    if (alarmData.repeatBool == false) {
      await _repeatCountSharedPreferences.resetRepeatCount();
      await alarmScheduler.updateToNextAlarm(alarmData);
    } else {
      await _repeatCountSharedPreferences.setRepeatCount();
      int repeatCount = await _repeatCountSharedPreferences.getRepeatCount();
      int repeatInterval = alarmData.repeatInterval;
      int repeatNum = alarmData.repeatNum;
      if (repeatCount < repeatNum) {
        DateTime nextAlarmTime = alarmData.alarmDateTime
            .add(Duration(minutes: (repeatCount * repeatInterval)));
        alarmScheduler.newShot(nextAlarmTime, alarmData.id);
      } else {
        await _repeatCountSharedPreferences.resetRepeatCount();
        await alarmScheduler.updateToNextAlarm(alarmData);
      }
    }

    await _appStateSharedPreferences.setAppStateToMain();
    await Vibration.cancel();
    await _musicHandler.stopMusic();
    await Wakelock.disable();

    //SystemNavigator.pop()하니까 안 될 때가 있더라
    if (Platform.isAndroid) {
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else if (Platform.isIOS) {}
  }
}
