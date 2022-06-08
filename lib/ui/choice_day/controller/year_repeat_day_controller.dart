import 'package:get/get.dart';
import 'package:intl/intl.dart';

class YearRepeatDayController extends GetxController {
  DateTime _yearRepeatDay = DateTime.now();

  DateTime get yearRepeatDay => _yearRepeatDay;

  set yearRepeatDay(DateTime dateTime) {
    _yearRepeatDay = dateTime;
    print(_yearRepeatDay);
    update();
  }

  String getYearRepeatDay_monthDay() {
    return DateFormat('M월 d일에').format(_yearRepeatDay);
  }
}
