import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/service/call_native_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dnd/flutter_dnd.dart';

class PermissionController extends GetxController {
  final WarningSharedPreference warningSharedPreference =
      WarningSharedPreference();
  bool _isDisplayOverOn = false;
  bool _isBatteryOptimizationOff = false; //false여야 좋은 거다
  bool _isDoNotDisturb = false;
  final String displayOver = 'displayOver';
  final String batteryOptimization = 'batteryOptimization';
  final String doNotDisturb = 'doNotDisturb';

  @override
  void onInit() async {
    await checkPermission();
    super.onInit();
  }

  bool get isDisplayOverOn => _isDisplayOverOn;

  set isDisplayOverOn(bool value) {
    _isDisplayOverOn = value;
    update();
  }

  bool get isBatteryOptimizationOff => _isBatteryOptimizationOff;

  set isBatteryOptimizationOff(bool value) {
    _isBatteryOptimizationOff = value;
    update();
  }

  bool get isDoNotDisturb => _isDoNotDisturb;

  set isDoNotDisturb(bool value) {
    _isDoNotDisturb = value;
    update();
  }

  bool getBoolByName(String name) {
    if (name == displayOver) {
      return _isDisplayOverOn;
    } else if (name == batteryOptimization) {
      return _isBatteryOptimizationOff;
    } else if (name == doNotDisturb) {
      return _isDoNotDisturb;
    } else {
      assert(false, 'PermissionController: getBoolByName error!');
      return false;
    }
  }

  VoidCallback getOnSetPressedByName(String name) {
    if (name == displayOver) {
      return () {};
    } else if (name == batteryOptimization) {
      return () {};
    } else if (name == doNotDisturb) {
      return () {
        FlutterDnd.gotoPolicySettings();
      };
    } else {
      assert(false, 'PermissionController: getOnSetPressedByName error!');
      return () {};
    }
  }

  Future<void> checkPermission() async {
    _isDisplayOverOn = await CallNativeService().checkDisplayOverPermission();
    _isBatteryOptimizationOff =
        await CallNativeService().checkBatteryOptimizations();
    _isDoNotDisturb = (await FlutterDnd.isNotificationPolicyAccessGranted)!;
    update();
  }
}

class WarningSharedPreference {
  static final WarningSharedPreference _instance =
      WarningSharedPreference._internal();
  late SharedPreferences sharedPreferences;
  final String isIgnore = 'isIgnore';

  factory WarningSharedPreference() {
    return _instance;
  }

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();

    bool? isOpenValue = sharedPreferences.getBool(isIgnore);
    if (isOpenValue == null) {
      sharedPreferences.setBool(isIgnore, false);
    }
  }

  WarningSharedPreference._internal();

  Future<bool> getIsIgnoreValue() async {
    await init();
    return sharedPreferences.getBool(isIgnore)!;
  }

  Future<void> setIsIgnoreValue(bool isIgnoreValue) async {
    await init();
    sharedPreferences.setBool(isIgnore, isIgnoreValue);
  }
}
