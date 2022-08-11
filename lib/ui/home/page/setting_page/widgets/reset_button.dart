import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import '../../../../../data/database/alarm_provider.dart';
import '../../../../../service/alarm_scheduler.dart';
import '../../../../global/auto_size_text.dart';
import '../../../../global/color_controller.dart';
import '../../../controller/alarm_list_controller.dart';
import '../../../controller/folder_list_controller.dart';
import '../../../widgets/delete_dialog.dart';

class ResetButton extends StatelessWidget {
  AlarmProvider _alarmProvider = AlarmProvider();

  @override
  Widget build(BuildContext context) {
    final alarmListController = Get.put(AlarmListController());
    final folderListController = Get.put(FolderListController());
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      onTap: () async{
        bool? isDelete = await Get.dialog(DeleteDialog(LocaleKeys.resetAll.tr()));
        if(isDelete == true){
          await AlarmScheduler.removeAllAlarm();
          await _alarmProvider.resetAllTable();

          alarmListController.onInit();
          folderListController.onInit();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delete_forever,
            size: 50,
            color: Colors.red,
          ),
          Container(
              height: 20,
              child: AutoSizeText(
                LocaleKeys.reset.tr(),
                bold: true,
                color: Get.find<ColorController>().colorSet.mainTextColor,
              )),
        ],
      ),
    );
  }
}
