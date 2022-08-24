import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/model/alarm_folder_data.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_list_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_name_text_field_controller.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

class SetFolderTitleDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var folderNameTextFieldController =
        Get.put(FolderNameTextFieldController());
    var folderListController = Get.put(FolderListController());

    return GetBuilder<FolderNameTextFieldController>(builder: (_) {
      return AlertDialog(
        backgroundColor: Get.find<ColorController>().colorSet.topBackgroundColor,
        title: Text(
            LocaleKeys.folderName.tr(),
          style: TextStyle(
            color: Get.find<ColorController>().colorSet.mainTextColor
          ),
        ),
        content: TextField(
          onChanged: (value) {},
          controller: _.textEditingController,
          decoration: InputDecoration(
            hintText: LocaleKeys.inputFolderName.tr(),
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: _.textEditingController.text.length > 0
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey,
                    ),
                    onPressed: () => _.resetField(),
                  )
                : null,
            errorText: _.getErrorText(),
            errorMaxLines: 3
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.grey,
            ),
            child: Text(LocaleKeys.cancel.tr()),
            onPressed: () {
              folderNameTextFieldController.textEditingController.text = '';
              Get.back();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.blue,
            ),
            child: Text(LocaleKeys.done.tr()),
            onPressed: () {
              if (folderListController.folderList.any((e) =>
                  e.name == folderNameTextFieldController.textEditingController.text)) {
                _.isError = true;
                //Get.back();
              } else {
                folderListController.inputFolder(AlarmFolderData(
                    name: folderNameTextFieldController
                        .textEditingController.text));
                folderNameTextFieldController.textEditingController.text = '';
                Get.back();
              }
            },
          ),
        ],
      );
    });
  }
}
