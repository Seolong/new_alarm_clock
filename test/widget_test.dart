// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/controller/repeat_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/controller/vibration_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/interval_text_field_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/month_repeat_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/year_repeat_day_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/required_parameter_to_add_alarm_page_controller.dart';

var log = [];


void main() async{
  // test('DateTimeCalculator test', overridePrint((){
  //
  //   String a = ABC.a.toString().split('.')[1];
  //
  //   expect(a, 'a1');
  // }));
  // final int last = 100000000000;
  // final stopWatch = Stopwatch();
  //
  // stopWatch.start();
  // double a = 0;
  // for(int i = 0; i < last; i++){
  //   a = 1.0;
  // }
  // print(stopWatch.elapsedMicroseconds);
  // stopWatch.stop();
  // stopWatch.reset();

  test ('', ()async{
    Get.put(RequiredParameterToAddAlarmPageController());
      // 페이지가 빌드 될 때마다 처음 init 상태로 되돌아가는 것을 막기 위함
      if (Get.find<RequiredParameterToAddAlarmPageController>().isFirstInit ==
          true) {
        AlarmProvider _alarmProvider = AlarmProvider();
        _alarmProvider.initializeDatabase();
        print(1);
        AlarmData alarmData = await _alarmProvider.getAlarmById(0);
        print('${alarmData.id}');
        expect(alarmData.id, 3);

        Get.find<RepeatModeController>().repeatMode = alarmData.alarmType;
        Get.find<VibrationRadioListController>().power = alarmData.vibrationBool;
        Get.find<VibrationRadioListController>()
            .initSelectedVibrationInEdit(alarmData.vibrationName);
        Get.find<RingRadioListController>().power = alarmData.musicBool;
        Get.find<RingRadioListController>().volume = alarmData.musicVolume;
        Get.find<RingRadioListController>()
            .initSelectedMusicPathInEdit(alarmData.musicPath);
        Get.find<RepeatRadioListController>().power = alarmData.repeatBool;
        Get.find<RepeatRadioListController>()
            .setAlarmIntervalWithInt(alarmData.repeatInterval);
        Get.find<RepeatRadioListController>()
            .setRepeatNumWithInt(alarmData.repeatNum);
        Get.find<IntervalTextFieldController>()
            .initTextFieldInEditRepeat(alarmData.alarmInterval);
        Get.find<MonthRepeatDayController>().initInEdit(alarmData.monthRepeatDay);
        Get.find<StartEndDayController>().setStart(alarmData.alarmDateTime);
        Get.find<StartEndDayController>().setEnd(alarmData.endDay);
        Get.find<YearRepeatDayController>().yearRepeatDay =
            alarmData.alarmDateTime;

        Get.find<RequiredParameterToAddAlarmPageController>().isFirstInit = false;
      }
  });

}

void Function() overridePrint(void testFn()) => () {
  var spec = new ZoneSpecification(
      print: (_, __, ___, String msg) {
        // Add to log instead of printing to stdout
        log.add(msg);
      }
  );
  return Zone.current.fork(specification: spec).run<void>(testFn);
};