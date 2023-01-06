import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/data/shared_preferences/settings_shared_preferences.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import '../../../../../utils/values/my_font_family.dart';
import '../../../../global/color_controller.dart';
import '../../../../global/custom_radio_list_tile.dart';

enum AlignEnum { bySet, byDate }

class AlignButton extends StatelessWidget {
  final _settingsSharedPreferences = SettingsSharedPreferences();
  final double buttonHeight = 37.5;
  final double buttonPadding = 7.5;
  final double radioRadius = 7.5;
  late final double borderRadius = radioRadius + 7.5;
  final double borderWidth = 2;
  final Color activeColor = Get.find<ColorController>().colorSet.mainColor;
  AlignEnum initialAlignEnum = AlignEnum.byDate;

  AlignButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      onTap: () async {
        String currentAlign = await _settingsSharedPreferences.getAlignValue();
        AlignEnum initialAlignEnum =
            currentAlign == _settingsSharedPreferences.alignByDate
                ? AlignEnum.byDate
                : AlignEnum.bySet;
        Get.dialog(
          Dialog(
            backgroundColor:
                Get.find<ColorController>().colorSet.topBackgroundColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            insetPadding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
            child: Container(
              width: 100,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomRadioListTile<AlignEnum>(
                      title: LocaleKeys.custom.tr(),
                      value: AlignEnum.values[0],
                      groupValue: initialAlignEnum,
                      activeColor:
                          Get.find<ColorController>().colorSet.mainColor,
                      titleTextStyle: TextStyle(
                          color: Get.find<ColorController>()
                              .colorSet
                              .mainTextColor,
                          fontSize: 16,
                          fontFamily: MyFontFamily.mainFontFamily),
                      titleFontSize: 20,
                      onChanged: (_) {
                        _settingsSharedPreferences.setAlignValue(
                            _settingsSharedPreferences.alignBySetting);
                        Get.find<AlarmListController>().sortAlarm();
                        Get.back();
                      }),
                  CustomRadioListTile<AlignEnum>(
                      title: LocaleKeys.byDate.tr(),
                      value: AlignEnum.values[1],
                      groupValue: initialAlignEnum,
                      activeColor:
                      Get.find<ColorController>().colorSet.mainColor,
                      titleTextStyle: TextStyle(
                          color: Get.find<ColorController>()
                              .colorSet
                              .mainTextColor,
                          fontSize: 16,
                          fontFamily: MyFontFamily.mainFontFamily),
                      titleFontSize: 20,
                      onChanged: (_) {
                        _settingsSharedPreferences.setAlignValue(
                            _settingsSharedPreferences.alignByDate);
                        Get.find<AlarmListController>().sortAlarm();
                        Get.back();
                      }),
                ],
              ),
            ),
          ),
          //밖 터치하면 dialog가 꺼지는 거
          //barrierDismissible: false,
        );
        //dayOffList.sort((a, b) => a.dayOffDate.compareTo(b.dayOffDate));
      },
      child: ListTile(
        leading: Icon(
          Icons.subject_rounded,
          size: ButtonSize.medium,
          color: Get.find<ColorController>().colorSet.mainTextColor,
        ),
        title: Text(
          LocaleKeys.align.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
