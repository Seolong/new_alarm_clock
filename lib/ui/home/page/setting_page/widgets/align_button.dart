import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/data/shared_preferences/settings_shared_preferences.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import '../../../../../utils/values/color_value.dart';
import '../../../../global/auto_size_text.dart';

class AlignButton extends StatelessWidget {
  final _settingsSharedPreferences = SettingsSharedPreferences();
  double buttonHeight = 37.5;
  double buttonPadding = 7.5;
  double radioRadius = 7.5;
  late double borderRadius = radioRadius + 7.5;
  double borderWidth = 2;
  Color activeColor = ColorValue.activeSwitch;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        String currentAlign = await _settingsSharedPreferences.getAlignValue();
        Color settingColor = Colors.white;
        Color settingBorderColor = Colors.black54;
        Color dateColor = Colors.white;
        Color dateBorderColor = Colors.black54;
        if (currentAlign == _settingsSharedPreferences.alignBySetting) {
          settingColor = activeColor;
          settingBorderColor = activeColor;
        } else {
          dateColor = activeColor;
          dateBorderColor = activeColor;
        }
        Get.dialog(
          Dialog(
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
                              '설정순',
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
                    borderRadius: BorderRadius.circular(100),
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
                              '날짜순',
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
      child: Column(
        children: [
          Icon(
            Icons.subject_rounded,
            size: 50,
            color: Colors.black,
          ),
          Container(
              height: 20,
              child: AutoSizeText(
                '정렬',
                bold: true,
              )),
        ],
      ),
    );
  }
}
