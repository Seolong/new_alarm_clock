import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

import '../../../controller/alarm_list_controller.dart';
import '../../../controller/folder_list_controller.dart';
import 'alarm_item/alarm_item.dart';

class AlarmListView extends StatelessWidget {
  const AlarmListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AlarmListController());
    var folderListController = Get.put(FolderListController());

    return Theme(
      data: ThemeData(
          canvasColor: Colors.transparent, shadowColor: Colors.transparent),
      child: GetBuilder<FolderListController>(builder: (context) {
        return GetBuilder<AlarmListController>(builder: (_) {
          return ReorderableListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
            itemCount: _.alarmList.length + 1,
            onReorder: (int oldIndex, int newIndex) {
              _.reorderItem(oldIndex, newIndex);
            },
            itemBuilder: (BuildContext context, int index) {
              if (index != _.alarmList.length) {
                if (folderListController.currentFolderName ==
                    StringValue.allAlarms) {
                  return AlarmItem(
                    id: _.alarmList[index].id,
                    key: ValueKey(_.alarmList[index].id),
                    index: index,
                  );
                } else if (folderListController.currentFolderName ==
                    _.alarmList[index].folderName) {
                  return AlarmItem(
                    id: _.alarmList[index].id,
                    key: ValueKey(_.alarmList[index].id),
                    index: index,
                  );
                }
                //return Container(key: ValueKey(-index),);
                //이게 빈 컨테이너보다 아주 근소하게 빠르대
                return SizedBox.shrink(key: GlobalKey());
              } else {
                return Container(
                  key: GlobalKey(),
                  height: 75,
                );
              }
            },
          );
        });
      }),
    );
  }
}
