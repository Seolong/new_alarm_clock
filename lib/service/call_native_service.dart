import 'package:flutter/services.dart';

class CallNativeService{
  static const androidChannel = const MethodChannel('intent/permission');

  Future<bool> checkBatteryOptimizations()async {
    return await androidChannel.invokeMethod('checkBatteryOptimizations');
  }

  Future<void> setBatteryOptimizations()async {
    await androidChannel.invokeMethod('setBatteryOptimizations');
  }

  Future<void> setDisplayOverPermission()async{
    await androidChannel.invokeMethod('setDisplayOverPermission');
  }
}