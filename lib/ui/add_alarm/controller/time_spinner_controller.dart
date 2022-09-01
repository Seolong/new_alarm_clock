import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'dart:async';
import 'package:new_alarm_clock/utils/enum.dart';

class TimeSpinnerController extends GetxController {
  String _alarmDateTime = '2000-01-01T00:00:00.000';
  final AlarmProvider _alarmProvider = AlarmProvider();
  Future<DateTime>? dateTimeFuture;
  RepeatMode repeatMode = Get.find<RepeatModeController>().repeatMode;

  @override
  void onInit() {
    _alarmDateTime =
        DateTime.now().add(const Duration(minutes: 5)).toIso8601String();
    dateTimeFuture = null;

    super.onInit();
  }

  set alarmDateTime(DateTime dateTime) {
    _alarmDateTime = dateTime.toIso8601String();
    update();
  }

  DateTime get alarmDateTime {
    return DateTime.parse(_alarmDateTime);
  }

  Future<void> initDateTimeInEdit(int alarmId) async {
    AlarmData alarmData = await _alarmProvider.getAlarmById(alarmId);
    repeatMode = alarmData.alarmType;
    dateTimeFuture = Future.value(alarmData.alarmDateTime);
    _alarmDateTime = alarmData.alarmDateTime.toIso8601String();
    update();
  }

  void initDateTimeInAdd() {
    _alarmDateTime =
        DateTime.now().add(const Duration(minutes: 5)).toIso8601String();
    dateTimeFuture = Future.value(DateTime.parse(_alarmDateTime));
  }

  void setDayInRepeatOff(DateTime value) {
    //DateTimePicker의 onDateTimeChanged의 value는 당일에서만 변경할 수 있다.
    //오늘이 21일이라면 21일 00시~23시 59분 59초...가 범위라는 뜻
    //saveButton 누를 때 필연적으로 년월일과 시분초를
    //각각의 controller에서 분리한 뒤 합치는 수밖에 없다.
    if (value.isBefore(DateTime.now())) {
      value = value.add(const Duration(days: 1));
      Get.find<StartEndDayController>().setStart(value);
    } else if (value.isAfter(DateTime.now())) {
      Get.find<StartEndDayController>().setStart(value);
    }
  }
}
