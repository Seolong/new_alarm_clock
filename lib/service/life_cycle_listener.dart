import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/shared_preferences/app_state_shared_preferences.dart';
import 'package:new_alarm_clock/service/music_handler.dart';
import 'package:vibration/vibration.dart';

class LifeCycleListener extends WidgetsBindingObserver {
  MusicHandler _musicHandler = MusicHandler();
  AppStateSharedPreferences _appStateSharedPreferences = AppStateSharedPreferences();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        Vibration.cancel();
        _musicHandler.stopMusic();
        await AwesomeNotifications().resetGlobalBadge();
        await _appStateSharedPreferences.setAppStateToMain();
        break;
      case AppLifecycleState.detached:
        Vibration.cancel();
        _musicHandler.stopMusic();
        await AwesomeNotifications().resetGlobalBadge();
        await _appStateSharedPreferences.setAppStateToAlarm();
        break;
      case AppLifecycleState.resumed:
        await _appStateSharedPreferences.setAppStateToMain();
        break;
      default:
        print("Updated lifecycle state: $state");
    }
  }
}
