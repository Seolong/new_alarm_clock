import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_folder_data.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';

class FolderListController extends GetxController{
  AlarmProvider _alarmProvider = AlarmProvider();
  RxList<AlarmFolderData> folderList = RxList<AlarmFolderData>();
  RxString _currentFolderName = '전체 알람'.obs; //홈으로 설정한 폴더

  set currentFolderName(String name){
    _currentFolderName = name.obs;
  }

  String get currentFolderName => _currentFolderName.value;

  @override
  Future<void> onInit() async {
    var varFolderList = await _alarmProvider.getAllAlarmFolders();
    folderList = varFolderList.obs;

    update();
    super.onInit();
  }

  void inputFolder(AlarmFolderData alarmFolderData) async{
    await _alarmProvider.insertAlarmFolder(alarmFolderData);
    //List에 없을 때만 List에 넣는다
    if(!folderList.any((e)=>e.name == alarmFolderData.name)){
      folderList.add(alarmFolderData);
    }
    update();
  }

  void deleteFolder(String name){
    _alarmProvider.deleteAlarmFolder(name);
    folderList.removeWhere((element) => element.name == name);
    Get.find<AlarmListController>().alarmList.removeWhere((element)
      => element.folderName == name);
    update();
  }

  void updateAlarm(AlarmFolderData alarmFolderData){
    _alarmProvider.updateAlarmFolder(alarmFolderData);
    folderList[folderList.indexWhere((element) =>
      alarmFolderData.name == element.name)] = alarmFolderData;
    update();
  }
}