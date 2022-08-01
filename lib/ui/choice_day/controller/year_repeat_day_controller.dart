import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:jiffy/jiffy.dart';

class YearRepeatDayController extends GetxController {
  DateTime _yearRepeatDay = DateTime.now();

  DateTime get yearRepeatDay => _yearRepeatDay;

  set yearRepeatDay(DateTime dateTime) {
    _yearRepeatDay = dateTime;
    print(_yearRepeatDay);
    update();
  }

  String getYearRepeatDay_monthDay() {
    return LocaleKeys.prefixOn.tr()
      +Jiffy(_yearRepeatDay).format('MMMM do')
        +LocaleKeys.suffixOn.tr();
  }
}
