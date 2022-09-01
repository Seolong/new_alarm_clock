import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import '../../../../../data/database/alarm_provider.dart';
import '../../../../../service/alarm_scheduler.dart';
import '../../../controller/alarm_list_controller.dart';
import '../../../controller/folder_list_controller.dart';
import '../../../widgets/delete_dialog.dart';

class ResetButton extends StatelessWidget {
  final AlarmProvider _alarmProvider = AlarmProvider();

  ResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alarmListController = Get.put(AlarmListController());
    final folderListController = Get.put(FolderListController());
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      onTap: () async {
        bool? isDelete =
            await Get.dialog(DeleteDialog(LocaleKeys.resetAll.tr()));
        if (isDelete == true) {
          await AlarmScheduler.removeAllAlarm();
          await _alarmProvider.resetAllTable();

          alarmListController.onInit();
          folderListController.onInit();
        }
      },
      child: ListTile(
        leading: Icon(
          Icons.delete_forever,
          size: ButtonSize.medium,
          color: Colors.red,
        ),
        title: Text(
          LocaleKeys.reset.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
