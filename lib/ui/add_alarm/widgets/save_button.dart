import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/model/alarm_week_repeat_data.dart';
import 'package:new_alarm_clock/service/date_time_calculator.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/alarm_title_text_field_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/time_spinner_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/controller/repeat_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/controller/vibration_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/interval_text_field_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/month_repeat_day_controller.dart';
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
  String mode;
  int alarmId;
  String currentFolderName;

  SaveButton(this.alarmId, this.mode, this.currentFolderName);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          //선택, 반복 날짜와 timespinner의 시간을 합치기 위함
          String hourMinute = DateFormat.Hm()
              .format(Get.find<TimeSpinnerController>().alarmDateTime)
              .toString();
          hourMinute += ':00.000';
          print(hourMinute);

          setStartDay(hourMinute);

          DateTime? endDay;
          if (Get.find<StartEndDayController>().end['dateTime'] != null) {
            endDay = getEndDay(hourMinute);
          }

          AlarmData alarmData = AlarmData(
            id: alarmId,
            alarmType: Get.find<RepeatModeController>().getRepeatMode(),
            title: Get.find<AlarmTitleTextFieldController>().textEditingController.text,
            alarmDateTime: Get.find<TimeSpinnerController>().alarmDateTime,
            endDay: endDay,
            alarmState: true,
            alarmOrder: alarmId,
            folderName: currentFolderName,
            alarmInterval: Get.find<IntervalTextFieldController>()
                        .textEditingController
                        .text ==
                    ''
                ? 0
                : int.parse(Get.find<IntervalTextFieldController>()
                    .textEditingController
                    .text),
            monthRepeatDay: Get.find<MonthRepeatDayController>().monthRepeatDay,
            musicBool: Get.find<RingRadioListController>().power,
            musicPath: Get.find<RingRadioListController>().selectedMusicPath,
            musicVolume: Get.find<RingRadioListController>().volume,
            vibrationBool: Get.find<VibrationRadioListController>().power,
            vibrationName:
                Get.find<VibrationRadioListController>().selectedVibration,
            repeatBool: Get.find<RepeatRadioListController>().power,
            repeatInterval:
                Get.find<RepeatRadioListController>().getIntervalAsInt(),
            repeatNum:
                Get.find<RepeatRadioListController>().getRepeatNumAsInt(),
          );

          AlarmWeekRepeatData alarmWeekRepeatData = AlarmWeekRepeatData(
              id: alarmId,
              sunday: Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Sun]!,
              monday: Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Mon]!,
              tuesday: Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Tue]!,
              wednesday: Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Wed]!,
              thursday: Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Thu]!,
              friday: Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Fri]!,
              saturday: Get.find<DayOfWeekController>().dayButtonStateMap[DayWeek.Sat]!);

          if (mode == StringValue.addMode) {
            if (Get.find<RepeatModeController>().getRepeatMode() == RepeatMode.week) {
              List<bool> weekBool = [];
              for (var weekDayBool in DayWeek.values) {
                weekBool
                    .add(Get.find<DayOfWeekController>().dayButtonStateMap[weekDayBool]!);
              }
              alarmData.alarmDateTime = DateTimeCalculator().getStartNearDay(
                  alarmData.alarmType, alarmData.alarmDateTime,
                  weekBool: weekBool);
              _alarmProvider.insertAlarmWeekData(alarmWeekRepeatData);
            }
            Get.find<AlarmListController>().inputAlarm(alarmData);
          } else if (mode == StringValue.editMode) {
            AlarmData alarmDataInDB =
                await _alarmProvider.getAlarmById(alarmId);
            int alarmOrder = alarmDataInDB.alarmOrder;
            alarmData.alarmOrder = alarmOrder;
            if (Get.find<RepeatModeController>().getRepeatMode() == RepeatMode.off) {
              AlarmWeekRepeatData? weekDataInDB =
                  await _alarmProvider.getAlarmWeekDataById(alarmId);
              if (weekDataInDB != null) {
                //weekData가 남아있으면 delete
                _alarmProvider.deleteAlarmWeekData(alarmId);
              }
            } else if (Get.find<RepeatModeController>().getRepeatMode() ==
                RepeatMode.week) {
              AlarmWeekRepeatData? weekDataInDB =
                  await _alarmProvider.getAlarmWeekDataById(alarmId);
              if (weekDataInDB == null) {
                _alarmProvider.insertAlarmWeekData(alarmWeekRepeatData);
              } else {
                _alarmProvider.updateAlarmWeekData(alarmWeekRepeatData);
              }
            }

            // editmode일 때 다음 알람이 now보다 더 전이면
            // 저장 바로 누르면 알람 바로 울리는 거 해결
            // 몇달 전? 이런 건 테스트 안 해봄
            if(alarmData.alarmType != RepeatMode.off && alarmData.alarmType != RepeatMode.single){
              List<bool> weekBool = [];
              if (alarmData.alarmType == RepeatMode.week) {
                weekBool.add(alarmWeekRepeatData.sunday);
                weekBool.add(alarmWeekRepeatData.monday);
                weekBool.add(alarmWeekRepeatData.tuesday);
                weekBool.add(alarmWeekRepeatData.wednesday);
                weekBool.add(alarmWeekRepeatData.thursday);
                weekBool.add(alarmWeekRepeatData.friday);
                weekBool.add(alarmWeekRepeatData.saturday);
              }
              while (alarmData.alarmDateTime.isBefore(DateTime.now())) {
                alarmData.alarmDateTime =
                    alarmData.alarmDateTime.add(Duration(days: 1));
                alarmData.alarmDateTime = DateTimeCalculator().getStartNearDay(
                    alarmData.alarmType, alarmData.alarmDateTime,
                    weekBool: weekBool,
                    monthRepeatDay: alarmData.monthRepeatDay,
                    yearRepeatDay: alarmData.alarmDateTime);
              }
              alarmData.alarmDateTime = DateTimeCalculator().getStartNearDay(
                  alarmData.alarmType, alarmData.alarmDateTime,
                  weekBool: weekBool,
                  monthRepeatDay: alarmData.monthRepeatDay,
                  yearRepeatDay: alarmData.alarmDateTime);
            } else{
              while(alarmData.alarmDateTime.isBefore(DateTime.now())){
                alarmData.alarmDateTime =
                    alarmData.alarmDateTime.add(Duration(days: 1));
              }
            }
            Get.find<AlarmListController>().updateAlarm(alarmData);
          } else {
            print('error in 저장 button in AddAlarmPage');
          }
          SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: ColorValue.mainBackground,
          ));
          Get.back();
        },
        child: AutoSizeText(
          '저장',
          bold: true,
        ));
  }

  void setStartDay(String hourMinute){
    String yearMonthDay = DateFormat('yyyy-MM-dd')
        .format(Get.find<StartEndDayController>().start['dateTime']);
    String alarmDateTime = yearMonthDay + 'T' + hourMinute;
    print('SaveButton: $alarmDateTime');
    Get.find<TimeSpinnerController>().alarmDateTime = DateTime.parse(alarmDateTime);

    if (Get.find<TimeSpinnerController>().alarmDateTime.isBefore(DateTime.now())) {
      Get.find<TimeSpinnerController>().alarmDateTime =
          Get.find<TimeSpinnerController>().alarmDateTime.add(Duration(days: 1));
    }
  }

  DateTime getEndDay(String hourMinute){
    String yearMonthDay_end = DateFormat('yyyy-MM-dd')
        .format(Get.find<StartEndDayController>().end['dateTime']);
    String endDateTime = yearMonthDay_end + 'T' + hourMinute;
    return DateTime.parse(endDateTime);
  }
}
