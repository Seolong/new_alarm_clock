import 'package:new_alarm_clock/utils/enum.dart';

class TypeConverter {
  static bool convertIntToBool(int target) {
    if (target == 1) {
      return true;
    } else if (target == 0) {
      return false;
    } else {
      assert(false, 'Error in convertIntToBool of AlarmData');
      return false;
    }
  }

  static int convertBoolToInt(bool target) {
    if (target == true) {
      return 1;
    } else if (target == false) {
      return 0;
    } else {
      assert(false, 'Error in convertBoolToInt of AlarmData');
      return -99;
    }
  }

  //앞에 VibrationName. 빼는 메소드
  static String convertVibrationNameToString(VibrationName vibrationName) {
    String name = vibrationName.toString();
    List names = name.split('.');
    return names[1];
  }
}
