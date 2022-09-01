import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/alarm_title_text_field_controller.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

class TitleTextField extends StatelessWidget {
  String mode;
  int alarmId;

  TitleTextField(this.mode, this.alarmId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alarmTitleTextFieldController =
        Get.put(AlarmTitleTextFieldController());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: GetBuilder<AlarmTitleTextFieldController>(
        initState: (_) => mode == StringValue.editMode
            ? alarmTitleTextFieldController.initTitleTextField(alarmId)
            : null,
        builder: (_) => TextField(
          controller: _.textEditingController,
          style: Theme.of(Get.context!).textTheme.titleMedium!,
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              labelText: LocaleKeys.alarmName.tr(),
              labelStyle: Theme.of(Get.context!)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.grey),
              suffixIcon: _.textEditingController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.grey,
                      ),
                      onPressed: () => _.resetField(),
                    )
                  : null // Show the clear button if the text field has something
              ),
        ),
      ),
    );
  }
}
