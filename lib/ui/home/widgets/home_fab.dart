import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_list_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/required_parameter_to_add_alarm_page_controller.dart';
import '../../../data/shared_preferences/id_shared_preferences.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/values/color_value.dart';
import '../../../utils/values/size_value.dart';
import '../../../utils/values/string_value.dart';
import '../../global/convenience_method.dart';
import '../page/inner_home_page/widgets/alarm_item/controller/selected_alarm_controller.dart';

class HomeFAB extends StatelessWidget {
  final IdSharedPreferences idSharedPreferences = IdSharedPreferences();

  @override
  Widget build(BuildContext context) {
    var folderListController = Get.put(FolderListController());
    var requiredParameterToAddAlarmPageController = Get.put(RequiredParameterToAddAlarmPageController());
    return Container(
      width: ButtonSize.xlarge,
      height: ButtonSize.xlarge,
      child: FloatingActionButton( // addAlarmButton
        //폴더 탭일 때 다른 색, 메뉴 탭일 땐 disable임을 나타내기 위해 회색
        backgroundColor: ColorValue.fab,
        child: FittedBox(
          child: Icon(
            Icons.add_rounded,
            size: 1000,
          ),
        ),
        onPressed: () async{
          Get.closeAllSnackbars();
          Get.find<SelectedAlarmController>().isSelectedMode = false;
          int newId = await idSharedPreferences.getId();
          requiredParameterToAddAlarmPageController.mode = StringValue.addMode;
          requiredParameterToAddAlarmPageController.alarmId = newId;
          requiredParameterToAddAlarmPageController.folderName = folderListController.currentFolderName;

          idSharedPreferences.setId(++newId);
          Get.toNamed(AppRoutes.addAlarmPage);
        },
      ),
    );
  }
}
