import 'package:get/get.dart';
import 'package:intl/intl.dart';

class YearRepeatDayController extends GetxController{
  Rx<DateTime> _yearRepeatDay = DateTime.now().obs;

  DateTime get yearRepeatDay => _yearRepeatDay.value;
  set yearRepeatDay(DateTime dateTime){
    _yearRepeatDay = dateTime.obs;
    print(_yearRepeatDay.value);
    update();
  }

  String getYearRepeatDay_monthDay(){
    return DateFormat('MM월 dd일에').format(_yearRepeatDay.value);
  }
}