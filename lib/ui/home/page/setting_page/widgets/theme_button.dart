import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:restart_app/restart_app.dart';
import '../../../../../data/shared_preferences/settings_shared_preferences.dart';
import '../../../../global/color_controller.dart';

enum ColorTheme{
  green, dark
}

extension ColorThemeExtension on String{
  ColorTheme getColorTheme(){
    switch(this){
      case 'green':
        return ColorTheme.green;
      case 'dark':
        return ColorTheme.dark;
      default:
        assert(false, 'ColorThemeExtension Error');
        return ColorTheme.green;
    }
  }
}

class ThemeButton extends StatelessWidget {
  double buttonHeight = 37.5;
  double buttonPadding = 7.5;
  double radioRadius = 7.5;
  late double borderRadius = radioRadius + 7.5;
  double borderWidth = 2;
  ColorTheme theme = ColorTheme.green;
  SettingsSharedPreferences settingsSharedPreferences = SettingsSharedPreferences();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      onTap: () async {
        theme = (await settingsSharedPreferences.getTheme()).getColorTheme();
        Get.dialog(
          Dialog(
            backgroundColor: Get.find<ColorController>().colorSet.topBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            insetPadding: EdgeInsets.fromLTRB(10, 20, 10, 25),
            child: Container(
              width: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: getLanguageListTile(context),
              ),
            ),
          ),
        );
      },
      child: ListTile(
        leading: Icon(
          Icons.palette_rounded,
          size: ButtonSize.medium,
          color: Colors.brown,
        ),
        title: Text(
          LocaleKeys.theme.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),

      ),
    );
  }

  List<RadioListTile> getLanguageListTile(BuildContext context) {
    List<RadioListTile<ColorTheme>> result = [];

    for (int i = 0; i < ColorTheme.values.length; i++) {
      result.add(RadioListTile<ColorTheme>(
          title: Text(ColorTheme.values[i].name),
          value: ColorTheme.values[i],
          groupValue: theme,
          activeColor: Get.find<ColorController>().colorSet.mainColor,
          onChanged: (newValue) {
            Get.dialog(Dialog(
              backgroundColor: Get.find<ColorController>().colorSet.topBackgroundColor,
              child: Container(
                padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
                height: 175,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'You need to restart the app for the changes to take effect.'
                            ' Do you want to restart now?',
                      style: TextStyle(
                        color: Get.find<ColorController>().colorSet.mainTextColor
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey),
                            )),
                        TextButton(
                            onPressed: () async{
                              theme = newValue!;
                              await settingsSharedPreferences.setTheme(newValue.name);
                              Restart.restartApp();
                            },
                            child: Text('Restart')),
                      ],
                    )
                  ],
                ),
              ),
            ));
          }));
    }

    return result;
  }
}
