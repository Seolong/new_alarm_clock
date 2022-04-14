import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/shared_preferences/id_shared_preferences.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/alarm_title_text_field_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/time_spinner_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/day_button.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_list_tile_factory.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/save_button.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/time_spinner.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/title_text_field.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/controller/repeat_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/controller/vibration_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/interval_text_field_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/month_repaet_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/going_back_dialog.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

final String toBeAddedIdName = 'toBeAddedId';

class AddAlarmPage extends StatelessWidget {
  String mode = '';
  int alarmId = -1;
  String currentFolderName = '';
  AlarmProvider _alarmProvider = AlarmProvider();
  final AlarmDetailListTileFactory _alarmDetailListTileFactory =
  AlarmDetailListTileFactory();
  final IdSharedPreferences idSharedPreferences = IdSharedPreferences();

  Future<void> initEditAlarm() async {
    AlarmData alarmData = await _alarmProvider.getAlarmById(alarmId);

    Get.find<RepeatModeController>().repeatMode = alarmData.alarmType;
    Get.find<VibrationRadioListController>().power = alarmData.vibrationBool;
    Get.find<VibrationRadioListController>().initSelectedVibrationInEdit(alarmData.vibrationName);
    Get.find<RingRadioListController>().power = alarmData.musicBool;
    Get.find<RingRadioListController>().volume = alarmData.musicVolume;
    Get.find<RingRadioListController>().initSelectedMusicPathInEdit(alarmData.musicPath);
    Get.find<RepeatRadioListController>().power = alarmData.repeatBool;
    //Get.find<RepeatRadioListController>().repeatInterval = alarmData.repeatInterval;
    Get.find<IntervalTextFieldController>().initTextFieldInEditRepeat(alarmData.alarmInterval);
    Get.find<MonthRepeatDayController>().initInEdit(alarmData.monthRepeatDay);
    Get.find<StartEndDayController>().setStart(alarmData.alarmDateTime);
  }

  Future<bool> _onTouchAppBarBackButton() async {
    return await Get.dialog(GoingBackDialog('AddAlarm', 'appBar'));
  }

  Future<bool> _onTouchSystemBackButton() async {
    return await Get.dialog(GoingBackDialog('AddAlarm', 'system'));
  }

  bool _isAbsorbPointerOfDayButton(RepeatModeController repeatModeController){
    if(repeatModeController.repeatMode == RepeatMode.off
        || repeatModeController.repeatMode == RepeatMode.week){
      return false;
    }
    else{
      return true;
    }
  }

  String convertAlarmDateTime() {
    if(Get.find<StartEndDayController>().start['dateTime'].year > DateTime.now().year){
      return '${Get.find<StartEndDayController>().start['year']} '
          '${Get.find<StartEndDayController>().start['monthDay']}';
    }
    else if(Get.find<StartEndDayController>().start['dateTime'].year == DateTime.now().year){
      return Get.find<StartEndDayController>().start['monthDay'];
    }
    else{
      return '';
    }
  }


  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> argFromPreviousPage = Get.arguments;
    mode = argFromPreviousPage[StringValue.mode]; //add or edit
    alarmId = argFromPreviousPage[StringValue.alarmId];
    currentFolderName = argFromPreviousPage[StringValue.folderName];

