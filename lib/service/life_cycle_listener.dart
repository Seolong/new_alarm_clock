import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:vibration/vibration.dart';
import 'package:get/get.dart';

class LifeCycleListener extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        Vibration.cancel();
        Get.find<RingRadioListController>().musicHandler.stopMusic();
        break;
      case AppLifecycleState.resumed:
        break;
      default:
        print("Updated lifecycle state: $state");
    }
  }
}
