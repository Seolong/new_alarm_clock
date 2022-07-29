import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/day_off_data.dart';
import 'package:new_alarm_clock/service/date_time_calculator.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/year_repeat_day_controller.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/month_repeat_day_controller.dart';
import 'interval_text_field_controller.dart';

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
    _start[monthDay] = Jiffy(_start[dateTime]).MMMMd;
    _start[year] = DateFormat(LocaleKeys.yearFormat.tr()).format(_start[dateTime]);
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
      _start[monthDay] = Jiffy(_start[dateTime]).MMMMd;
      _start[year] = DateFormat(LocaleKeys.yearFormat.tr()).format(_start[dateTime]);
      update();
    }
  }

  void setEnd(DateTime? endDateTime) {
    _end[dateTime] = endDateTime;
    _end[monthDay] =
        endDateTime == null ? '' : Jiffy(_end[dateTime]).MMMMd;
    _end[year] =
        endDateTime == null ? '' : DateFormat(LocaleKeys.yearFormat.tr()).format(_end[dateTime]);
    update();
  }

  void setStartDayWithBackButton(RepeatMode repeatMode) {
    if (repeatMode == RepeatMode.week) {
      List<bool> weekBool = [];
      for (var weekDayBool in DayWeek.values) {
        weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[weekDayBool]!);
      }
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

  void skipNextAlarmDate(int alarmId) async{
    bool isLastDay() {
      return Get.find<MonthRepeatDayController>().monthRepeatDay == 29;
    }
    bool isSameDate(DateTime day1, DateTime day2){
      return (day1.year == day2.year && day1.month == day2.month
      && day1.day == day2.day);
    }
    AlarmProvider alarmProvider = AlarmProvider();
    List<DayOffData> dayOffList = await alarmProvider.getDayOffsById(alarmId);

    List<bool> weekBool = [];
    for (var weekDayBool in DayWeek.values) {
      weekBool.add(Get.find<DayOfWeekController>().dayButtonStateMap[weekDayBool]!);
    }
    DateTimeCalculator dateTimeCalculator = DateTimeCalculator();
    DateTime nextDate =
      dateTimeCalculator.addDateTime(
          Get.find<RepeatModeController>().repeatMode,
          start['dateTime'],
          Get.find<IntervalTextFieldController>().getInterval(),
          weekBool: weekBool,
          lastDay: isLastDay()
      );
    while(dayOffList.any((element) => isSameDate(element.dayOffDate, nextDate))){
      nextDate =
          dateTimeCalculator.addDateTime(
              Get.find<RepeatModeController>().repeatMode,
              nextDate,
              Get.find<IntervalTextFieldController>().getInterval(),
              weekBool: weekBool,
              lastDay: isLastDay()
          );
    }
    setStart(nextDate);
  }

  void resetDateWhenMonthRepeat(DateTime alarmTime){
    // 예를 들어 오늘이 6월 28일인데
    // 설정은 13일로 하면
    // 다음 알람일이 6월 13일이 돼버린다
    // 그거 해결
    alarmTime = DateTime(alarmTime.year, alarmTime.month,
        Get.find<MonthRepeatDayController>().monthRepeatDay!,
        alarmTime.hour, alarmTime.minute);
    if(alarmTime.isBefore(DateTime.now())){
      DateTimeCalculator dateTimeCalculator = DateTimeCalculator();
      if(Get.find<MonthRepeatDayController>().monthRepeatDay!
          == Get.find<MonthRepeatDayController>().lastDay){
        alarmTime = dateTimeCalculator.addDateTime(RepeatMode.month, alarmTime, 1, lastDay: true);
      }
      else{
        alarmTime = dateTimeCalculator.addDateTime(RepeatMode.month, alarmTime, 1, lastDay: false);
      }
    }
    setStart(alarmTime);
  }
}
