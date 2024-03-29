import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/data/shared_preferences/settings_shared_preferences.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';

class ColorController extends GetxController {
  String colorTheme = 'green';
  SettingsSharedPreferences settingsSharedPreferences =
      SettingsSharedPreferences();
  ColorSet colorSet = ColorSet(
      ColorValue.yellowGreen,
      ColorValue.green,
      ColorValue.teal,
      ColorValue.yellow,
      ColorValue.orange,
      ColorValue.darkOrange,
      ColorValue.white,
      ColorValue.black,
      ColorValue.skyBlue,
      ColorValue.magicMint,
      ColorValue.white,
      ColorValue.cloudyWhite,
  Colors.grey);
  final ColorSet _greenSet = ColorSet(
      ColorValue.yellowGreen,
      ColorValue.green,
      ColorValue.teal,
      ColorValue.yellow,
      ColorValue.orange,
      ColorValue.darkOrange,
      ColorValue.white,
      ColorValue.black,
      ColorValue.skyBlue,
      ColorValue.magicMint,
      ColorValue.white,
      ColorValue.cloudyWhite,
      Colors.grey);
  final ColorSet _darkSet = ColorSet(
      ColorValue.lightBlue,
      ColorValue.blue,
      ColorValue.navy,
      ColorValue.blue,
      ColorValue.lightBlue,
      ColorValue.navy,
      ColorValue.white,
      ColorValue.white,
      ColorValue.skyBlue,
      ColorValue.lightBlue,
      ColorValue.black,
      ColorValue.black87,
      Colors.grey[50]!);

  @override
  void onInit() async {
    colorTheme = await settingsSharedPreferences.getTheme();
    setColorSet(colorTheme);

    update();
    super.onInit();
  }

  void setColorSet(String theme) {
    if (theme == settingsSharedPreferences.green) {
      colorSet = _greenSet;
    } else if (theme == settingsSharedPreferences.dark) {
      colorSet = _darkSet;
    } else {
      assert(false, 'Color Controller: setColorSet error');
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
  Color backgroundColor;
  Color topBackgroundColor;
  Color lightGrey;

  ColorSet(
      this.lightMainColor,
      this.mainColor,
      this.deepMainColor,
      this.lightAccentColor,
      this.accentColor,
      this.deepAccentColor,
      this.appBarContentColor,
      this.mainTextColor,
      this.calendarTitleColor,
      this.switchTrackColor,
      this.backgroundColor,
      this.topBackgroundColor,
      this.lightGrey);
}
