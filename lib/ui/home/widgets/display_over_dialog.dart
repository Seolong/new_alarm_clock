import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import '../../global/color_controller.dart';
import '../home_page.dart';

class DisplayOverDialog extends StatelessWidget {
  DialogStateSharedPreference dialogStateSharedPreference;
  bool isFromButton;

  DisplayOverDialog(this.dialogStateSharedPreference,
      {Key? key, this.isFromButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor:
        Get.find<ColorController>().colorSet.appBarContentColor,
        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        title: Text(LocaleKeys.warning.tr()),
        titleTextStyle: TextStyle(
          //컬러 테마별로 설정하기!!!
            color: Get.find<ColorController>().colorSet.mainTextColor,
            fontSize: 20),
        content: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '앱이 꺼져있을 때에도 알람 시간이 되면 알람을 울리기 위해, '
                    '\'다른 앱 위에 표시\' 권한을 허용해야 합니다. \'설정하기\' 버튼을 누르고'
                    ' 권한을 허용해주세요',
                style: TextStyle(
                    height: 1.5,
                    color: Get.find<ColorController>().colorSet.mainTextColor,
                    fontSize: 14),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: isFromButton == false
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(
                      isFromButton == false
                          ? LocaleKeys.dontShowMeAgain.tr()
                          : LocaleKeys.cancel.tr(),
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    onPressed: () {
                      dialogStateSharedPreference.setIsDontAskValue(true);
                      Get.back(result: false);
                    },
                    // ** result: returns this value up the call stack **
                  ),
                  TextButton(
                    child: Text(
                      LocaleKeys.set.tr(),
                      style: const TextStyle(fontSize: 14),
                    ),
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
