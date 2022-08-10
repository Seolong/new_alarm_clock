import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/vibration_Pack.dart';
import 'package:vibration/vibration.dart';

import '../../../global/color_controller.dart';

class VibrationRadioListController extends GetxController{
  VibrationPack _vibrationPack = VibrationPack();
  VibrationName _selectedVibration = VibrationName.long; //알람 수정이면 db에서 가져오고 알람 추가면 default 값으로 VibrationName.long으로
  bool _power = true;//DB에서 가져오기
  Map<String, Color> textColor = {
    'active': Get.find<ColorController>().colorSet.mainTextColor,
    'inactive': Colors.grey
  };

  VibrationName get selectedVibration => _selectedVibration;

  set selectedVibration(VibrationName selectedVibration) {
    _selectedVibration = selectedVibration;
    _vibrationPack.vibrateByVibrationName(selectedVibration);
    update();
  }

  bool get power => _power;

  set power(bool value){
    _power = value;
    //switch가 안 움직이면 대개 update()를 빼먹어서다.
    update();
  }

  void initSelectedVibrationInEdit(VibrationName selectedVibration){
    _selectedVibration = selectedVibration;
    update();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    Vibration.cancel();
    super.onClose();
  }
}