import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import '../../../global/color_controller.dart';

class BookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.find<ColorController>().colorSet.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.bibleContent.tr(),
                style: TextStyle(
                    height: 1.4,
                    fontSize: 16,
                    color: Get.find<ColorController>().colorSet.mainTextColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  LocaleKeys.bibleIndex.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.grey),
                ),
              )
            ],
          ),
        ));
  }
}
