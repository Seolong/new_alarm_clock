import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class FolderNameTextFieldController extends GetxController {
  TextEditingController textEditingController = TextEditingController();
  bool _isError = false;

  bool get isError => _isError;

  set isError(bool value) {
    _isError = value;
    update();
  }

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

  String? getErrorText() {
    if (textEditingController.text == '') {
      _isError = false;
      return '폴더 이름을 입력해주세요.';
    } else {
      if (_isError == true) {
        return '이미 같은 이름의 폴더가 있습니다.';
      } else {
        return null;
      }
    }
  }
}
