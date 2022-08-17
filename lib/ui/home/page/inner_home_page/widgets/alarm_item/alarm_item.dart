import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/global/custom_switch.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';
import '../../../../../global/color_controller.dart';
import '../../../../controller/required_parameter_to_add_alarm_page_controller.dart';
import 'controller/alarm_switch_controller.dart';
import 'controller/selected_alarm_controller.dart';

class AlarmItem extends StatelessWidget {
  Color _swapButtonColor;
  late int _id;
  int index;
  final AlarmProvider alarmProvider = AlarmProvider();

  AlarmItem({required int id, required Key key, required this.index})
      : _id = id,
        _swapButtonColor = Colors.grey,
        super(key: key);

  String convertAlarmDateTime(AlarmData alarmData) {
    if (alarmData.alarmDateTime.year > DateTime.now().year) {
      return Jiffy(alarmData.alarmDateTime).yMMMd;
    }
    return Jiffy(alarmData.alarmDateTime).MMMd;
  }

  String getTextOfAlarmPoint(AlarmData alarmData) {
    //off거나 single이면 비어있고
    //그 외에는 '2일마다 반복'
    if (alarmData.alarmType == RepeatMode.off ||
        alarmData.alarmType == RepeatMode.single) {
      return LocaleKeys.alarmOnce.tr();
    } else {
      String alarmPoint;
      int interval = alarmData.alarmInterval;
      switch (alarmData.alarmType) {
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
          assert(false, 'getTextOfAlarmPoint error in AlarmItem');
      }
      return alarmPoint;
    }
  }

