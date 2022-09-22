import 'package:shared_preferences/shared_preferences.dart';

class IdSharedPreferences {
  static final IdSharedPreferences _instance = IdSharedPreferences._internal();
  late SharedPreferences sharedPreferences;
  final String toBeAddedIdName = 'toBeAddedId';
  final String alarmedAlarmIdName = 'alarmedAlarmId';
  final int initialValue = 1;

  factory IdSharedPreferences() {
    return _instance;
  }

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    int toBeAddedId = sharedPreferences.getInt(toBeAddedIdName) ?? initialValue;
    if (toBeAddedId == initialValue) {
      sharedPreferences.setInt(toBeAddedIdName, toBeAddedId);
    }

    int alarmedAlarmId = sharedPreferences.getInt(alarmedAlarmIdName) ?? -1;
    if (alarmedAlarmId == -1) {
      sharedPreferences.setInt(alarmedAlarmIdName, alarmedAlarmId);
    }
  }

  IdSharedPreferences._internal();

  Future<int> getId() async {
    await init();
    return sharedPreferences.getInt(toBeAddedIdName)!;
  }

  Future<void> setId(int id) async {
    await init();
    sharedPreferences.setInt(toBeAddedIdName, id);
  }

  Future<int> getAlarmedId() async {
    await init();
    return sharedPreferences.getInt(alarmedAlarmIdName)!;
  }

  Future<void> setAlarmedId(int id) async {
    await init();
    sharedPreferences.setInt(alarmedAlarmIdName, id);
  }
}
