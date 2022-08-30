import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/data/shared_preferences/settings_shared_preferences.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import '../../../../global/auto_size_text.dart';
import '../../../../global/color_controller.dart';

class AlignButton extends StatelessWidget {
  final _settingsSharedPreferences = SettingsSharedPreferences();
  double buttonHeight = 37.5;
  double buttonPadding = 7.5;
  double radioRadius = 7.5;
  late double borderRadius = radioRadius + 7.5;
  double borderWidth = 2;
  Color activeColor = Get.find<ColorController>().colorSet.mainColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      onTap: () async {
        String currentAlign = await _settingsSharedPreferences.getAlignValue();
        Color settingColor = Get.find<ColorController>().colorSet.topBackgroundColor;
        Color settingBorderColor = Colors.grey;
        Color dateColor = Get.find<ColorController>().colorSet.topBackgroundColor;
        Color dateBorderColor = Colors.grey;
        if (currentAlign == _settingsSharedPreferences.alignBySetting) {
          settingColor = activeColor;
          settingBorderColor = activeColor;
        } else {
          dateColor = activeColor;
          dateBorderColor = activeColor;
        }
        Get.dialog(
          Dialog(
            backgroundColor: Get.find<ColorController>().colorSet.topBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            insetPadding: EdgeInsets.fromLTRB(10, 20, 10, 25),

            child: Container(
              height: 100,
              width: 80,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    splashColor: Colors.grey,
                    onTap: () {
                      _settingsSharedPreferences.setAlignValue(
                          _settingsSharedPreferences.alignBySetting);
                      Get.find<AlarmListController>().sortAlarm();
                      Get.back();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: buttonHeight,
                            padding: EdgeInsets.all(buttonPadding),
                            child: AutoSizeText(
                              LocaleKeys.custom.tr(),
                              color: Get.find<ColorController>().colorSet.mainTextColor,
                            )),
                        Container(height: 10,),
                        Stack(alignment: Alignment.center, children: [
                          Container(
                            height: borderRadius,
                            width: borderRadius,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: borderWidth,
                                    color: settingBorderColor),
                                shape: BoxShape.circle),
                          ),
                          Container(
                            height: radioRadius,
                            width: radioRadius,
                            decoration: BoxDecoration(
                                color: settingColor,
                                shape: BoxShape.circle),
                          ),
                        ])
                      ],
                    ),
                  ),
                  VerticalDivider(),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    splashColor: Colors.grey,
                    onTap: () {
                      _settingsSharedPreferences.setAlignValue(
                          _settingsSharedPreferences.alignByDate);
                      Get.find<AlarmListController>().sortAlarm();
                      Get.back();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: buttonHeight,
                            padding: EdgeInsets.all(buttonPadding),
                            child: AutoSizeText(
                              LocaleKeys.byDate.tr(),
                              color: Get.find<ColorController>().colorSet.mainTextColor,
                            )),
                        Container(height: 10,),
                        Stack(alignment: Alignment.center, children: [
                          Container(
                            height: borderRadius,
                            width: borderRadius,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: borderWidth,
                                    color: dateBorderColor),
                                shape: BoxShape.circle),
                          ),
                          Container(
                            height: radioRadius,
                            width: radioRadius,
                            decoration: BoxDecoration(
                                color: dateColor, shape: BoxShape.circle),
                          ),
                        ])
                      ],
                    ),
                  ),
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
