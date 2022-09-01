import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:jiffy/jiffy.dart';

class MonthRepeatDayController extends GetxController {
  //29일은 말일
  final int lastDay = 29;
  int? _monthRepeatDay;
  String monthRepeatDayText = '';

  set monthRepeatDay(int? value) {
    _monthRepeatDay = value;
    if (_monthRepeatDay == null) {
      monthRepeatDayText = '';
    } else {
      if (value != 29) {
        monthRepeatDayText = LocaleKeys.prefixOnThe.tr() +
            Jiffy([2000, 01, _monthRepeatDay]).format('do') +
            LocaleKeys.suffixOnThe.tr();
      } else {
        monthRepeatDayText = '말일에';
      }
    }
    update();
  }

  int? get monthRepeatDay => _monthRepeatDay;

  void initInEdit(int? value) {
    monthRepeatDay = value;
    update();
  }
}
