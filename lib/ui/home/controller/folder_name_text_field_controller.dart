import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

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
      return LocaleKeys.inputFolderName.tr();
    } else {
      if (_isError == true) {
        return LocaleKeys.sameNameFolderExist.tr();
      } else {
        return null;
      }
    }
  }
}
