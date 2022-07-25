import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/ui/day_off/controller/day_off_list_controller.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';

class DayOffPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final dayOffListController = Get.put(DayOffListController());
    dayOffListController.initDayOffDataList();
    return Scaffold(
      appBar: AppBar(
          foregroundColor: ColorValue.appbarText,
          backgroundColor: ColorValue.appbar,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () { Get.back(); },
          ),
        title: Text(LocaleKeys.daysOff.tr()),
        actions:[ IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            dayOffListController.insertDayOff();
          },
        ),]
      ),
      body: SafeArea(
        child: GetBuilder<DayOffListController>(
          builder: (_) {
            return ListView.separated(
              padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
              itemCount: _.dayOffDataList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    _.getDayExceptHour(index)
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.clear_rounded),
                    onPressed: () {
                      _.deleteDayOff(_.id, _.dayOffDataList[index].dayOffDate, index);
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            );
          }
        ),
      ),
    );
  }
}