  BoxDecoration? getLeftBorder(AlarmData alarmData) {
    if (alarmData.alarmType == RepeatMode.off ||
        alarmData.alarmType == RepeatMode.single) {
      return null;
    } else {
      return const BoxDecoration(
          border: Border(
        left: BorderSide(color: Colors.grey),
      ));
    }
  }

//color들 싹 조정하기
  @override
  Widget build(BuildContext context) {
    BorderRadius _alarmBorder = BorderRadius.all(Radius.circular(10));
    final switchCont = Get.put(AlarmSwitchController());
    Get.put(SelectedAlarmController());
    Get.put(AlarmListController());
    var requiredParameterToAddAlarmPageController = Get.put(RequiredParameterToAddAlarmPageController());

    //나중에 LongPress했을 때 회색도 추가
    Get.find<SelectedAlarmController>().colorMap[_id] = Get.find<ColorController>().colorSet.backgroundColor;

    return GetBuilder<SelectedAlarmController>(builder: (selectedCont) {
      return Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          AnimatedContainer(
            padding: const EdgeInsets.only(left: 3.5),
            duration: const Duration(milliseconds: 250),
            child: GestureDetector(
              onTap: () {
                Get.find<AlarmListController>().deleteAlarm(_id);
              },
              child: Icon(
                Icons.delete,
                size: ButtonSize.medium + 6,
                color: Colors.redAccent,
              ),
            ),
          ),
          AnimatedContainer(
            padding: const EdgeInsets.fromLTRB(0, 7.5, 0, 7.5),
            color: Get.find<ColorController>().colorSet.backgroundColor,
            duration: const Duration(milliseconds: 250),
            transform: Matrix4.translationValues(
                selectedCont.isSelectedMode ? 65 : 0, 0, 0),
            child: Container(
              height: SizeValue.alarmItemHeight,
              decoration: BoxDecoration(
                color: Get.find<ColorController>().colorSet.backgroundColor,
                borderRadius: _alarmBorder,
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 0.5,
                    blurRadius: 2.5,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              //안된다면 Material로 감싸봐
              child: Stack(children: [
                Material(
                  borderRadius: _alarmBorder,
                  child: Ink(
                      height: SizeValue.alarmItemHeight,
                      decoration: BoxDecoration(
                        borderRadius: _alarmBorder,
                        color:
                            Get.find<SelectedAlarmController>().colorMap[_id],
                      ),
                      child: InkWell(
                        borderRadius: _alarmBorder,
                        splashColor: Colors.grey,
                        onTap: () async {
                          requiredParameterToAddAlarmPageController.mode = StringValue.editMode;
                          requiredParameterToAddAlarmPageController.alarmId = _id;
                          requiredParameterToAddAlarmPageController.folderName = (await alarmProvider.getAlarmById(_id)).folderName;
                          Get.closeAllSnackbars();
                          Get.find<SelectedAlarmController>().isSelectedMode =
                              false;
                          Get.toNamed(AppRoutes.addAlarmPage);
                        },
                        onLongPress: () {
                          if (selectedCont.isSelectedMode == false) {
                            selectedCont.isSelectedMode =
                                !(selectedCont.isSelectedMode);
                            if (Get.isSnackbarOpen == false) {
                              Get.snackbar('', '',
                                  isDismissible: false,
                                  margin: EdgeInsets.zero,
                                  snackStyle: SnackStyle.GROUNDED,
                                  backgroundColor: Get.find<ColorController>().colorSet.mainColor,
                                  duration: const Duration(minutes: 15),
                                  animationDuration:
                                      const Duration(milliseconds: 250),
                                  mainButton: TextButton(
                                      onPressed: () {
                                        selectedCont.isSelectedMode = false;
                                        Get.back();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                          MaterialStateProperty.resolveWith<
                                                  Color>(
                                              (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return Colors.black26;
                                        }
                                        return Get.find<ColorController>().colorSet.deepMainColor;
                                      }),
                                        overlayColor: MaterialStateProperty.all(Colors.transparent),//splash 효과 없애는 코드
                                        minimumSize: MaterialStateProperty.all(const Size(40, 40)),
                                        maximumSize: MaterialStateProperty.all(const Size(200, 40))
                                      ),
                                      child: AutoSizeText(
                                        LocaleKeys.turnOffEraseMode.tr(),
                                        color: Get.find<ColorController>().colorSet.appBarContentColor,
                                      )));
                            }
                          }
                        },
                        child: FutureBuilder<AlarmData>(
                            future: alarmProvider.getAlarmById(_id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              3, 3, 0, 3),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //알람 제목 텍스트
                                              Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: Text(
                                                    (snapshot.data)!
                                                        .title!,
                                                  textScaleFactor: 1.0,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                    fontFamily: MyFontFamily.mainFontFamily
                                                  ),),
                                                ),
                                              const Divider(height: 6.0, thickness: 1.0,),

                                              //알람 시간 텍스트
                                              Padding(
                                                padding: const EdgeInsets.all(1.0),
                                                child: Text(DateFormat('hh:mm a', 'en')
                                                            .format((snapshot
                                                                    .data)!
                                                                .alarmDateTime)
                                                            .toLowerCase(),
                                                textScaleFactor: 1.0,
                                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                    fontFamily: MyFontFamily.mainFontFamily,
                                                  color: Get.find<ColorController>().colorSet.mainColor,
                                                  fontWeight: FontWeight.bold
                                                ),),
                                              ),
                                              const SizedBox(height: 5,),
                                              //alarmPoint 텍스트
                                              Padding(
                                                padding: const EdgeInsets.only(left: 1),
                                                child: Text(
                                                    convertAlarmDateTime(
                                                        (snapshot
                                                            .data)!),
                                                textScaleFactor: 1.0,
                                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                  fontFamily: MyFontFamily.mainFontFamily
                                                ),),
                                              ),
                                              const SizedBox(height: 2,),
                                              Text(getTextOfAlarmPoint(
                                                  (snapshot
                                                      .data)!),
                                                textScaleFactor: 1.0,
                                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                    fontFamily: MyFontFamily.mainFontFamily,
                                                    color: Colors.grey
                                                ),
                                              ),
                                              //Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      VerticalDivider(
                                        thickness: 1,
                                        color: ColorValue.alarmItemDivider,
                                      ),
                                      const SizedBox(
                                        width: 70,
                                      )
                                    ],
                                  ),
                                );
                              }
                              return const Center(
                                child: Text(
                                  'Loading..',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }),
                      )),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: _alarmBorder),
                    padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                    child: FutureBuilder<AlarmData>(
                        future: alarmProvider.getAlarmById(_id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switchCont.switchBoolMap[_id] =
                                snapshot.data!.alarmState;
                            return Column(
                              children: [
                                GetBuilder<AlarmSwitchController>(
                                    builder: (_) {
                                  return CustomSwitch(
                                    touchAreaHeight: 40,
                                      switchHeight: 22,
                                      value: _.switchBoolMap[_id]!,
                                      onChanged: (value) {
                                        _.setSwitchBool(_id);
                                      },
                                      activeColor: Get.find<ColorController>().colorSet.switchTrackColor,
                                      thumbColor: [
                                        Get.find<ColorController>().colorSet.lightMainColor,
                                        Get.find<ColorController>().colorSet.mainColor,
                                        Get.find<ColorController>().colorSet.deepMainColor,
                                      ]
                                  );
                                }),
                                const SizedBox(height: 12,),

                                //이 페이지 볼 때마다
                                //체크되어있나 아닌가 설정값 찾아서
                                //체크/미체크 표시하기기
                                ReorderableDragStartListener(
                                  index: index,
                                  child: Icon(
                                      Icons.swap_vert_rounded,
                                      size: 37.5,
                                      color: _swapButtonColor,
                                    ),

                                ),
                              ],
                            );
                          }
                          return const Center(
                            child: Text(
                              'Loading..',
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }),
                  ),
                )
              ]),
            ),
          ),
        ],
      );
    });
  }
}
