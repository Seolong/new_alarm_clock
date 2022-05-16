import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/service/alarm_scheduler.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_list_controller.dart';
import 'package:new_alarm_clock/ui/home/widgets/delete_dialog.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  AlarmProvider _alarmProvider = AlarmProvider();

  @override
  Widget build(BuildContext context) {
    final alarmListController = Get.put(AlarmListController());
    final folderListController = Get.put(FolderListController());
    int? folderCrossAxisCount = Get.width ~/ 100;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 150,
              alignment: Alignment.center,
              child: Text(
                '더보기',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: MyFontFamily.mainFontFamily),
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: folderCrossAxisCount != 0
                        ? folderCrossAxisCount
                        : 1, //1 개의 행에 보여줄 item 개수
                    mainAxisSpacing: 10, //수평 Padding
                    crossAxisSpacing: 10, //수직 Padding
                  ),
                  itemBuilder: (BuildContext context, int index) {
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
                  }),
            )
          ],
        ),
      ),
    );
  }
}
