import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedAlarmController extends GetxController {
  Map<int, Color> colorMap = <int, Color>{};
  bool _isSelectedMode = false;

  set isSelectedMode(bool value) {
    _isSelectedMode = value;
    update();
  }

  bool get isSelectedMode => _isSelectedMode;
}
