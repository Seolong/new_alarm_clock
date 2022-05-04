import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_alarm_clock/service/date_time_calculator.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/year_repeat_day_controller.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/month_repaet_day_controller.dart';

class StartEndDayController extends GetxController{
  DateTime? endDateTime;

  RxMap<String, dynamic> _start = {
    'dateTime' : DateTime.now(),
    'monthDay' : '',
    'year' : ''
  }.obs;

  RxMap<String, dynamic> _end = {
    'dateTime' : true? null: DateTime(1), //이게 DateTime이란 걸 알려주는 얄팍한 속임수
    'monthDay' : '',
    'year' : ''
  }.obs;
  DateTimeCalculator dateTimeCalculator = DateTimeCalculator();

  @override
  void onInit() {
    _start['monthDay'] = DateFormat('M월 d일').format(_start['dateTime']);
    _start['year'] = DateFormat('yyyy년').format(_start['dateTime']);
    super.onInit();
  }

  RxMap<String, dynamic> get start => _start;
  RxMap<String, dynamic> get end => _end;

  void setStart(DateTime dateTime){
    DateTime? endTime = _end['dateTime'];
    if (endTime != null && dateTime.year <= endTime.year && dateTime.month <= endTime.month
    && dateTime.day <= endTime.day) {
      _start['dateTime'] = dateTime;
      _start['monthDay'] = DateFormat('M월 d일').format(_start['dateTime']);
      _start['year'] = DateFormat('yyyy년').format(_start['dateTime']);
      update();
    }
  }

  void setEnd(DateTime? dateTime){
    _end['dateTime'] = dateTime;
    _end['monthDay'] = dateTime == null ? '': DateFormat('M월 d일').format(_end['dateTime']);
    _end['year'] = dateTime == null ? '': DateFormat('yyyy년').format(_end['dateTime']);
    update();
  }

  void setStartDayWithBackButton(RepeatMode repeatMode){
    if(repeatMode == RepeatMode.week){
      List<bool> weekBool = [];
      weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Sun]!);
      weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Mon]!);
      weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Tue]!);
      weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Wed]!);
      weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Thu]!);
      weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Fri]!);
      weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Sat]!);
      setStart(dateTimeCalculator.getStartNearDay(repeatMode, _start['dateTime'],
        weekBool: weekBool));
    }
    else if(repeatMode == RepeatMode.month){
      setStart(
          dateTimeCalculator.getStartNearDay(repeatMode, _start['dateTime'],
              monthDay: Get.find<MonthRepeatDayController>().monthRepeatDay!));
    }else if(repeatMode == RepeatMode.year){
      setStart(
          dateTimeCalculator.getStartNearDay(repeatMode, _start['dateTime'],
            yearRepeatDay: Get.find<YearRepeatDayController>().yearRepeatDay));
    }
    else{
      setStart(
          dateTimeCalculator.getStartNearDay(repeatMode, _start['dateTime']));
    }
  }

  // void setEndDayWithBackButton(RepeatMode repeatMode){
  //   int interval = Get.find<IntervalTextFieldController>().textEditingController.text == ''?
  //     1:int.parse(Get.find<IntervalTextFieldController>().textEditingController.text);
  //   if(repeatMode == RepeatMode.week){
  //     List<bool> weekBool = [];
  //     weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Sun]!);
  //     weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Mon]!);
  //     weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Tue]!);
  //     weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Wed]!);
  //     weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Thu]!);
  //     weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Fri]!);
  //     weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Sat]!);
  //     setEnd(dateTimeCalculator.getEndNearDay(repeatMode, _start['dateTime'], _end['dateTime'],
  //         interval, weekBool: weekBool));
  //   }
  //   else if(repeatMode == RepeatMode.month){
  //     int monthDay = Get.find<MonthRepeatDayController>().monthRepeatDay!;
  //     bool lastDay = (monthDay == 32) ? true:false;
  //     setEnd(dateTimeCalculator.getEndNearDay(repeatMode, _start['dateTime'], _end['dateTime'],
  //         interval, lastDay: lastDay));
  //   }else if(repeatMode == RepeatMode.year){
  //     setEnd(dateTimeCalculator.getEndNearDay(repeatMode, _start['dateTime'], _end['dateTime'],
  //         interval));
  //   }
  //   else{
  //     setEnd(dateTimeCalculator.getEndNearDay(repeatMode, _start['dateTime'], _end['dateTime'],
  //         interval));
  //   }
  // }
}