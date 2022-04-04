import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/model/alarm_week_repeat_data.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/alarm_title_text_field_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/time_spinner_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/controller/vibration_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/interval_text_field_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/month_repaet_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:intl/intl.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';
import 'package:get/get.dart';

class SaveButton extends StatelessWidget {
  AlarmProvider _alarmProvider = AlarmProvider();
  RepeatModeController repeatModeController;
  TimeSpinnerController timeSpinnerController;
  StartEndDayController startEndDayController;
  AlarmTitleTextFieldController alarmTitleTextFieldController;
  DayOfWeekController dayOfWeekController;
  String mode;
  int alarmId;
  String currentFolderName;

  SaveButton(this.alarmId, this.mode, this.currentFolderName,
      {required this.repeatModeController,
      required this.timeSpinnerController,
      required this.startEndDayController,
      required this.alarmTitleTextFieldController,
      required this.dayOfWeekController});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          //선택, 반복 날짜와 timespinner의 시간을 합치기 위함
          if (repeatModeController.getRepeatMode() != RepeatMode.off) {
            String hourMinute = DateFormat.Hms()
                .format(timeSpinnerController.alarmDateTime)
                .toString();
            hourMinute += '.000';
            print(hourMinute);

            String yearMonthDay = DateFormat('yyyy-MM-dd')
                .format(startEndDayController.start['dateTime']);
            String alarmDateTime = yearMonthDay + 'T' + hourMinute;
            print(alarmDateTime);
            timeSpinnerController.alarmDateTime = DateTime.parse(alarmDateTime);
          }

          if(timeSpinnerController.alarmDateTime.isBefore(DateTime.now())){
            timeSpinnerController.alarmDateTime =
                timeSpinnerController.alarmDateTime.add(Duration(days: 1));
          }

          AlarmData alarmData = AlarmData(
            id: alarmId,
            alarmType: repeatModeController.getRepeatMode(),
            title: alarmTitleTextFieldController.textEditingController.text,
            alarmDateTime: timeSpinnerController.alarmDateTime,
            endDay: DateTime(2045),
            alarmState: true,
            alarmOrder: alarmId,
            folderName: currentFolderName,
            alarmInterval: Get.find<IntervalTextFieldController>().textEditingController.text == ''?
              0:
              int.parse(Get.find<IntervalTextFieldController>().textEditingController.text),
            dayOff: DateTime(2045),
            monthRepeatDay: Get.find<MonthRepeatDayController>().monthRepeatDay,
            musicBool: Get.find<RingRadioListController>().power,
            musicPath: Get.find<RingRadioListController>().selectedMusicPath,
            musicVolume: Get.find<RingRadioListController>().volume,
            vibrationBool: Get.find<VibrationRadioListController>().power,
            vibrationName: Get.find<VibrationRadioListController>().selectedVibration,
            repeatBool: false,
            repeatInterval: 0,
          );

          AlarmWeekRepeatData alarmWeekRepeatData = AlarmWeekRepeatData(
              id: alarmId,
              sunday: dayOfWeekController.dayButtonStateMap[DayWeek.Sun]!,
              monday: dayOfWeekController.dayButtonStateMap[DayWeek.Mon]!,
              tuesday: dayOfWeekController.dayButtonStateMap[DayWeek.Tue]!,
              wednesday: dayOfWeekController.dayButtonStateMap[DayWeek.Wed]!,
              thursday: dayOfWeekController.dayButtonStateMap[DayWeek.Thu]!,
              friday: dayOfWeekController.dayButtonStateMap[DayWeek.Fri]!,
              saturday: dayOfWeekController.dayButtonStateMap[DayWeek.Sat]!);

          if (mode == StringValue.addMode) {
            Get.find<AlarmListController>().inputAlarm(alarmData);
            if (repeatModeController.getRepeatMode() == RepeatMode.week) {
              _alarmProvider.insertAlarmWeekData(alarmWeekRepeatData);
            }
          } else if (mode == StringValue.editMode) {
            AlarmData alarmDataInDB = await _alarmProvider.getAlarmById(alarmId);
            int alarmOrder = alarmDataInDB.alarmOrder;
            alarmData.alarmOrder = alarmOrder;
            Get.find<AlarmListController>().updateAlarm(alarmData);
            if (repeatModeController.getRepeatMode() == RepeatMode.off) {
              AlarmWeekRepeatData? weekDataInDB =
                  await _alarmProvider.getAlarmWeekDataById(alarmId);
              if (weekDataInDB != null) {
                //weekData가 남아있으면 delete
                _alarmProvider.deleteAlarmWeekData(alarmId);
              }
            } else if (repeatModeController.getRepeatMode() ==
                RepeatMode.week) {
              AlarmWeekRepeatData? weekDataInDB =
                  await _alarmProvider.getAlarmWeekDataById(alarmId);
              if (weekDataInDB == null) {
                //print('I am insert!');
                _alarmProvider.insertAlarmWeekData(alarmWeekRepeatData);
              } else {
                //print(_alarmProvider.getAlarmWeekDataById(alarmId));
                //print('I am update!');
                _alarmProvider.updateAlarmWeekData(alarmWeekRepeatData);
              }
            }
          } else {
            print('error in 저장 button in AddAlarmPage');
          }
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: ColorValue.mainBackground,
          ));
          Get.back();
        },
        child: AutoSizeText(
          '저장',
          bold: true,
        )
    );
  }
}
