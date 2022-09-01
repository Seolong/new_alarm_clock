import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

class RequiredParameterToAddAlarmPageController extends GetxController {
  String _mode = StringValue.addMode;
  int _alarmId = -1;
  String _folderName = '';
  bool isFirstInit = false;

  set mode(String modeValue) {
    if (modeValue == StringValue.addMode) {
      _mode = modeValue;
    } else if (modeValue == StringValue.editMode) {
      _mode = modeValue;
      isFirstInit = true;
    } else {
      assert(
          false, 'RequiredParameterToAddAlarmPageController: set mode error.');
    }
    update();
  }

  String get mode => _mode;

  set alarmId(int id) {
    if (id < 0) {
      assert(false,
          'RequiredParameterToAddAlarmPageController: alarmId is less than 0');
    }
    _alarmId = id;
    update();
  }

  int get alarmId => _alarmId;

  set folderName(String name) {
    _folderName = name;
    update();
  }

  String get folderName => _folderName;
}
