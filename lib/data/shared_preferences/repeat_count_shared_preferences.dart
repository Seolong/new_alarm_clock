import 'package:shared_preferences/shared_preferences.dart';

class RepeatCountSharedPreferences {
  static final RepeatCountSharedPreferences _instance = RepeatCountSharedPreferences._internal();
  late SharedPreferences sharedPreferences;
  final String repeatCount = 'repeatCount';//지금 몇번 울렸니?
  final int initialValue = 0;

  factory RepeatCountSharedPreferences() {
    return _instance;
  }

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    int count = sharedPreferences.getInt(repeatCount) ?? initialValue;
    if(count == initialValue){
      sharedPreferences.setInt(repeatCount, count);
    }
  }

  RepeatCountSharedPreferences._internal();

  Future<int> getRepeatCount() async{
    await init();
    return sharedPreferences.getInt(repeatCount)!;
  }

  Future<void> setRepeatCount() async{
    await init();
    int count = await sharedPreferences.getInt(repeatCount)!;
    sharedPreferences.setInt(repeatCount, ++count);
  }

  Future<void> resetRepeatCount() async{
    await init();
    sharedPreferences.setInt(repeatCount, initialValue);
  }
}