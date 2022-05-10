import 'package:get/get.dart';
import 'package:new_alarm_clock/main.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/add_alarm/add_alarm_page.dart';
import 'package:new_alarm_clock/ui/alarm_alarm/alarm_alarm_page.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/repeat_page.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/ring_page.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/vibration_page.dart';
import 'package:new_alarm_clock/ui/choice_day/choice_day_page.dart';
import 'package:new_alarm_clock/ui/day_off/day_off_page.dart';
import 'package:new_alarm_clock/ui/home/home_page.dart';

class AppPages{
  static final pages = [
    GetPage(name: AppRoutes.home, page: () {
        return (appState == 'alarm')? AlarmAlarmPage():HomePage();
    }),
    GetPage(name: AppRoutes.addAlarmPage, page: () => AddAlarmPage()),
    GetPage(name: AppRoutes.ringPage, page: () => RingPage()),
    GetPage(name: AppRoutes.vibrationPage, page: () => VibrationPage()),
    GetPage(name: AppRoutes.repeatPage, page: () => RepeatPage()),
    GetPage(name: AppRoutes.choiceDayPage, page: () => ChoiceDayPage()),
    GetPage(name: AppRoutes.dayOffPage, page: () => DayOffPage()),
    GetPage(name: AppRoutes.alarmAlarmPage, page: () => AlarmAlarmPage()),
  ];
}