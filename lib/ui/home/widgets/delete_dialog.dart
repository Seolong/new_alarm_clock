import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

import '../../global/color_controller.dart';

class DeleteDialog extends StatelessWidget {
  String message;

  DeleteDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor:
            Get.find<ColorController>().colorSet.topBackgroundColor,
        contentPadding: EdgeInsets.fromLTRB(22.5, 22.5, 22.5, 0),
        content: Container(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                message,
                style: TextStyle(
                    color: Get.find<ColorController>().colorSet.mainTextColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text(
                      LocaleKeys.cancel.tr(),
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      Get.back(result: false);
                    },
                    // ** result: returns this value up the call stack **
                  ),
                  Container(
                    width: 1,
                    height: 15,
                    color: Colors.grey,
                  ),
                  TextButton(
                    child: Text(LocaleKeys.okay.tr()),
                    onPressed: () {
                      Get.back(result: true);
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
