import 'package:flutter/material.dart';
import 'package:new_alarm_clock/service/music_handler.dart';
import 'package:vibration/vibration.dart';

class LifeCycleListener extends WidgetsBindingObserver {
  MusicHandler _musicHandler = MusicHandler();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        Vibration.cancel();
        _musicHandler.stopMusic();
        break;
      case AppLifecycleState.resumed:
        break;
      default:
        print("Updated lifecycle state: $state");
    }
  }
}
