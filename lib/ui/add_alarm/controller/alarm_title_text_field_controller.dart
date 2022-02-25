import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';

class AlarmTitleTextFieldController extends GetxController {
  TextEditingController textEditingController = TextEditingController();
  AlarmProvider _alarmProvider = AlarmProvider();

  @override
  void onInit() {
    //이걸 해야 입력 시 바로바로 클리어 버튼 생김
    textEditingController.addListener(() {
      update();
    });
    super.onInit();
  }


  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }

  Future<void> initTitleTextField(int alarmId) async {
    AlarmData alarmData = await _alarmProvider.getAlarmById(alarmId);
    textEditingController.text =
        alarmData.title != null ? alarmData.title! : '';
  }

  void resetField() {
    textEditingController.clear();
    update();
  }
}
