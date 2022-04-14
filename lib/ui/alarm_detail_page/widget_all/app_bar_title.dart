import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:get/get.dart';

class AppBarTitle extends StatelessWidget {
  String title;

  AppBarTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Get.statusBarHeight * 3 / 7,
        alignment: Alignment.bottomLeft,
        child: AutoSizeText(title));
  }
}
