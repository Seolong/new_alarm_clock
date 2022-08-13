import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/widgets/align_button.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/widgets/language_button.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/widgets/reset_button.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/widgets/set_home_folder_button.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

class SettingPage extends StatelessWidget {
  String nextAlarmTimeDifferenceText = LocaleKeys.allAlarmsAreOff.tr();
  String nextAlarmTimeText = '';
  String? nextAlarmTitle;

  List<Widget> settingButtons = [
    SetHomeFolderButton(),
    AlignButton(),
    LanguageButton(),
    ResetButton(),
  ];

  @override
  Widget build(BuildContext context) {
    int? folderCrossAxisCount = Get.width ~/ 100;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              height: 150,
              alignment: Alignment.center,
              child: Text(
                LocaleKeys.moreOptions.tr(),
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: MyFontFamily.mainFontFamily),
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: settingButtons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: folderCrossAxisCount != 0
                        ? folderCrossAxisCount
                        : 1, //1 개의 행에 보여줄 item 개수
                    mainAxisSpacing: 10, //수평 Padding
                    crossAxisSpacing: 10, //수직 Padding
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return settingButtons[index];
                  }),
            )
          ],
        ),
      ),
    );
  }
}
