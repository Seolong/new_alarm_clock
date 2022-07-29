import 'dart:core';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:jiffy/jiffy.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/model/alarm_week_repeat_data.dart';
import 'package:new_alarm_clock/main.dart';
import 'package:new_alarm_clock/service/date_time_calculator.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import '../../../data/shared_preferences/settings_shared_preferences.dart';
import '../../../service/alarm_scheduler.dart';

class AlarmListController extends GetxController {
  AlarmProvider alarmProvider = AlarmProvider();
  late Future<List<AlarmData>> alarmFutureList;
  List<AlarmData> alarmList = [];
  AlarmProvider _alarmProvider = AlarmProvider();
  SettingsSharedPreferences _settingsSharedPreferences =
      SettingsSharedPreferences();
  AlarmScheduler _alarmScheduler = AlarmScheduler();

  @override
  void onInit() async {
    alarmProvider.initializeDatabase();
    alarmFutureList = alarmProvider.getAllAlarms();
    alarmList = await alarmFutureList;
    await Jiffy.locale(LocaleKeys.locale.tr());
    if (appState == 'main') {
      //자꾸 alarmalarm에서 초기화해서 날짜 한번 더 밀어버려서 만듦
      for (AlarmData alarmData in alarmList) {
        if (alarmData.alarmState == true &&
            alarmData.alarmDateTime.isBefore(DateTime.now())) {
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
                monthRepeatDay: alarmData.monthRepeatDay,
                yearRepeatDay: alarmData.alarmDateTime);
          }
          updateAlarm(alarmData);
        }
      }
    }
    await sortAlarm();
    update(); //이걸 안 해서 futurebuilder로 승부봤었다.
    super.onInit();
  }

  Future<void> sortAlarm() async {
    var settingsSharedPreferences = SettingsSharedPreferences();

    if (await settingsSharedPreferences.getAlignValue() ==
        settingsSharedPreferences.alignByDate) {
      //날짜순 정렬일 때
      alarmList.sort((a, b) => a.alarmDateTime.compareTo(b.alarmDateTime));
    } else {
      alarmList.sort((a, b) => a.alarmOrder.compareTo(b.alarmOrder));
    }
    update();
  }

  void inputAlarm(AlarmData alarmData) async {
    await alarmProvider.insertAlarm(alarmData);
    AlarmScheduler().newShot(alarmData.alarmDateTime, alarmData.id);
    String alignValue =  await _settingsSharedPreferences.getAlignValue();
    //List에 없을 때만 List에 넣는다
    if (alignValue == _settingsSharedPreferences.alignBySetting) {
      if (!alarmList.any((e) => e.id == alarmData.id)) {
        alarmList.add(alarmData);
      }
    }
    else {
      if (alarmList.any((e) => e.id == alarmData.id)) {
        return;
      }
      int i;
      for(i=0; i<alarmList.length; i++){
        if (alarmData.alarmDateTime.isBefore(alarmList[i].alarmDateTime)
        || alarmData.alarmDateTime.isAtSameMomentAs(alarmList[i].alarmDateTime)) {
          alarmList.insert(i, alarmData);
          break;
        }
      }
      if(i>=alarmList.length){
        alarmList.add(alarmData);
      }
    }

    update();
  }

  void deleteAlarm(int id) {
    AlarmScheduler.removeAlarm(id);
    alarmList.removeWhere((element) => element.id == id);
    update();
  }

  Future<void> updateAlarm(AlarmData alarmData) async {
    await alarmProvider.updateAlarm(alarmData);
    AwesomeNotifications().cancel(alarmData.id);
    AndroidAlarmManager.cancel(alarmData.id);
    await AlarmScheduler().newShot(alarmData.alarmDateTime, alarmData.id);
    alarmList[alarmList.indexWhere((element) => alarmData.id == element.id)] =
        alarmData;
    print('AlarmListController: updateAlarm');
    update();
  }

  Future<void> reorderAlarmInDB(
      List<AlarmData> alarmListInDB, int oldIndex, int newIndex) async {
    //옮길 때 alarmState가 이전 상태로 되돌아가는 것을 막기 위함.
    alarmListInDB = await alarmProvider.getAllAlarms();

    int newIndexAlarmOrder = alarmListInDB[newIndex].alarmOrder;
    if (newIndex < oldIndex) {
      for (int i = newIndex; i < oldIndex; i++) {
        alarmListInDB[i].alarmOrder = alarmListInDB[i + 1].alarmOrder;
        await alarmProvider.updateAlarm(alarmListInDB[i]);
        _alarmScheduler.cancelAlarm(alarmListInDB[i].id);
        await AlarmScheduler()
            .newShot(alarmListInDB[i].alarmDateTime, alarmListInDB[i].id);
      }
    } else if (newIndex > oldIndex) {
      for (int i = newIndex; i > oldIndex; i--) {
        alarmListInDB[i].alarmOrder = alarmListInDB[i - 1].alarmOrder;
        await alarmProvider.updateAlarm(alarmListInDB[i]);
        _alarmScheduler.cancelAlarm(alarmListInDB[i].id);
        await AlarmScheduler()
            .newShot(alarmListInDB[i].alarmDateTime, alarmListInDB[i].id);
      }
    } else {
      assert(false,
          'oldIndex and newIndex cannot be same (in AlarmListController)');
    }
    alarmListInDB[oldIndex].alarmOrder = newIndexAlarmOrder;
    await alarmProvider.updateAlarm(alarmListInDB[oldIndex]);
    _alarmScheduler.cancelAlarm(alarmListInDB[oldIndex].id);
    await AlarmScheduler().newShot(
        alarmListInDB[oldIndex].alarmDateTime, alarmListInDB[oldIndex].id);

    alarmList = await alarmProvider.getAllAlarms();
  }

  void reorderItem(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex - 1) {
      print('AlarmListController: no index change in alarm order');
      return;
    }

    String alignValue = await _settingsSharedPreferences.getAlignValue();
    if (alignValue == _settingsSharedPreferences.alignByDate) {
      _settingsSharedPreferences
          .setAlignValue(_settingsSharedPreferences.alignBySetting);
    }

    if (newIndex > alarmList.length) {
      print('AlarmListController: 옮긴 위치가 alarmList 길이보다 클 수 없습니다.');
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
