import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:restart_app/restart_app.dart';
import '../../../../../data/shared_preferences/settings_shared_preferences.dart';
import '../../../../../utils/values/my_font_family.dart';
import '../../../../global/color_controller.dart';
import '../../../../global/custom_radio_list_tile.dart';

enum ColorTheme { Green, Dark }

extension ColorThemeExtension on String {
  ColorTheme getColorTheme() {
    switch (this) {
      case 'Green':
        return ColorTheme.Green;
      case 'Dark':
        return ColorTheme.Dark;
      default:
        assert(false, 'ColorThemeExtension Error');
        return ColorTheme.Green;
    }
  }
}

class ThemeButton extends StatelessWidget {
  double buttonHeight = 37.5;
  double buttonPadding = 7.5;
  double radioRadius = 7.5;
  late double borderRadius = radioRadius + 7.5;
  double borderWidth = 2;
  ColorTheme theme = ColorTheme.Green;
  SettingsSharedPreferences settingsSharedPreferences =
      SettingsSharedPreferences();

  ThemeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      onTap: () async {
        theme = (await settingsSharedPreferences.getTheme()).getColorTheme();
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
                children: getLanguageListTile(),
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

  List<CustomRadioListTile> getLanguageListTile() {
    List<CustomRadioListTile<ColorTheme>> result = [];

    for (int i = 0; i < ColorTheme.values.length; i++) {
      result.add(CustomRadioListTile<ColorTheme>(
          title: ColorTheme.values[i].name,
          titleFontSize: 16,
          titleTextStyle: TextStyle(
              color: Get.find<ColorController>().colorSet.mainTextColor,
              fontSize: 16,
              fontFamily: MyFontFamily.mainFontFamily),
          value: ColorTheme.values[i],
          groupValue: theme,
          activeColor: Get.find<ColorController>().colorSet.mainColor,
          onChanged: (newValue) {
            Get.dialog(Dialog(
              backgroundColor:
                  Get.find<ColorController>().colorSet.topBackgroundColor,
              child: Container(
                padding: const EdgeInsets.fromLTRB(22.5, 22.5, 22.5, 0),
                height: 175,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.doYouWantToRestart.tr(),
                      style: TextStyle(
                          color: Get.find<ColorController>()
                              .colorSet
                              .mainTextColor),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey),
                            )),
                        TextButton(
                            onPressed: () async {
                              theme = newValue!;
                              await settingsSharedPreferences
                                  .setTheme(newValue.name);
                              Restart.restartApp();
                            },
                            child: const Text('Restart')),
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
