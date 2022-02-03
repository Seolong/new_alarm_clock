// import 'dart:async';
// import 'dart:io';
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:bringtoforeground/bringtoforeground.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:new_alarm_clock/data/database/alarm_provider.dart';
// import 'package:new_alarm_clock/data/model/alarm_data.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:clockee/services/file_proxy.dart'; //DB나 DAO 역할을 하는 듯
// import 'package:clockee/stores/observable_alarm/observable_alarm.dart';
//
// class AlarmScheduler {
//   AlarmProvider _alarmProvider = AlarmProvider();
//
//   /*
//     To wake up the device and run something on top of the lockscreen,
//     this currently requires the hack from here to be implemented:
//     https://github.com/flutter/flutter/issues/30555#issuecomment-501597824
//   */
//   Future<void> scheduleAlarm(int id) async {
//     final days = alarm.days;
//
//     AlarmData alarmData = await _alarmProvider.getAlarmById(id);
//
//     //이 사람은 한 알람당 아이디를 7개를 배정해서
//     //0~6까지 일월화수목금토 이렇게 배정한 것 같다...?
//
//
//     if(alarmData.alarmState == true){
//       switch(alarmData.alarmType){
//
//       }
//     }
//
//     bool repeatAlarm = false;
//     for (var i = 0; i < days.length; i++) {
//       await AndroidAlarmManager.cancel(scheduleId + i);
//       print("alarm.active: ${alarm.active}");
//       print("days[$i]: ${days[i]}");
//       if (alarm.active! && days[i]) {
//         // Repeat alarm
//         print("Alarm active for day $i");
//         repeatAlarm = true;
//         final targetDateTime = nextWeekday(i + 1, alarm.hour!, alarm.minute!);
//         await newShot(targetDateTime, scheduleId + i);
//       } else if (alarm.active! && !repeatAlarm && i == days.length - 1) {
//         // One time alarm
//         var checkedDay = DateTime.now();
//         var targetDateTime = DateTime(checkedDay.year, checkedDay.month,
//             checkedDay.day, alarm.hour!, alarm.minute!);
//
//         if (targetDateTime.millisecondsSinceEpoch <
//             checkedDay.millisecondsSinceEpoch) // Time past?
//           targetDateTime =
//               targetDateTime.add(Duration(days: 1)); // Prepare for next day
//
//         print("targetDateTime ${targetDateTime.toString()}");
//         await newShot(targetDateTime, scheduleId + i);
//       }
//     }
//   }
//
//   DateTime nextWeekday(int weekday, alarmHour, alarmMinute) {
//     var checkedDay = DateTime.now();
//
//     if (checkedDay.weekday == weekday) {
//       final todayAlarm = DateTime(checkedDay.year, checkedDay.month,
//           checkedDay.day, alarmHour, alarmMinute);
//
//       if (checkedDay.isBefore(todayAlarm)) {
//         return todayAlarm;
//       }
//       return todayAlarm.add(Duration(days: 7));
//     }
//
//     while (checkedDay.weekday != weekday) {
//       checkedDay = checkedDay.add(Duration(days: 1));
//     }
//
//     return DateTime(checkedDay.year, checkedDay.month, checkedDay.day,
//         alarmHour, alarmMinute);
//   }
//
//   static void callback(int id) async {
//     final alarmId = callbackToAlarmId(id);
//
//     createAlarmFlag(alarmId);
//   }
//
//   /// Because each alarm might need to be able to schedule up to 7 android alarms (for each weekday)
//   /// a means is required to convert from the actual callback ID to the ID of the alarm saved
//   /// in internal storage. To do so, we can assign a range of 7 per alarm and use ceil to get to
//   /// get the alarm ID to access the list of songs that could be played
//   static int callbackToAlarmId(int callbackId) {
//     return (callbackId / 7).floor();
//   }
//
//   /// Creates a flag file that the main isolate can find on life cycle change
//   /// For now just abusing the FileProxy class for testing
//   static void createAlarmFlag(int id) async {
//     print('Creating a new alarm flag for ID $id');
//     final dir = await getApplicationDocumentsDirectory();
//     JsonFileStorage.toFile(File(dir.path + "/$id.alarm")).writeList([]);
//
//     final alarms = await new JsonFileStorage().readList();
//     var alarm = alarms.firstWhere((element) => element.id == id);
//
//     if (alarm.active! && Platform.isAndroid) {
//       restartApp();
//       Bringtoforeground.bringAppToForeground();
//       return;
//     }
//     final hours = alarm.hour.toString().padLeft(2, '0'); // 7시면 07시로 바꾸는
//     final minutes = alarm.minute.toString().padLeft(2, '0');
//
//     await notifications.init(onSelectNotification: (String? payload) async {
//       // if (payload == null || payload.trim().isEmpty) return null;
//       print('notification payload $payload');
//       throw Exception('New Notification');
//       // return;
//     });
//
//     await notifications.getNotificationAppLaunchDetails().then((details) {
//       notificationAppLaunchDetails = details;
//     });
//
//     notifications.show(
//       id: id,
//       icon: 'notification_logo',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//       title: '$hours:$minutes',
//       body: alarm.name,
//       sound: RawResourceAndroidNotificationSound(''),
//       payload: id.toString(),
//     );
//   }
//
//   Future<void> newShot(DateTime targetDateTime, int id) async {
//     await AndroidAlarmManager.oneShotAt(targetDateTime, id, callback,
//         alarmClock: true, rescheduleOnReboot: true);
//   }
// }
