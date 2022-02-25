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
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/going_back_dialog.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

final String toBeAddedIdName = 'toBeAddedId';

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
  }

  Future<bool> _onTouchAppBarBackButton() async {
    return await Get.dialog(GoingBackDialog('AddAlarm', 'appBar'));
  }

  Future<bool> _onTouchSystemBackButton() async {
    return await Get.dialog(GoingBackDialog('AddAlarm', 'system'));
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> argFromPreviousPage = Get.arguments;
    mode = argFromPreviousPage[StringValue.mode]; //add or edit
    alarmId = argFromPreviousPage[StringValue.alarmId];

    final repeatModeController = Get.put(RepeatModeController());
    final dayOfWeekController = Get.put(DayOfWeekController());
    final alarmTitleTextFieldController =
        Get.put(AlarmTitleTextFieldController());
    final timeSpinnerController = Get.put(TimeSpinnerController());
    final startEndDayController = Get.put(StartEndDayController());

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
                padding: const EdgeInsets.all(10.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SaveButton(
                    alarmId,
                    mode,
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
                          alarmId: alarmId, fontSize: 27, mode: mode),
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
                                      Row(
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

                    Container(
                      height: 25,
                      child: Text(
                        //임시
                        Get.find<TimeSpinnerController>()
                            .alarmDateTime
                            .toString(),
                      ),
                    ),

                    //TitleTextField
                    Container(
                      height: 85,
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: GetBuilder<AlarmTitleTextFieldController>(
                        initState: (_) => mode == StringValue.editMode
                            ? alarmTitleTextFieldController
                                .initTitleTextField(alarmId)
                            : null,
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
                              fontSize: 24,
                              fontFamily: MyFontFamily.mainFontFamily),
                          decoration: InputDecoration(
                              labelText: '알람 이름',
                              labelStyle: TextStyle(
                                fontSize: 20,
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
          ),
        ),
      ),
    );
  }
}
