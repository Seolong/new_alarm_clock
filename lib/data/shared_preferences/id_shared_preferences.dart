import 'package:shared_preferences/shared_preferences.dart';

class IdSharedPreferences {
  static final IdSharedPreferences _instance = IdSharedPreferences._internal();
  late SharedPreferences sharedPreferences;
  final String toBeAddedIdName = 'toBeAddedId';

  factory IdSharedPreferences() {
    return _instance;
  }

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    int toBeAddedId = sharedPreferences.getInt(toBeAddedIdName) ?? 0;
    if(toBeAddedId == 0){
      sharedPreferences.setInt(toBeAddedIdName, toBeAddedId);
    }
  }

  IdSharedPreferences._internal();

  Future<int> getId() async{
    await init();
    return sharedPreferences.getInt(toBeAddedIdName)!;
  }

  Future<void> setId(int id)async {
    await init();
    sharedPreferences.setInt(toBeAddedIdName, id);
  }
}