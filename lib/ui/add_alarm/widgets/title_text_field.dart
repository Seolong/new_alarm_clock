import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/alarm_title_text_field_controller.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

class TitleTextField extends StatelessWidget {
  String mode;
  int alarmId;

  TitleTextField(this.mode, this.alarmId);

  @override
  Widget build(BuildContext context) {
    final alarmTitleTextFieldController = Get.put(AlarmTitleTextFieldController());
    return Container(
      height: 100,
      //padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: GetBuilder<AlarmTitleTextFieldController>(
        initState: (_) => mode == StringValue.editMode
            ? alarmTitleTextFieldController
            .initTitleTextField(alarmId)
            : null,
        builder: (_) => FittedBox(
          fit: BoxFit.scaleDown,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 1, minHeight: 1, maxWidth: Get.width),
            child: TextField(
              controller: _.textEditingController,
              onChanged: (value) {
                if (_.textEditingController.text.length != 0) {
                  print('length not 0');
                } else {
                  print('length 0');
                }
              },
              style: TextStyle(
                  fontFamily: MyFontFamily.mainFontFamily,
                  fontSize: 25
              ),
              decoration: InputDecoration(
                  labelText: '알람 이름',
                  labelStyle: TextStyle(
                      fontFamily: MyFontFamily.mainFontFamily,
                      fontSize: 20
                  ),
                  suffixIcon: _.textEditingController.text.length > 0
                      ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                    onPressed: () => _.resetField(),
                  )
                      : null // Show the clear button if the text field has something
              ),
            ),
          ),
        ),
      ),
    );
  }
}
