import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedAlarmController extends GetxController{
  Map<int, Color> colorMap = Map<int, Color>();
  RxBool _isSelectedMode = false.obs;

  set isSelectedMode(bool value){
    _isSelectedMode.value = value;
    update();
  }
  bool get isSelectedMode => _isSelectedMode.value;
}