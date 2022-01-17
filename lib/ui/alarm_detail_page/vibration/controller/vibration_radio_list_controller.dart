import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/vibration_Pack.dart';
import 'package:vibration/vibration.dart';

class VibrationRadioListController extends GetxController{
  VibrationPack _vibrationPack = VibrationPack();
  VibrationName _selectedVibration = VibrationName.long; //알람 수정이면 db에서 가져오고 알람 추가면 default 값으로 VibrationName.long으로
  RxBool _power = false.obs;//DB에서 가져오기
  Map<String, Color> textColor = {
    'active': Colors.black,
    'inactive': Colors.grey
  };
  RxMap<String, Color> _listTextColor = {'text': Colors.black}.obs;

  set selectedVibration(VibrationName selectedVibration) {
    _selectedVibration = selectedVibration;
    _vibrationPack.vibrateByVibrationName(selectedVibration); //재부팅 후 잘 적용됐나 확인, 진동 잘 울리나 테스트
    update();
  }

  VibrationName get selectedVibration => _selectedVibration;

  set power(bool value){
    _power(value);
    //switch가 안 움직이면 대개 update()를 빼먹어서다.
    update();
  }

  bool get power => _power.value;

  set listTextColor(Color color){
    _listTextColor['text'] = color;
    update();
  }

  Color get listTextColor => _listTextColor['text']!;

  @override
  void onClose() {
    // TODO: implement onClose
    Vibration.cancel();
    super.onClose();
  }
}