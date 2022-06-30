import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_alarm_clock/service/date_time_calculator.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/year_repeat_day_controller.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/month_repeat_day_controller.dart';

class StartEndDayController extends GetxController {
  DateTime? endDateTime;
  final String dateTime = 'dateTime';
  final String monthDay = 'monthDay';
  final String year = 'year';

  Map<String, dynamic> _start = {
    'dateTime' : DateTime.now(),
    'monthDay': '',
    'year': ''
  };

  Map<String, dynamic> _end = {
    'dateTime': true ? null : DateTime(1), //이게 DateTime이란 걸 알려주는 얄팍한 속임수
    'monthDay': '',
    'year': ''
  };
  DateTimeCalculator dateTimeCalculator = DateTimeCalculator();

  @override
  void onInit() {
    _start[monthDay] = DateFormat('M월 d일').format(_start[dateTime]);
    _start[year] = DateFormat('yyyy년').format(_start[dateTime]);
    super.onInit();
  }

  Map<String, dynamic> get start => _start;

  Map<String, dynamic> get end => _end;

  void setStart(DateTime startDateTime) {
    DateTime? endTime = _end[dateTime];
    if (endTime == null ||
        (startDateTime.year <= endTime.year &&
            startDateTime.month <= endTime.month &&
            startDateTime.day <= endTime.day)) {
      _start[dateTime] = startDateTime;
      _start[monthDay] = DateFormat('M월 d일').format(_start[dateTime]);
      _start[year] = DateFormat('yyyy년').format(_start[dateTime]);
      update();
    }
  }

  void setEnd(DateTime? endDateTime) {
    _end[dateTime] = endDateTime;
    _end[monthDay] =
        endDateTime == null ? '' : DateFormat('M월 d일').format(_end[dateTime]);
    _end[year] =
        endDateTime == null ? '' : DateFormat('yyyy년').format(_end[dateTime]);
    update();
  }

  void setStartDayWithBackButton(RepeatMode repeatMode) {
    if (repeatMode == RepeatMode.week) {
      List<bool> weekBool = [];
      weekBool
          .add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Sun]!);
      weekBool
          .add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Mon]!);
      weekBool
          .add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Tue]!);
      weekBool
          .add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Wed]!);
      weekBool
          .add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Thu]!);
      weekBool
          .add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Fri]!);
      weekBool
          .add(Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Sat]!);
      setStart(dateTimeCalculator
          .getStartNearDay(repeatMode, _start[dateTime], weekBool: weekBool));
    } else if (repeatMode == RepeatMode.month) {
      setStart(dateTimeCalculator.getStartNearDay(
          repeatMode, _start[dateTime],
          monthRepeatDay: Get.find<MonthRepeatDayController>().monthRepeatDay!));
    } else if (repeatMode == RepeatMode.year) {
      setStart(dateTimeCalculator.getStartNearDay(
          repeatMode, _start[dateTime],
          yearRepeatDay: Get.find<YearRepeatDayController>().yearRepeatDay));
    } else {
      setStart(
          dateTimeCalculator.getStartNearDay(repeatMode, _start[dateTime]));
    }
  }
}
