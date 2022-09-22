import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/model/alarm_folder_data.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_list_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_name_text_field_controller.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

class EditFolderTitleDialog extends StatelessWidget {
  final AlarmFolderData alarmFolderData;

  const EditFolderTitleDialog({Key? key, required this.alarmFolderData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var folderNameController = Get.put(FolderNameTextFieldController());
    var folderListController = Get.put(FolderListController());

    folderNameController.textEditingController.text = alarmFolderData.name;

    return GetBuilder<FolderNameTextFieldController>(builder: (_) {
      return AlertDialog(
        backgroundColor:
            Get.find<ColorController>().colorSet.topBackgroundColor,
        title: Text(
          LocaleKeys.folderName.tr(),
          style: TextStyle(
              color: Get.find<ColorController>().colorSet.mainTextColor),
        ),
        content: TextField(
          onChanged: (value) {},
          controller: _.textEditingController,
          decoration: InputDecoration(
              hintText: LocaleKeys.inputFolderName.tr(),
              hintStyle: const TextStyle(color: Colors.grey),
              suffixIcon: _.textEditingController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.grey,
                      ),
                      onPressed: () => _.resetField(),
                    )
                  : null,
              errorText: _.getErrorText(),
              errorMaxLines: 3),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.grey,
            ),
            child: Text(LocaleKeys.cancel.tr()),
            onPressed: () {
              _.textEditingController.text = '';
              Get.back();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.blue,
            ),
            child: Text(LocaleKeys.done.tr()),
            onPressed: () async {
              if (folderListController.folderList.any((e) =>
                  e.name == _.textEditingController.text &&
                  alarmFolderData.name != _.textEditingController.text)) {
                _.isError = true;
                //Get.back();
              } else {
                folderListController.changeFolderName(
                    alarmFolderData, _.textEditingController.text);
                _.textEditingController.text = '';
                Get.back();
              }
            },
          ),
        ],
      );
    });
  }
}
