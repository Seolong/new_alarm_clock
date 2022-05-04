import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/day_off_data.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/widget_all/calendar_dialog.dart';

class DayOffListController extends GetxController{
  AlarmProvider _alarmProvider = AlarmProvider();
  RxList<DayOffData> dayOffDataList = RxList<DayOffData>();
  late int id;

  void initDayOffDataList() async{
    var dayOffDataList_value = await _alarmProvider.getDayOffsById(id);
    dayOffDataList = dayOffDataList_value.obs;

    for(int i=dayOffDataList.length-1; i>=0; i--){
      // 2022-01-01 00:00.000000 이렇게 저장되는데 1월 1일 1시 알람인데 삭제해버리면 곤란하니까
      if(dayOffDataList[i].dayOffDate.isBefore(DateTime.now().subtract(Duration(days: 1)))){
        deleteDayOff(id, dayOffDataList[i].dayOffDate, i);
      }
    }

    dayOffDataList.sort((a, b) => a.dayOffDate.compareTo(b.dayOffDate));
    update();
  }

  String getDayExceptHour(int index){
    String result;
    result = '${dayOffDataList[index].dayOffDate.year}년 '
        '${dayOffDataList[index].dayOffDate.month}월 '
        '${dayOffDataList[index].dayOffDate.day}일';
    return result;
  }

  void insertDayOff() async{
    DateTime now = DateTime.now();
    DateTime dateTime = await Get.dialog(AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: CalendarDialog(
            now)));
    if(dateTime.year==now.year && dateTime.month==now.month && dateTime.day==now.day){
      String yearMonthDay = DateFormat('yyyy-MM-dd')
          .format(dateTime);
      String alarmDateTime = yearMonthDay + 'T' + '00:00:00.000';
      dateTime = DateTime.parse(alarmDateTime);
    }
    if(!dayOffDataList.any((element)=>element.dayOffDate == dateTime)){
      DayOffData dayOffData = DayOffData(id: id, dayOffDate: dateTime);
      _alarmProvider.insertDayOff(dayOffData);
      dayOffDataList.add(dayOffData);
      dayOffDataList.sort((a, b) => a.dayOffDate.compareTo(b.dayOffDate));
      update();
    }
  }

  void deleteDayOff(int id, DateTime dateTime, int index) async{
    _alarmProvider.deleteDayOff(id, dateTime);
    dayOffDataList.removeAt(index);
    dayOffDataList.sort((a, b) => a.dayOffDate.compareTo(b.dayOffDate));
    update();
  }
}