import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlarmSkipButtonController extends GetxController{
  RxMap<int, bool> powerMap = Map<int, bool>().obs;

  void reverseState(int id){
    if(powerMap[id] == true){
      powerMap[id] = false;
    }
    else{
      powerMap[id] = true;
    }
    update();
  }
}