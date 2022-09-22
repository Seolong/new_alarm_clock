import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_folder_data.dart';
import 'package:new_alarm_clock/data/shared_preferences/settings_shared_preferences.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

class FolderListController extends GetxController {
  final AlarmProvider _alarmProvider = AlarmProvider();
  List<AlarmFolderData> folderList = [];
  SettingsSharedPreferences settingsSharedPreferences =
      SettingsSharedPreferences();
  String _currentFolderName = StringValue.allAlarms;
  String _mainFolderName = StringValue.allAlarms;
  int _currentFolderId = 0;

  int get currentFolderId => _currentFolderId;

  set currentFolderId(int value) {
    _currentFolderId = value;
    update();
  }

  set currentFolderName(String name) {
    _currentFolderName = name;
    var folder = folderList.where((e) => e.name == name).first;
    _currentFolderId = folder.id;
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

  void deleteFolder(int id, String name) async {
    _alarmProvider.deleteAlarmFolder(id);
    var prefMainFolderName = await settingsSharedPreferences.getMainFolderName();
    if(prefMainFolderName == name){
      settingsSharedPreferences.setMainFolderName(LocaleKeys.allAlarms.tr());
      _mainFolderName = LocaleKeys.allAlarms.tr();
    }
    folderList.removeWhere((element) => element.id == id);
    Get.find<AlarmListController>()
        .alarmList
        .removeWhere((element) => element.folderId == id);
    currentFolderName = StringValue.allAlarms;
    update();
  }

  void changeFolderName(AlarmFolderData alarmFolderData, String newName) {
    var newData = AlarmFolderData(id: alarmFolderData.id, name: newName);
    _alarmProvider.updateAlarmFolder(newData);
    folderList[folderList.indexWhere(
        (element) => alarmFolderData.id == element.id)] = newData;
    _currentFolderName = newName;
    update();
  }
}
