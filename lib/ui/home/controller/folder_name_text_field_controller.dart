import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class FolderNameTextFieldController extends GetxController{
  TextEditingController textEditingController = TextEditingController();

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    //이걸 해야 입력 시 바로바로 클리어 버튼 생김
    textEditingController.addListener(() {
      update();
    });

    super.onInit();
  }

  void resetField() {
    textEditingController.clear();
    update();
  }
}