    final repeatModeController = Get.put(RepeatModeController());
    final dayOfWeekController = Get.put(DayOfWeekController());
    final alarmTitleTextFieldController =
    Get.put(AlarmTitleTextFieldController());
    final timeSpinnerController = Get.put(TimeSpinnerController());
    final startEndDayController = Get.put(StartEndDayController());
    Get.put(RingRadioListController());
    Get.put(VibrationRadioListController());
    Get.put(RepeatRadioListController());
    Get.put(IntervalTextFieldController());
    Get.put(MonthRepeatDayController());

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorValue.appbar));

    if (mode == StringValue.editMode) {
      initEditAlarm();
    }

    return WillPopScope(
      onWillPop: _onTouchSystemBackButton,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          backgroundColor: ColorValue.addAlarmPageBackground,
          appBar: AppBar(
            backgroundColor: ColorValue.appbar,
            foregroundColor: ColorValue.appbarText,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: _onTouchAppBarBackButton,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.5),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SaveButton(
                    alarmId,
                    mode,
                    currentFolderName,
                    repeatModeController: repeatModeController,
                    timeSpinnerController: timeSpinnerController,
                    startEndDayController: startEndDayController,
                    alarmTitleTextFieldController: alarmTitleTextFieldController,
                    dayOfWeekController: dayOfWeekController,
                  ),
                ),
              )
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                //height: Get.height - Get.statusBarHeight - 10,
                color: ColorValue.addAlarmPageBackground,
                padding: EdgeInsets.fromLTRB(25, 0, 25, 10),
                child: Column(
                  children: [
                    //spinner
                    Container(
                      height: 250,
                      child: TimeSpinner(
                          alarmId: alarmId, fontSize: 24, mode: mode),
                    ),

                    Divider(
                      thickness: 2,
                    ),

                    //DaysOfAlarm
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: GetBuilder<DayOfWeekController>(
                                //editMode에다가 WeekMode여야 한다
                                initState: (_) => mode == StringValue.editMode
                                    ? dayOfWeekController
                                    .initWhenEditMode(alarmId)
                                    : null,
                                builder: (_) => LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) =>
                                      GetBuilder<RepeatModeController>(
                                          builder: (repeatCont) {
                                            // off나 week이 아니면 터치 막아버림
                                            return AbsorbPointer(
                                              absorbing: _isAbsorbPointerOfDayButton(repeatCont),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: DayButton(
                                                          constraints, DayWeek.Sun, _)),
                                                  Expanded(
                                                      child: DayButton(
                                                          constraints, DayWeek.Mon, _)),
                                                  Expanded(
                                                      child: DayButton(
                                                          constraints, DayWeek.Tue, _)),
                                                  Expanded(
                                                      child: DayButton(
                                                          constraints, DayWeek.Wed, _)),
                                                  Expanded(
                                                      child: DayButton(
                                                          constraints, DayWeek.Thu, _)),
                                                  Expanded(
                                                      child: DayButton(
                                                          constraints, DayWeek.Fri, _)),
                                                  Expanded(
                                                      child: DayButton(
                                                          constraints, DayWeek.Sat, _)),
                                                ],
                                              ),
                                            );
                                          }
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
                                  repeatModeController.previousRepeatMode = repeatModeController.repeatMode;
                                  Get.toNamed(AppRoutes.choiceDayPage);
                                },
                              )),
                        ],
                      ),
                    ),

                    //NextYearMonthDayText
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: GetBuilder<StartEndDayController>(
                          builder: (_) {
                            return Container(
                              padding: EdgeInsets.only(top: 5),
                              height: 40,
                              child: AutoSizeText(
                                convertAlarmDateTime(),
                                bold: true,
                              ),
                            );
                          }
                      ),
                    ),

                    //IntervalInfoText
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: GetBuilder<IntervalTextFieldController>(
                          builder: (_){
                            return GetBuilder<RepeatModeController>(
                              builder: (repeatCont) {
                                return GetBuilder<MonthRepeatDayController>(
                                  builder: (monthCont) {
                                    return Container(
                                      padding: EdgeInsets.all(5),
                                      height: 35,
                                      child: AutoSizeText(
                                        '${_.textEditingController.text == '1'
                                            ? '매'
                                            : _.textEditingController.text}'
                                            '${repeatCont.getRepeatModeText(_.textEditingController.text,
                                            monthCont.monthRepeatDay)
                                        }',
                                        color: Colors.black54,
                                      ),
                                    );
                                  }
                                );
                              }
                            );
                          }
                      ),
                    ),

                    TitleTextField(mode, alarmId),

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
          ),
        ),
      ),
    );
  }
}
