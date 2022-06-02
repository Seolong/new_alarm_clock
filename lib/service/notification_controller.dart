import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:get/get.dart';
import '../main.dart';
import 'alarm_scheduler.dart';

class NotificationController{
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
    if(receivedAction.buttonKeyPressed == 'skip_once'){
      AlarmProvider alarmProvider = AlarmProvider();
      AlarmScheduler alarmScheduler = AlarmScheduler();
      //runApp(MyApp());
      //Get.toNamed(AppRoutes.home);
      //MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(AppRoutes.home, (route) => (route.settings.name != AppRoutes.home) || route.isFirst);
      //Get.put(AlarmListController());
      String id_string = receivedAction.payload!['id']!;
      int id = int.parse(id_string);
      appState = 'notification';
      AlarmData alarmData = await alarmProvider.getAlarmById(id);
      await alarmScheduler.updateToNextAlarm(alarmData);
      //alarmData = await alarmScheduler.updateAlarmWhenAlarmed(alarmData);
      print('NotificationController: ${alarmData.alarmDateTime}');
      //await alarmProvider.updateAlarm(alarmData);
      //alarmScheduler.cancelAlarm(alarmData.id);
      //await alarmScheduler.newShot(alarmData.alarmDateTime, alarmData.id);
      try {
        await Get.find<AlarmListController>().updateAlarm(alarmData);
      } catch (e) {
        print('NotificationController: $e');
      }
      appState = 'main';
    }else{
      print(receivedAction.payload); //notification was pressed
    }
  }
}