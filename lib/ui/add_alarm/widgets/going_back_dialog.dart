import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import '../../global/recent_alarm_date_stream_controller.dart';

class GoingBackDialog extends StatelessWidget {
  String buttonName;
  String system = 'system';
  String appBar = 'appBar';

  GoingBackDialog(this.buttonName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor:
            Get.find<ColorController>().colorSet.topBackgroundColor,
        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        content: SizedBox(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(LocaleKeys.leaveWithoutSaving.tr()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text(
                      LocaleKeys.cancel.tr(),
                      style: const TextStyle(color: Colors.grey),
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
                      Get.find<RecentAlarmDateStreamController>()
                          .dateStreamSubscription
                          .resume();
                      if (buttonName == system) {
                        Get.back(result: true);
                      } else if (buttonName == appBar) {
                        Get.back(result: true);
                        Get.back(result: true);
                      } else {
                        assert(false, 'buttonName error in GoingBackDialog');
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
