import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';

class SelectedAlarmController extends GetxController{
  Map<int, bool> selectedMap = Map<int, bool>();
  Map<int, Color> colorMap = Map<int, Color>();
  RxBool _isSelectedMode = false.obs;

  set isSelectedMode(bool value){
    _isSelectedMode.value = value;
    update();
  }
  bool get isSelectedMode => _isSelectedMode.value;

  void changeAlarmColor(int id){
    if(selectedMap[id] == false){
      selectedMap[id] = true;
      colorMap[id] = Colors.grey;
    }
    else if(selectedMap[id] == true){
      selectedMap[id] = false;
      colorMap[id] = ColorValue.alarm;
    }
    else{
      log('error in changeAlarmColor');
    }
    update();
  }

  void backToOriginalColor(){
    //전부 알람색으로 바꾸기
    update();
  }
}