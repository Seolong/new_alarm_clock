import 'package:shared_preferences/shared_preferences.dart';

class AppStateSharedPreferences {
  static final AppStateSharedPreferences _instance = AppStateSharedPreferences._internal();
  late SharedPreferences sharedPreferences;
  final String appState = 'appState';
  final String main = 'main';
  final String alarm = 'alarm';

  factory AppStateSharedPreferences() {
    return _instance;
  }

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String firstAppState = sharedPreferences.getString(appState) ?? main;
    if(firstAppState == main){
      sharedPreferences.setString(appState, firstAppState);
    }
  }

  AppStateSharedPreferences._internal();

  Future<String> getAppState() async{
    await init();
    return sharedPreferences.getString(appState)!;
  }

  Future<void> setAppStateToMain()async {
    await init();
    sharedPreferences.setString(appState, main);
  }

  Future<void> setAppStateToAlarm()async {
    await init();
    sharedPreferences.setString(appState, alarm);
  }
}