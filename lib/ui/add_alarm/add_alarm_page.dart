import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/shared_preferences/id_shared_preferences.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/days_of_week_row.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_list_tile_factory.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/save_button.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/time_spinner.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/title_text_field.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/controller/repeat_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/controller/vibration_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/interval_text_field_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/month_repeat_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/year_repeat_day_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/going_back_dialog.dart';
import 'package:new_alarm_clock/ui/day_off/controller/day_off_list_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/required_parameter_to_add_alarm_page_controller.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';
import '../../utils/values/size_value.dart';
import '../global/color_controller.dart';

class AddAlarmPage extends StatelessWidget {
  String mode = '';
  int alarmId = -1;
  String currentFolderName = '';
  AlarmProvider _alarmProvider = AlarmProvider();
  late AlarmData alarmData;
  final AlarmDetailListTileFactory _alarmDetailListTileFactory =
      AlarmDetailListTileFactory();
  final IdSharedPreferences idSharedPreferences = IdSharedPreferences();

  Future<String> initEditAlarm() async {
    // 페이지가 빌드 될 때마다 처음 init 상태로 되돌아가는 것을 막기 위함
    if (Get.find<RequiredParameterToAddAlarmPageController>().isFirstInit ==
        true) {
      alarmData = await _alarmProvider.getAlarmById(alarmId);

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
    return StringValue.editMode;
  }

  String getIntervalInfoText(
      int interval, RepeatMode repeatMode, int? monthlyRepeatDay) {
    //off거나 single이면 비어있고
    //그 외에는 '2일마다 반복'
    if (repeatMode == RepeatMode.off || repeatMode == RepeatMode.single) {
      return '';
    } else {
      String alarmPoint;
      switch (repeatMode) {
        case RepeatMode.day:
          alarmPoint = LocaleKeys.repeatEveryDay.plural(interval);
          break;
        case RepeatMode.week:
          alarmPoint = LocaleKeys.repeatEveryWeek.plural(interval);
          break;
        case RepeatMode.month:
          alarmPoint = LocaleKeys.repeatEveryMonth.plural(interval);
          break;
        case RepeatMode.year:
          alarmPoint = LocaleKeys.repeatEveryYear.plural(interval);
          break;
        default:
          alarmPoint = '';
          assert(false, 'getIntervalInfoText error in AddAlarmPage');
      }
      return alarmPoint;
    }
  }

  Future<bool> _onTouchAppBarBackButton() async {
    return await Get.dialog(GoingBackDialog('appBar'));
  }

  Future<bool> _onTouchSystemBackButton() async {
    return await Get.dialog(GoingBackDialog('system'));
  }

  String convertAlarmDateTime() {
    if (Get.find<StartEndDayController>().start['dateTime'].year >
        DateTime.now().year) {
      return Jiffy(Get.find<StartEndDayController>().start['dateTime']).yMMMMd;
    } else if (Get.find<StartEndDayController>().start['dateTime'].year ==
        DateTime.now().year) {
      return Jiffy(Get.find<StartEndDayController>().start['dateTime']).MMMMd;
    } else {
      return '';
    }
  }

  //editMode일 때 initEditAlarm()를 쓰기 위함
  FutureBuilder getInitializedWidget(Widget widget){
    return FutureBuilder(
        future: mode == StringValue.editMode
            ? initEditAlarm()
            : Future<String>.value(StringValue.addMode),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if (snapshot.data == StringValue.editMode
                || snapshot.data == StringValue.addMode) {
              return widget;
            }
            else{
              return Text('Loading..');
            }
          }else{
            return Text('Loading..');
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    void closeKeyBoard() {
      FocusScopeNode currentFocus = FocusScope.of(context);
      //Checking hasPrimaryFocus is necessary to prevent Flutter from throwing an exception
      //when trying to unfocus the node at the top of the tree.
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }

    bool isRepeat() {
      return Get.find<RepeatModeController>().repeatMode != RepeatMode.off &&
          Get.find<RepeatModeController>().repeatMode != RepeatMode.single;
    }

    mode = Get.find<RequiredParameterToAddAlarmPageController>()
        .mode; //add or edit
    alarmId = Get.find<RequiredParameterToAddAlarmPageController>().alarmId;
    currentFolderName =
        Get.find<RequiredParameterToAddAlarmPageController>().folderName;

    final repeatModeController = Get.put(RepeatModeController());
    final startEndDayController = Get.put(StartEndDayController());
    Get.put(RingRadioListController());
    Get.put(VibrationRadioListController());
    Get.put(RepeatRadioListController());
    Get.put(IntervalTextFieldController());
    Get.put(MonthRepeatDayController());
    Get.put(YearRepeatDayController());
    Get.put(DayOffListController());

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Get.find<ColorController>().colorSet.mainColor));

    if (mode == StringValue.editMode) {
      initEditAlarm();
    }

    Get.find<DayOffListController>().id = alarmId;

    return WillPopScope(
      onWillPop: _onTouchSystemBackButton,
      child: GestureDetector(
        onTap: () {
          closeKeyBoard();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: SizeValue.appBarLeftPadding),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded),
                onPressed: _onTouchAppBarBackButton,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 12.5, 5),
                child: SaveButton(
                  alarmId,
                  mode,
                  currentFolderName,
                ),
              )
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                color: Get.find<ColorController>().colorSet.topBackgroundColor,
                child: Column(
                  children: [
                    //spinner
                    Container(
                      height: 250,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: TimeSpinner(
                          alarmId: alarmId, fontSize: 22, mode: mode),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17.5),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //ResetNextAlarmDayButton
                          GetBuilder<RepeatModeController>(builder: (_) {
                            return IconButton(
                              onPressed: () {
                                if (repeatModeController.repeatMode ==
                                    RepeatMode.month) {
                                  startEndDayController
                                      .resetDateWhenMonthRepeat(
                                      alarmData.alarmDateTime);
                                } else if (mode == StringValue.editMode &&
                                    isRepeat()) {
                                  startEndDayController
                                      .setStart(alarmData.alarmDateTime);
                                }
                              },
                              icon: Icon(Icons.refresh_rounded),
                              //tooltip: '초기화',
                              color:
                              (mode == StringValue.editMode && isRepeat())
                                  ? Get.find<ColorController>().colorSet.mainTextColor
                                  : Colors.transparent,
                            );
                          }),
                          //NextYearMonthDayText
                          GetBuilder<StartEndDayController>(builder: (_) {
                            return Text(
                              convertAlarmDateTime(),
                              style: TextStyle(
                                fontSize: 22,
                                //fontWeight: FontWeight.bold,
                                fontFamily: MyFontFamily.mainFontFamily
                              ),
                            );
                          }),
                          //SkipNextAlarmDayButton
                          GetBuilder<RepeatModeController>(builder: (_) {
                            return IconButton(
                              onPressed: () {
                                if (mode == StringValue.editMode &&
                                    isRepeat()) {
                                  startEndDayController
                                      .skipNextAlarmDate(alarmId);
                                }
                              },
                              icon: Icon(Icons.arrow_forward_ios_rounded),
                              //tooltip: '이번 알람 건너뛰기',
                              color:
                              (mode == StringValue.editMode && isRepeat())
                                  ? Get.find<ColorController>().colorSet.mainTextColor
                                  : Colors.transparent,
                            );
                          }),
                        ],
                      ),
                    ),

                    //IntervalInfoText
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: GetBuilder<IntervalTextFieldController>(builder: (_) {
                        return GetBuilder<RepeatModeController>(
                            builder: (repeatCont) {
                              return GetBuilder<MonthRepeatDayController>(
                                  builder: (monthCont) {
                                    return Text(
                                      getIntervalInfoText(
                                          _.getInterval(),
                                          repeatCont.repeatMode,
                                          monthCont.monthRepeatDay),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontFamily: MyFontFamily.mainFontFamily
                                      ),
                                    );
                                  });
                            });
                      }),
                    ),


                    Container(
                      decoration: BoxDecoration(
                        color: Get.find<ColorController>().colorSet.backgroundColor,
                        //border: Border.fromBorderSide(BorderSide(color: Color.fromARGB(255, 200, 200, 200))),
                        borderRadius: BorderRadius.only(
                      topRight: const Radius.circular(40.0),
                        topLeft: const Radius.circular(40.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                              //spreadRadius: 5,
                            color: Color.fromARGB(255, 200, 200, 200)
                          )
                        ]
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: DaysOfWeekRow(mode, alarmId),
                                  ),
                                ),

                                //ChoiceDayButton
                                FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: GestureDetector(
                                      child: Icon(
                                        Icons.today,
                                        color: Get.find<ColorController>().colorSet.accentColor,
                                        size: 1000,
                                      ),
                                      onTap: () {
                                        repeatModeController.previousRepeatMode =
                                            repeatModeController.repeatMode;
                                        Get.toNamed(AppRoutes.choiceDayPage);
                                      },
                                    )),
                              ],
                            ),
                          ),

                          TitleTextField(mode, alarmId),

                          getInitializedWidget(_alarmDetailListTileFactory
                              .getDetailListTile(DetailTileName.ring)),
                          getInitializedWidget(_alarmDetailListTileFactory
                              .getDetailListTile(DetailTileName.vibration)),
                          getInitializedWidget(_alarmDetailListTileFactory
                              .getDetailListTile(DetailTileName.repeat)),
                        ],
                      ),
                    ),
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
