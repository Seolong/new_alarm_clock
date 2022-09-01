import 'package:shared_preferences/shared_preferences.dart';

class SettingsSharedPreferences {
  static final SettingsSharedPreferences _instance =
      SettingsSharedPreferences._internal();
  late SharedPreferences sharedPreferences;
  final String alignName = 'align';
  final String alignByDate = 'byDate';
  final String alignBySetting = 'bySetting';
  final String mainFolderName = 'mainFolder';
  final String green = 'Green';
  final String dark = 'Dark';
  final String theme = 'theme';

  factory SettingsSharedPreferences() {
    return _instance;
  }

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? alignValue = sharedPreferences.getString(alignName);
    if (alignValue == null) {
      sharedPreferences.setString(alignName, alignBySetting);
    }
    String? currentFolderNameValue =
        sharedPreferences.getString(mainFolderName);
    if (currentFolderNameValue == null) {
      sharedPreferences.setString(mainFolderName, '전체 알람');
    }
    String? currentTheme = sharedPreferences.getString(theme);
    if (currentTheme == null) {
      sharedPreferences.setString(theme, green);
    }
  }

  SettingsSharedPreferences._internal();

  Future<String> getAlignValue() async {
    await init();
    return sharedPreferences.getString(alignName)!;
  }

  Future<void> setAlignValue(String alignValue) async {
    await init();
    sharedPreferences.setString(alignName, alignValue);
  }

  Future<String> getMainFolderName() async {
    await init();
    return sharedPreferences.getString(mainFolderName)!;
  }

  Future<void> setMainFolderName(String mainFolderNameValue) async {
    await init();
    sharedPreferences.setString(mainFolderName, mainFolderNameValue);
  }

  Future<String> getTheme() async {
    await init();
    return sharedPreferences.getString(theme)!;
  }

  Future<void> setTheme(String themeValue) async {
    await init();
    sharedPreferences.setString(theme, themeValue);
  }
}
