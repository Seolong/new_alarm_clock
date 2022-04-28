import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ConvenienceMethod{
  Map<String, dynamic> getArgToNextPage(String mode, int alarmId, String folderName){
    Map<String, dynamic> result = {
      StringValue.mode: mode,
      StringValue.alarmId: alarmId,
      StringValue.folderName: folderName
    };
    return result;
  }

  static void showSimpleSnackBar(String message){
    Get.closeAllSnackbars();
    Get.rawSnackbar(
        snackPosition: SnackPosition.BOTTOM,
        messageText: Text(
          message,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        backgroundColor: ColorValue.mainBackground,
        snackStyle: SnackStyle.GROUNDED
    );
  }
}