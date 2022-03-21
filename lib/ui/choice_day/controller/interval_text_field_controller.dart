import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class IntervalTextFieldController extends GetxController {
  TextEditingController textEditingController = TextEditingController();
  RxInt _interval = 0.obs;

  set interval(int intervalValue) {
    _interval = intervalValue.obs;
    update();
  }

  int get interval => _interval.value;

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

  void initTextFieldInEditRepeat(int intervalValue) {
    _interval = intervalValue.obs;
    textEditingController.text =
        _interval.value != 0 ? '${_interval.value}' : '';
  }
}
