import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/day_off_data.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/widget_all/calendar_container.dart';

import '../../global/color_controller.dart';

class DayOffListController extends GetxController {
  final AlarmProvider _alarmProvider = AlarmProvider();
  List<DayOffData> dayOffDataList = [];
  late int id;

  void initDayOffDataList() async {
    var dayOffDataListValue = await _alarmProvider.getDayOffsById(id);
    dayOffDataList = dayOffDataListValue;

    for (int i = dayOffDataList.length - 1; i >= 0; i--) {
      // 2022-01-01 00:00.000000 이렇게 저장되는데 1월 1일 1시 알람인데 삭제해버리면 곤란하니까
      if (dayOffDataList[i]
          .dayOffDate
          .isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
        deleteDayOff(id, dayOffDataList[i].dayOffDate, i);
      }
    }

    dayOffDataList.sort((a, b) => a.dayOffDate.compareTo(b.dayOffDate));
    update();
  }

  void insertDayOff() async {
    DateTime now = DateTime.now();
    // DateTime? dateTime = await Get.dialog(AlertDialog(
    //     contentPadding: EdgeInsets.zero, content: CalendarContainer(now)));
    DateTime? dateTime = await Get.bottomSheet(
      CalendarContainer(now),
      backgroundColor: Get.find<ColorController>()
          .colorSet
          .backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 1,
      isScrollControlled: true,
    );
    if (dateTime != null) {
      if (dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day) {
        // 다른 날을 선택하면 0시 0분 0초로 선택된다.
        // 하지만 오늘을 선택하면 now 시간으로 설정된다.
        // 시 분 초를 떼고 0시 0분 0초로 만들어 insert하기 위한 작업
        String yearMonthDay = DateFormat('yyyy-MM-dd').format(dateTime);
        String alarmDateTime = '${yearMonthDay}T00:00:00.000';
        dateTime = DateTime.parse(alarmDateTime);
      }
      if (!dayOffDataList.any((element) => element.dayOffDate == dateTime)) {
        DayOffData dayOffData = DayOffData(id: id, dayOffDate: dateTime);
        _alarmProvider.insertDayOff(dayOffData);
        dayOffDataList.add(dayOffData);
        dayOffDataList.sort((a, b) => a.dayOffDate.compareTo(b.dayOffDate));
        update();
      }
    }
  }

  void deleteDayOff(int id, DateTime dateTime, int index) async {
    _alarmProvider.deleteDayOff(id, dateTime);
    dayOffDataList.removeAt(index);
    dayOffDataList.sort((a, b) => a.dayOffDate.compareTo(b.dayOffDate));
    update();
  }
}
