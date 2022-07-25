import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_folder_data.dart';
import 'package:new_alarm_clock/data/shared_preferences/settings_shared_preferences.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

class FolderListController extends GetxController {
  AlarmProvider _alarmProvider = AlarmProvider();
  List<AlarmFolderData> folderList = [];
  SettingsSharedPreferences settingsSharedPreferences =
      SettingsSharedPreferences();
  String _currentFolderName = StringValue.allAlarms;
  String _mainFolderName = StringValue.allAlarms;

  set currentFolderName(String name) {
    _currentFolderName = name;
    update();
  }

  String get currentFolderName => _currentFolderName;

  set mainFolderName(String name) {
    _mainFolderName = name;
    update();
  }

  String get mainFolderName => _mainFolderName;

  @override
  Future<void> onInit() async {
    var varFolderList = await _alarmProvider.getAllAlarmFolders();
    folderList = varFolderList;
    mainFolderName = await settingsSharedPreferences.getMainFolderName();
    _currentFolderName = _mainFolderName;

    update();
    super.onInit();
  }

  void inputFolder(AlarmFolderData alarmFolderData) async {
    await _alarmProvider.insertAlarmFolder(alarmFolderData);
    //List에 없을 때만 List에 넣는다
    if (!folderList.any((e) => e.name == alarmFolderData.name)) {
      folderList.add(alarmFolderData);
    }
    update();
  }

  void deleteFolder(String name) {
    _alarmProvider.deleteAlarmFolder(name);
    folderList.removeWhere((element) => element.name == name);
    Get.find<AlarmListController>()
        .alarmList
        .removeWhere((element) => element.folderName == name);
    currentFolderName = StringValue.allAlarms;
    update();
  }

  void updateAlarm(AlarmFolderData alarmFolderData) {
    _alarmProvider.updateAlarmFolder(alarmFolderData);
    folderList[folderList.indexWhere(
        (element) => alarmFolderData.name == element.name)] = alarmFolderData;
    update();
  }
}
