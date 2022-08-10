import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ConvenienceMethod{
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