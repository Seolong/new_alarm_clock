import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/service/music_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:get/get.dart';
import '../ui/global/recent_alarm_date_stream_controller.dart';

class LifeCycleListener extends WidgetsBindingObserver {
  MusicHandler _musicHandler = MusicHandler();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        Vibration.cancel();
        _musicHandler.stopMusic();
        Get.find<RecentAlarmDateStreamController>().dateStreamSubscription.pause();
        await AwesomeNotifications().resetGlobalBadge();
        break;
      case AppLifecycleState.detached:
        Vibration.cancel();
        _musicHandler.stopMusic();
        Get.find<RecentAlarmDateStreamController>().dateStreamSubscription.cancel();
        await AwesomeNotifications().resetGlobalBadge();
        break;
      case AppLifecycleState.resumed:
        Get.find<RecentAlarmDateStreamController>().dateStreamSubscription.resume();
        break;
      default:
        print("Updated lifecycle state: $state");
    }
  }
}
