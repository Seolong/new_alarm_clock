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
        borderRadius: 100.0,
        backgroundColor: Colors.grey[200]!,
        snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.all(10.0),
      boxShadows: [
        BoxShadow(
            blurRadius: 2.0,
          color: Colors.grey[500]!
        )
      ]
    );
  }
}