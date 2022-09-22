import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

import '../../global/color_controller.dart';

class ChooseActionDialog extends StatelessWidget {

  const ChooseActionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor:
        Get.find<ColorController>().colorSet.topBackgroundColor,
        contentPadding: const EdgeInsets.fromLTRB(12.5, 0, 12.5, 0),
        content: SizedBox(
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                child: Text(
                  LocaleKeys.edit.tr()
                ),
                onPressed: () {
                  Get.back(result: true);
                },
              ),
              OutlinedButton(
                child: Text(LocaleKeys.delete.tr()),
                onPressed: () {
                  Get.back(result: false);
                },
              ),
            ],
          ),
        ));
  }
}
