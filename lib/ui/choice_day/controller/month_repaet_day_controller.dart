import 'package:get/get.dart';

class MonthRepeatDayController extends GetxController {
  //29일은 말일
  int? _monthRepeatDay = null;
  String monthRepeatDayText = '';

  set monthRepeatDay(int? value) {
    _monthRepeatDay = value;
    if (value != 29) {
      monthRepeatDayText = '${_monthRepeatDay}일에';
    } else {
      monthRepeatDayText = '말일에';
    }
    update();
  }

  int? get monthRepeatDay => _monthRepeatDay;

  void initInEdit(int? value) {
    _monthRepeatDay = value;
    update();
  }
}
