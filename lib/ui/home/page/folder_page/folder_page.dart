import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_list_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_name_text_field_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/tab_page_controller.dart';
import 'package:new_alarm_clock/ui/home/widgets/delete_dialog.dart';
import 'package:new_alarm_clock/ui/home/widgets/set_folder_title_dialog.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

class FolderPage extends StatelessWidget {
  var folderNameTextFieldController = Get.put(FolderNameTextFieldController());
  var folderListController = Get.put(FolderListController());

  void _displaySetFolderTitleDialog() {
    Get.dialog(SetFolderTitleDialog());
  }

  @override
  Widget build(BuildContext context) {
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
                '폴더',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: MyFontFamily.mainFontFamily),
              ),
            ),
            Expanded(
              child: GetBuilder<FolderListController>(builder: (_) {
                return GridView.builder(
                  itemCount: _.folderList.length + 1, //item 개수
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: folderCrossAxisCount != 0
                        ? folderCrossAxisCount
                        : 1, //1 개의 행에 보여줄 item 개수
                    mainAxisSpacing: 10, //수평 Padding
                    crossAxisSpacing: 10, //수직 Padding
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    //item 의 반목문 항목 형성
                    if (_.folderList.length != index) {
                      return InkWell(
                        onLongPress: () async {
                          if (index != 0) {
                            // 전체 알람 폴더는 삭제 불가
                            bool isDelete = await Get.dialog(DeleteDialog(
                                '폴더를 삭제하면 내부의 알람도 같이 삭제됩니다. 정말 삭제하시겠습니까?'));
                            if (isDelete == true) {
                              _.deleteFolder(_.folderList[index].name);
                            }
                          }
                        },
                        onTap: () {
                          _.currentFolderName = _.folderList[index].name;
                          Get.find<TabPageController>().pageIndex = 0;
                        },
                        child: Column(
                          children: [
                            Icon(
                              _.mainFolderName !=
                                      _.folderList[index].name
                                  ? Icons.folder
                                  : Icons.folder_special_rounded,
                              size: 65,
                              color: Color(0xffFFCE45),
                            ),
                            Container(
                                height: 20,
                                child: AutoSizeText(
                                  '${_.folderList[index].name}',
                                  bold: true,
                                )),
                          ],
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          print('$index');
                          _displaySetFolderTitleDialog();
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.create_new_folder_rounded,
                              size: 65,
                              color: Color(0xffAD8B73),
                            ),
                            Container(
                                height: 20,
                                child: AutoSizeText(
                                  '폴더 추가',
                                  bold: true,
                                )),
                          ],
                        ),
                      );
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
