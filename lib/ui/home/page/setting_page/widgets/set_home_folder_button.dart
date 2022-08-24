import 'package:flutter/material.dart';import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/data/shared_preferences/settings_shared_preferences.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import '../../../../global/auto_size_text.dart';
import '../../../controller/folder_list_controller.dart';

class SetHomeFolderButton extends StatelessWidget {
  SettingsSharedPreferences _settingsSharedPreferences =
      SettingsSharedPreferences();

  @override
  Widget build(BuildContext context) {
    Get.put(FolderListController());
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      onTap: () async {
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            contentPadding: EdgeInsets.zero,
            title: Container(
                decoration: BoxDecoration(
                  color: Get.find<ColorController>().colorSet.mainColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                height: 60,
                child: AutoSizeText(
                  LocaleKeys.chooseMainFolder.tr(),
                  bold: true,
                  color: Get.find<ColorController>().colorSet.appBarContentColor,
                )),
            titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            backgroundColor: Get.find<ColorController>().colorSet.topBackgroundColor,
            content: GetBuilder<FolderListController>(builder: (_) {
              return Container(
                //height: Get.height / 5 * 3,
                width: Get.width / 5 * 3,
                padding: EdgeInsets.fromLTRB(17.5, 10, 17.5, 15),
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(7.5),
                  itemCount: _.folderList.length,
                  //item 개수
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, //1 개의 행에 보여줄 item 개수
                    //childAspectRatio: 1 / 2, //item 의 가로 1, 세로 2 의 비율
                    mainAxisSpacing: 7.5, //수평 Padding
                    crossAxisSpacing: 7.5, //수직 Padding
                    mainAxisExtent: 80
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    //item 의 반목문 항목 형성
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Get.find<ColorController>().colorSet.backgroundColor,
                          //border: Border.all(width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(115)),
                        ),
                        child: InkWell(
                          onTap: () async{
                            await _settingsSharedPreferences
                                .setMainFolderName(_.folderList[index].name);
                            _.mainFolderName = _.folderList[index].name;
                            Get.back();
                          },
                          child: Column(
                            children: [
                              Icon(
                                _.mainFolderName !=
                                    _.folderList[index].name
                                    ? Icons.folder
                                    : Icons.folder_special_rounded,
                                size: 50,
                                color: Color(0xffFFCE45),
                              ),
                              Container(
                                  height: 17.5,
                                  child: AutoSizeText(index==0
                                      ? LocaleKeys.allAlarms.tr()
                                      : '${_.folderList[index].name}',
                                    bold: true,
                                    color: Get.find<ColorController>().colorSet.mainTextColor,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          //밖 터치하면 dialog가 꺼지는 거
          //barrierDismissible: false,
        );
      },
      child: ListTile(
          leading: Icon(
            Icons.folder_special_rounded,
            size: ButtonSize.medium,
            color: Get.find<ColorController>().colorSet.mainTextColor,
          ),
          title: Text(
                LocaleKeys.mainFolder.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),

      ),
    );
  }
}
