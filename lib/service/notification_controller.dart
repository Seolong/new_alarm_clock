import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:get/get.dart';
import '../main.dart';
import '../utils/values/string_value.dart';
import 'alarm_scheduler.dart';

class NotificationController {
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == StringValue.skipButtonKey) {
      AlarmProvider alarmProvider = AlarmProvider();
      AlarmScheduler alarmScheduler = AlarmScheduler();
      String idString = receivedAction.payload![StringValue.id]!;
      int id = int.parse(idString);
      appState = 'notification';
      AlarmData alarmData = await alarmProvider.getAlarmById(id);
      await alarmScheduler.updateToNextAlarm(alarmData);
      if (kDebugMode) {
        print('NotificationController: ${alarmData.alarmDateTime}');
      }
      try {
        await Get.find<AlarmListController>().updateAlarm(alarmData);
      } catch (e) {
        if (kDebugMode) {
          print('NotificationController: $e');
        }
      }
      appState = 'main';
    } else {
      if (kDebugMode) {
        print(receivedAction.payload);
      } //notification was pressed
    }
  }
}
