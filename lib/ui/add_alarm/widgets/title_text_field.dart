import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/alarm_title_text_field_controller.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

class TitleTextField extends StatelessWidget {
  String mode;
  int alarmId;

  TitleTextField(this.mode, this.alarmId);

  @override
  Widget build(BuildContext context) {
    final alarmTitleTextFieldController =
        Get.put(AlarmTitleTextFieldController());
    return Container(
      height: 100,
      child: GetBuilder<AlarmTitleTextFieldController>(
        initState: (_) => mode == StringValue.editMode
            ? alarmTitleTextFieldController.initTitleTextField(alarmId)
            : null,
        builder: (_) => FittedBox(
          fit: BoxFit.scaleDown,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: 1, minHeight: 1, maxWidth: Get.width),
            child: TextField(
              controller: _.textEditingController,
              style: TextStyle(
                  fontFamily: MyFontFamily.mainFontFamily, fontSize: 25),
              decoration: InputDecoration(
                  labelText: LocaleKeys.alarmName.tr(),
                  labelStyle: TextStyle(
                      fontFamily: MyFontFamily.mainFontFamily, fontSize: 20),
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
