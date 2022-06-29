import 'package:jiffy/jiffy.dart';
import 'package:new_alarm_clock/utils/enum.dart';

// jiffy 쓰는 이유
//It works but the problem is in momentjs/c#
// if you substract 6 months from 2000-08-31
// you get 2000-02-29 and with dart you get 2000-03-02,
// which not so nice at all.

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
    int getLastTrue(){
      int lastTrueIndex = 0;
      for(int i=1; i<=weekBool.length-1; i++){ //list에서 true인 애들 중 마지막 요일
        if(weekBool[i] == true){
          lastTrueIndex = i;
        }
      }
      return lastTrueIndex;
    }
    int getFirstTrue(){
      int firstTrueIndex = weekBool.length-1;
      for(int i=weekBool.length-2; i>=0; i--){ //list에서 true인 애들 중 첫 요일
        if(weekBool[i] == true){
          firstTrueIndex = i;
        }
      }
      return firstTrueIndex;
    }

    DateTime resultDateTime;
    int weekday = currentDateTime.weekday;
    if(weekday == DateTime.sunday){ // 0을 sunday로 6 == saturday
      weekday = 0;
    }
    int lastWeekday = getLastTrue();
    if(lastWeekday != weekday){
      int nextWeekDay = weekday+1;
      for(int i=weekday+1; i<=lastWeekday; i++){// 다음 요일은?
        if(weekBool[i] == true){
          nextWeekDay = i;
          break;
        }
      }
      int difference = nextWeekDay - weekday;
      resultDateTime = Jiffy(currentDateTime).add(days: difference).dateTime;
    }
    else{//지금 알람이 마지막 요일이라면
      resultDateTime = Jiffy(currentDateTime).add(weeks: weeks).dateTime;
      int firstWeekDay = getFirstTrue();
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

  DateTime _getStartNearWeekDay(DateTime currentStartDateTime, List<bool> weekBool){
    int getDifferenceBetweenCurrentDayAndNextNearDay(int currentWeekDay){
      for(int difference=1; difference<=6; difference++){
        if(weekBool[(currentWeekDay+difference)%7] == true){
          return difference;
        }
      }
      assert(false, 'error in _getStartNearWeekDay of DateTimeCalculator');
      return -1;
    }

    int currentWeekDay = currentStartDateTime.weekday;
    if(currentWeekDay == DateTime.sunday){ //일요일을 0으로
      currentWeekDay = 0;
    }
    if(weekBool[currentWeekDay] == false){
      int difference = getDifferenceBetweenCurrentDayAndNextNearDay(currentWeekDay);
      return Jiffy(currentStartDateTime).add(days: difference).dateTime;
    }
    else{
      return currentStartDateTime;
    }
  }

  DateTime _getStartNearMonthDay(DateTime currentStartDateTime, int monthDay){
    if(monthDay == 29){
      if(currentStartDateTime.isBefore(DateTime.now())){
        return Jiffy(currentStartDateTime).add(months: 1).endOf(Units.MONTH).dateTime;
      }
      return Jiffy(currentStartDateTime).endOf(Units.MONTH).dateTime;
    }
    if(currentStartDateTime.day < monthDay){
      int difference = monthDay - currentStartDateTime.day;
      return currentStartDateTime.add(Duration(days: difference));
    }
    else if(currentStartDateTime.day > monthDay){
      int difference = currentStartDateTime.day - monthDay;
      return currentStartDateTime.subtract(Duration(days: difference));
    }
    else{ //currentStartDateTime.day == monthDay
      return currentStartDateTime;
    }
  }

  DateTime _getStartNearYearDay(DateTime currentStartDateTime, DateTime yearRepeatDay){
    DateTime now = DateTime.now();
    DateTime thisYearRepeatDay = DateTime(now.year, yearRepeatDay.month,
      yearRepeatDay.day);
    DateTime thisYearStartDay = DateTime(now.year, currentStartDateTime.month,
      currentStartDateTime.day);
    //DateTime yearRepeatDay
    //서로 연도 맞춘 다음에 비교해라
    if(thisYearStartDay.isBefore(thisYearRepeatDay)){
      return yearRepeatDay;
    }
    else if(thisYearStartDay.isAfter(thisYearRepeatDay)){
      return Jiffy(yearRepeatDay).add(years: 1).dateTime;
    }
    else{ // currentStartDateTime == yearRepeatDay
      return currentStartDateTime;
    }
  }

  DateTime getStartNearDay(RepeatMode repeatMode, DateTime currentStartDateTime,
  {List<bool>? weekBool, int? monthDay, DateTime? yearRepeatDay}){
    switch(repeatMode){
      case RepeatMode.off:
        return DateTime.now();
      case RepeatMode.day:
        return currentStartDateTime;
      case RepeatMode.week:
        return _getStartNearWeekDay(currentStartDateTime, weekBool!);
      case RepeatMode.month:
        return _getStartNearMonthDay(currentStartDateTime, monthDay!);
      case RepeatMode.year:
        return _getStartNearYearDay(currentStartDateTime, yearRepeatDay!);
      default:
        assert(false, 'error in getStartNearDay of DateTimeCalculator');
        return DateTime.now();
    }
  }
}
