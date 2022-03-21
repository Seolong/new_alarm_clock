import 'package:jiffy/jiffy.dart';
import 'package:new_alarm_clock/utils/enum.dart';

class DateTimeCalculator {
  DateTime _addDays(DateTime dateTime, int days) {
    DateTime resultDateTime = Jiffy(dateTime).add(days: days).dateTime;
    return resultDateTime;
  }

  // dateTime이
  // 일~토 중 true인 날 중에 마지막 날이면
  // 마지막 날을 weeks만큼 보내고
  // 보내진 마지막 날에서 하나씩 빼면서
  // 맨 앞 요일로 newShot
  // newShot은 알람해제 버튼에서
  // 왜냐하면 alarmEndDay 고려하려고
  DateTime _addWeeks(DateTime currentDateTime, int weeks, List<bool> weekBool) {
    DateTime resultDateTime;
    int weekday = currentDateTime.weekday;
    if(weekday == DateTime.sunday){ // 0을 sunday로 6 == saturday
      weekday = 0;
    }
    int lastWeekday = 0;
    for(int i=1; i<=6; i++){ //list에서 true인 애들 중 마지막 요일
      if(weekBool[i] == true){
        lastWeekday = i;
      }
    }
    if(lastWeekday != weekday){
      int nextWeekDay = weekday+1;
      for(int i=weekday+2; i<=lastWeekday; i++){// 다음 요일은?
        if(weekBool[i] == true){
          nextWeekDay = i;
        }
      }
      int difference = nextWeekDay - weekday;
      resultDateTime = Jiffy(currentDateTime).add(days: difference).dateTime;
    }
    else{//지금 알람이 마지막 요일이라면
      resultDateTime = Jiffy(currentDateTime).add(weeks: weeks).dateTime;
      int firstWeekDay = 6;
      for(int i=5; i>=0; i--){ //list에서 true인 애들 중 첫 요일
        if(weekBool[i] == true){
          firstWeekDay = i;
        }
      }
      int difference = weekday - firstWeekDay;
      //첫 요일까지 빼기
      resultDateTime = Jiffy(resultDateTime).subtract(days: difference).dateTime;
    }

    return resultDateTime;
  }

  DateTime _addMonths(DateTime dateTime, int months, {bool lastDay = false}) {
    if (lastDay == true) {
      DateTime real =
          Jiffy(dateTime).add(months: months).endOf(Units.MONTH).dateTime;
      return real;
    }

    DateTime resultDateTime = Jiffy(dateTime).add(months: months).dateTime;
    return resultDateTime;
  }

  DateTime _addYears(DateTime dateTime, int years) {
    DateTime resultDateTime = Jiffy(dateTime).add(years: years).dateTime;
    return resultDateTime;
  }

  DateTime addDateTime(RepeatMode repeatMode, DateTime dateTime, int interval,
      {List<bool>? weekBool, bool lastDay = false}) {
    switch (repeatMode) {
      case RepeatMode.day:
        return _addDays(dateTime, interval);
      case RepeatMode.week:
        return _addWeeks(dateTime, interval, weekBool!);
      case RepeatMode.month:
        return _addMonths(dateTime, interval, lastDay: lastDay);
      case RepeatMode.year:
        return _addYears(dateTime, interval);
      default:
        assert(false, 'addDateTime error in DateTimeCalculator');
        return DateTime.now();
    }
  }
}
