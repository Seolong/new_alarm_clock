import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_list_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_name_text_field_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/tab_page_controller.dart';
import 'package:new_alarm_clock/ui/home/widgets/delete_dialog.dart';
import 'package:new_alarm_clock/ui/home/widgets/set_folder_title_dialog.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

import '../../../global/color_controller.dart';

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
      backgroundColor: Get.find<ColorController>().colorSet.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 150,
              alignment: Alignment.center,
              child: Text(
                LocaleKeys.folder.tr(),
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: MyFontFamily.mainFontFamily,
                  color: Get.find<ColorController>().colorSet.mainTextColor
                ),
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
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        onLongPress: () async {
                          if (index != 0) {
                            // 전체 알람 폴더는 삭제 불가
                            bool isDelete = await Get.dialog(DeleteDialog(
                                LocaleKeys.deleteFolder.tr()));
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
                                child: AutoSizeText(index == 0?LocaleKeys.allAlarms.tr():
                                  '${_.folderList[index].name}',
                                  color: Get.find<ColorController>().colorSet.mainTextColor,
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
                              color: Colors.lime,
                            ),
                            Container(
                                height: 20,
                                child: AutoSizeText(
                                  LocaleKeys.addFolder.tr(),
                                  color: Get.find<ColorController>().colorSet.mainTextColor,
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
