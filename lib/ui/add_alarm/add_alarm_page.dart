import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/model/alarm_week_repeat_data.dart';
import 'package:new_alarm_clock/data/shared_preferences/id_shared_preferences.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/alarm_title_text_field_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/time_spinner_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/day_button.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_list_tile_factory.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/time_spinner.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';
import 'package:intl/intl.dart';

final String toBeAddedIdName = 'toBeAddedId';

//이 페이지로 올때 메인페이지에서 get.to 할때 인자들 넘겨주기(이름, id, 설정한 음악 이름, 등등)
//id만 넘기고 데이터베이스에서 가져오는 것도 괜찮을 듯
class AddAlarmPage extends StatelessWidget {
  String mode = '';
  int alarmId = -1;
  AlarmProvider _alarmProvider = AlarmProvider();
  final AlarmDetailListTileFactory _alarmDetailListTileFactory =
      AlarmDetailListTileFactory();
  final IdSharedPreferences idSharedPreferences = IdSharedPreferences();

  Future<void> initEditAlarm() async {
    AlarmData alarmData = await _alarmProvider.getAlarmById(alarmId);

    Get.find<RepeatModeController>().repeatMode = alarmData.alarmType;
    RepeatMode? repeatMode = Get.find<RepeatModeController>().getRepeatMode();
    Get.find<TimeSpinnerController>().alarmDateTime = alarmData.alarmDateTime;
    //timespinner에는 적용이 안 되는 듯. stateful이어야 initial을 쓸 수 있는 것 같다.
    print(Get.find<TimeSpinnerController>().alarmDateTime);

    if (repeatMode == RepeatMode.week) {
      Get.find<DayOfWeekController>().initWhenEditMode(alarmId);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> argFromPreviousPage = Get.arguments;
    mode = argFromPreviousPage[StringValue.mode]; //add or edit
    alarmId = argFromPreviousPage[StringValue.alarmId];

    final repeatModeController = Get.put(RepeatModeController());
    final dayOfWeekController = Get.put(DayOfWeekController());
    Get.put(AlarmTitleTextFieldController());
    final timeSpinnerController = Get.put(TimeSpinnerController());
    final startEndDayController = Get.put(StartEndDayController());

    if (mode == StringValue.editMode) {
      initEditAlarm();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: ColorValue.appbar,
        foregroundColor: ColorValue.appbarText,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: TextButton(
                  onPressed: () async {
                    print(repeatModeController.getRepeatMode());
                    if (repeatModeController.getRepeatMode() !=
                        RepeatMode.off) {
                      String hourMinute = DateFormat.Hms()
                          .format(timeSpinnerController.alarmDateTime)
                          .toString();
                      hourMinute += '.000';
                      print(hourMinute);

                      String yearMonthDay = DateFormat('yyyy-MM-dd')
                          .format(startEndDayController.start['dateTime']);
                      String alarmDateTime = yearMonthDay + 'T' + hourMinute;
                      print(alarmDateTime);
                      timeSpinnerController.alarmDateTime =
                          DateTime.parse(alarmDateTime);
                    }

                    AlarmData alarmData = AlarmData(
                      id: alarmId,
                      alarmType: repeatModeController.getRepeatMode(),
                      title: 'title',
                      alarmDateTime:
                          Get.find<TimeSpinnerController>().alarmDateTime,
                      endDay: DateTime(2045),
                      alarmState: true,
                      folderName: '전체 알람',
                      alarmInterval: 0,
                      dayOff: DateTime(2045),
                      musicBool: false,
                      musicPath: 'path',
                      vibrationBool: false,
                      vibrationName: 'vibName',
                      repeatBool: false,
                      repeatInterval: 0,
                    );

                    AlarmWeekRepeatData alarmWeekRepeatData =
                        AlarmWeekRepeatData(
                            id: alarmId,
                            sunday: dayOfWeekController
                                .dayButtonStateMap[DayWeek.Sun]!,
                            monday: dayOfWeekController
                                .dayButtonStateMap[DayWeek.Mon]!,
                            tuesday: dayOfWeekController
                                .dayButtonStateMap[DayWeek.Tue]!,
                            wednesday: dayOfWeekController
                                .dayButtonStateMap[DayWeek.Wed]!,
                            thursday: dayOfWeekController
                                .dayButtonStateMap[DayWeek.Thu]!,
                            friday: dayOfWeekController
                                .dayButtonStateMap[DayWeek.Fri]!,
                            saturday: dayOfWeekController
                                .dayButtonStateMap[DayWeek.Sat]!);

                    if (mode == StringValue.addMode) {
                      Get.find<AlarmListController>().inputAlarm(alarmData);
                      if (repeatModeController.getRepeatMode() ==
                          RepeatMode.week) {
                        _alarmProvider.insertAlarmWeekData(alarmWeekRepeatData);
                      }
                    } else if (mode == StringValue.editMode) {
                      Get.find<AlarmListController>().updateAlarm(alarmData);
                      if (repeatModeController.getRepeatMode() ==
                          RepeatMode.week) {
                        AlarmWeekRepeatData? weekDataInDB =
                          await _alarmProvider.getAlarmWeekDataById(alarmId);
                        if(weekDataInDB == null){
                          //print('I am insert!');
                          _alarmProvider.insertAlarmWeekData(alarmWeekRepeatData);
                        } else{
                          //print(_alarmProvider.getAlarmWeekDataById(alarmId));
                          //print('I am update!');
                          _alarmProvider.updateAlarmWeekData(alarmWeekRepeatData);
                        }
                      }
                    } else {
                      print('error in 저장 button in AddAlarmPage');
                    }
                    Get.back();
                  },
                  child: Text(
                    '저장',
                    style: TextStyle(
                        fontSize: 1000,
                        color: ColorValue.appbarText,
                        fontWeight: FontWeight.bold,
                        fontFamily: MyFontFamily.mainFontFamily),
                  )),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          color: ColorValue.addAlarmPageBackground,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: [
              //spinner
              Expanded(flex: 5, child: TimeSpinner(fontSize: 27)),

              Divider(
                thickness: 2,
              ),

              //DaysOfAlarm
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: GetBuilder<DayOfWeekController>(
                          //editMode에다가 WeekMode여야 한다
                          initState: (_) => mode == StringValue.editMode
                              ? dayOfWeekController.initWhenEditMode(alarmId)
                              : null,
                          builder: (_) => LayoutBuilder(
                            builder: (BuildContext context,
                                    BoxConstraints constraints) =>
                                Row(
                              children: [
                                Expanded(
                                    child:
                                        DayButton(constraints, DayWeek.Sun, _)),
                                Expanded(
                                    child:
                                        DayButton(constraints, DayWeek.Mon, _)),
                                Expanded(
                                    child:
                                        DayButton(constraints, DayWeek.Tue, _)),
                                Expanded(
                                    child:
                                        DayButton(constraints, DayWeek.Wed, _)),
                                Expanded(
                                    child:
                                        DayButton(constraints, DayWeek.Thu, _)),
                                Expanded(
                                    child:
                                        DayButton(constraints, DayWeek.Fri, _)),
                                Expanded(
                                    child:
                                        DayButton(constraints, DayWeek.Sat, _)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    //ChoiceDayButton
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: GestureDetector(
                          child: Icon(
                            Icons.today,
                            color: ColorValue.calendarIcon,
                            size: 1000,
                          ),
                          onTap: () {
                            Get.toNamed(AppRoutes.choiceDayPage);
                          },
                        )),
                  ],
                ),
              ),

              Expanded(
                flex: 1,
                child: Text(
                  //임시
                  Get.find<TimeSpinnerController>().alarmDateTime.toString(),
                ),
              ),

              Expanded(
                flex: 2,
                //TitleTextField
                child: GetBuilder<AlarmTitleTextFieldController>(
                  builder: (_) => TextField(
                    controller: _.textEditingController,
                    onChanged: (value) {
                      if (_.textEditingController.text.length != 0) {
                        print('length not 0');
                      } else {
                        print('length 0');
                      }
                    },
                    style: TextStyle(
                        fontSize: 24, fontFamily: MyFontFamily.mainFontFamily),
                    decoration: InputDecoration(
                        labelText: '알람 이름',
                        labelStyle: TextStyle(
                          fontFamily: MyFontFamily.mainFontFamily,
                        ),
                        suffixIcon: _.textEditingController.text.length > 0
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.black,
                                ),
                                onPressed: () => _.resetField(),
                              )
                            : null // Show the clear button if the text field has something
                        ),
                  ),
                ),
              ),

              _alarmDetailListTileFactory
                  .getDetailListTile(DetailTileName.ring),
              _alarmDetailListTileFactory
                  .getDetailListTile(DetailTileName.vibration),
              _alarmDetailListTileFactory
                  .getDetailListTile(DetailTileName.repeat),
            ],
          ),
        ),
      ),
    );
  }
}
