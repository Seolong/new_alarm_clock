import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/database/alarm_provider.dart';
import '../../../../../service/alarm_scheduler.dart';
import '../../../../global/auto_size_text.dart';
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
      onTap: () async{
        bool isDelete = await Get.dialog(DeleteDialog('모든 데이터가 삭제됩니다. 초기화하시겠습니까?'));
        if(isDelete == true){
          await AlarmScheduler.removeAllAlarm();
          await _alarmProvider.resetDatabase();

          alarmListController.onInit();
          folderListController.onInit();
        }
      },
      child: Column(
        children: [
          Icon(
            Icons.delete_forever,
            size: 50,
            color: Colors.red,
          ),
          Container(
              height: 20,
              child: AutoSizeText(
                '초기화',
                bold: true,
              )),
        ],
      ),
    );
  }
}
