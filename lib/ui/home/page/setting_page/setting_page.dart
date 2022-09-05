import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/widgets/align_button.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/widgets/battery_optimization_button.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/widgets/language_button.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/widgets/reset_button.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/widgets/set_home_folder_button.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/widgets/stabilization_button.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/widgets/theme_button.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:get/get.dart' hide Trans;
import '../../../global/color_controller.dart';

class SettingPage extends StatelessWidget {
  String nextAlarmTimeDifferenceText = LocaleKeys.allAlarmsAreOff.tr();
  String nextAlarmTimeText = '';
  String? nextAlarmTitle;

  List<Widget> settingButtons = [
    StabilizationButton(),
    SetHomeFolderButton(),
    AlignButton(),
    LanguageButton(),
    BatteryOptimizationButton(),
    ThemeButton(),
    ResetButton(),
  ];

  SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          textTheme: TextTheme(
              titleLarge: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontSize: 16,
                  color: Get.find<ColorController>().colorSet.mainTextColor,
                  fontFamily: MyFontFamily.mainFontFamily))),
      child: Scaffold(
        backgroundColor: Get.find<ColorController>().colorSet.backgroundColor,
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
                      fontFamily: MyFontFamily.mainFontFamily,
                      color:
                          Get.find<ColorController>().colorSet.mainTextColor),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: settingButtons.length,
                  itemBuilder: (context, index) {
                    return settingButtons[index];
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 12.5,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
