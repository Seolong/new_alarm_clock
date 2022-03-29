import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/model/alarm_folder_data.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_list_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_name_text_field_controller.dart';
import 'package:get/get.dart';

class SetFolderTitleDialog extends StatelessWidget {
  var folderNameTextFieldController = Get.put(FolderNameTextFieldController());
  var folderListController = Get.put(FolderListController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('폴더 이름'),
      content: GetBuilder<FolderNameTextFieldController>(
          builder: (_) {
            return TextField(
              onChanged: (value) {},
              controller: _.textEditingController,
              decoration: InputDecoration(hintText: "폴더 이름을 입력하세요.",
                  suffixIcon: _.textEditingController.text.length > 0
                      ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                    onPressed: () => _.resetField(),
                  )
                      : null),
            );
          }
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom( primary: Colors.grey,),
          child: Text('취소'),
          onPressed: () {
            folderNameTextFieldController.textEditingController.text = '';
            Get.back();
          },
        ),
        TextButton(
          style: TextButton.styleFrom( primary: Colors.blue,),
          child: Text('확인'),
          onPressed: () {
            folderListController.inputFolder(AlarmFolderData(
                name: folderNameTextFieldController.textEditingController.text));
            folderNameTextFieldController.textEditingController.text = '';
            Get.back();
          },
        ),

      ],
    );
  }
}
