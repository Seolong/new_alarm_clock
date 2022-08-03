import 'dart:ui';
import 'package:get/get.dart';
import 'package:new_alarm_clock/data/shared_preferences/settings_shared_preferences.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';

class ColorController extends GetxController {
  String _colorTheme = 'green';
  SettingsSharedPreferences settingsSharedPreferences =
      SettingsSharedPreferences();
  ColorSet colorSet = ColorSet(
    ColorValue.yellowGreen, ColorValue.green, ColorValue.teal,
    ColorValue.yellow, ColorValue.orange, ColorValue.darkOrange,
    ColorValue.white, ColorValue.black, ColorValue.skyBlue,
    ColorValue.magicMint
  );

  set colorTheme(String color) => _colorTheme = color;

  String get colorTheme => _colorTheme;

  @override
  void onInit() async {
    _colorTheme = await settingsSharedPreferences.getTheme();
    setColorSet(_colorTheme);

    update();
    super.onInit();
  }

  void setColorSet(String theme){
    if(theme == settingsSharedPreferences.green){
      colorSet = ColorSet(
        ColorValue.yellowGreen, ColorValue.green, ColorValue.teal,
        ColorValue.yellow, ColorValue.orange, ColorValue.darkOrange,
        ColorValue.white, ColorValue.black, ColorValue.skyBlue,
        ColorValue.magicMint
      );
    }
    settingsSharedPreferences.setTheme(theme);
  }
}

class ColorSet {
  Color lightMainColor;
  Color mainColor;
  Color deepMainColor;
  Color lightAccentColor;
  Color accentColor;
  Color deepAccentColor;
  Color appBarContentColor;
  Color mainTextColor;
  Color calendarTitleColor;
  Color switchTrackColor;

  ColorSet(this.lightMainColor, this.mainColor, this.deepMainColor,
      this.lightAccentColor, this.accentColor, this.deepAccentColor,
      this.appBarContentColor, this.mainTextColor, this.calendarTitleColor,
      this.switchTrackColor);
}
