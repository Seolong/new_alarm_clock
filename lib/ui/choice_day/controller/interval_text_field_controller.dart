import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class IntervalTextFieldController extends GetxController {
  TextEditingController textEditingController = TextEditingController();

  int getInterval() {
    if (textEditingController.text == '') {
      return 1;
    }
    return int.parse(textEditingController.text);
  }

  String getIntervalText() =>
      textEditingController.text == '1' ? '매' : textEditingController.text;

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
    textEditingController.text = intervalValue != 0 ? '$intervalValue' : '';
  }

  void plusOne(){
    if(textEditingController.text == ''){
      textEditingController.text = '1';
      return;
    }
    int currentValue = int.parse(textEditingController.text);
    currentValue++;
    textEditingController.text = '$currentValue';
    update();
  }

  void minusOne(){
    int currentValue = int.parse(textEditingController.text);
    if(textEditingController.text == '' || currentValue <= 0){
      return;
    }
    currentValue--;
    if(currentValue == 0){
      textEditingController.text = '';
      return;
    }
    textEditingController.text = '$currentValue';
    update();
  }
}
