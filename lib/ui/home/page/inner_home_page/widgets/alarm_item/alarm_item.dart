import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/global/convenience_method.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';
import '../../../../controller/required_parameter_to_add_alarm_page_controller.dart';
import 'controller/alarm_switch_controller.dart';
import 'controller/selected_alarm_controller.dart';
import 'widgets/alarm_item_text.dart';
import 'package:intl/intl.dart';

class AlarmItem extends StatelessWidget {
  Color _swapButtonColor;
  late int _id;
  int index;
  AlarmProvider alarmProvider = AlarmProvider();

  AlarmItem({required int id, required Key key, required this.index})
      : _id = id,
        _swapButtonColor = Colors.grey,
        super(key: key);

  String convertAlarmDateTime(AlarmData alarmData) {
    if (alarmData.alarmDateTime.year > DateTime.now().year) {
      return DateFormat('yyyy년 M월 d일').format(alarmData.alarmDateTime);
    }
    return DateFormat('M월 d일').format(alarmData.alarmDateTime);
  }

  String getTextOfAlarmPoint(AlarmData alarmData) {
    //off거나 single이면 비어있고
    //그 외에는 '2일마다 반복'
    if (alarmData.alarmType == RepeatMode.off ||
        alarmData.alarmType == RepeatMode.single) {
      return '';
    } else {
      String alarmPoint;
      int interval = alarmData.alarmInterval;
      switch (alarmData.alarmType) {
        case RepeatMode.day:
          alarmPoint = interval == 1 ? '매일 반복' : '${interval}일마다 반복';
          break;
        case RepeatMode.week:
          alarmPoint = interval == 1 ? '매주 반복' : '${interval}주마다 반복';
          break;
        case RepeatMode.month:
          alarmPoint = interval == 1 ? '매달 반복' : '${interval}달마다 반복';
          break;
        case RepeatMode.year:
          alarmPoint = interval == 1 ? '매년 반복' : '${interval}년마다 반복';
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
      return BoxDecoration(
          border: Border(
        left: BorderSide(color: ColorValue.alarmItemDivider),
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
    Get.find<SelectedAlarmController>().colorMap[_id] = ColorValue.alarm;

    return GetBuilder<SelectedAlarmController>(builder: (selectedCont) {
      return Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          AnimatedContainer(
            padding: EdgeInsets.only(left: 3.5),
            duration: Duration(milliseconds: 250),
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
            padding: EdgeInsets.fromLTRB(0, 7.5, 0, 7.5),
            color: ColorValue.mainBackground,
            duration: Duration(milliseconds: 250),
            transform: Matrix4.translationValues(
                selectedCont.isSelectedMode ? 65 : 0, 0, 0),
            child: Container(
              height: SizeValue.alarmItemHeight,
              decoration: BoxDecoration(
                color: ColorValue.mainBackground,
                borderRadius: _alarmBorder,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 0.5,
                    blurRadius: 0.5,
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
                                  backgroundColor: ColorValue.mainBackground,
                                  duration: Duration(minutes: 15),
                                  animationDuration:
                                      Duration(milliseconds: 250),
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
                                        return ColorValue.activeSwitch;
                                      }),
                                        overlayColor: MaterialStateProperty.all(Colors.transparent),//splash 효과 없애는 코드
                                        minimumSize: MaterialStateProperty.all(Size(40, 40)),
                                        maximumSize: MaterialStateProperty.all(Size(150, 40))
                                      ),
                                      child: AutoSizeText(
                                        '삭제 모드 해제',
                                        color: Colors.white,
                                      )));
                            }
                          }
                        },
                        child: FutureBuilder<AlarmData>(
                            future: alarmProvider.getAlarmById(_id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              3, 3, 0, 3),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //알람 제목 텍스트
                                              Flexible(
                                                flex: 4,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: AlarmItemText(
                                                      itemText: (snapshot.data)!
                                                          .title!),
                                                ),
                                              ),
                                              Divider(
                                                thickness: 1,
                                                color:
                                                    ColorValue.alarmItemDivider,
                                              ),

                                              //알람 시간 텍스트
                                              Flexible(
                                                flex: 6,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: AlarmItemText(
                                                      itemText:
                                                          DateFormat('hh:mm a')
                                                              .format((snapshot
                                                                      .data)!
                                                                  .alarmDateTime)
                                                              .toLowerCase()),
                                                ),
                                              ),
                                              //alarmPoint 텍스트
                                              Flexible(
                                                flex: 3,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 1),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AlarmItemText(
                                                          itemText:
                                                              convertAlarmDateTime(
                                                                  (snapshot
                                                                      .data)!)),
                                                      Container(
                                                        decoration: getLeftBorder(
                                                            (snapshot.data)!),
                                                        child: AlarmItemText(
                                                          itemText:
                                                              getTextOfAlarmPoint(
                                                                  (snapshot
                                                                      .data)!),
                                                          textColor:
                                                              Colors.black45,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
                                      Container(
                                        width: 70,
                                      )
                                    ],
                                  ),
                                );
                              }
                              return Center(
                                child: Text(
                                  'Loading..',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }),
                      )),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 70,
                    //alignment: Alignment.center,
                    decoration: BoxDecoration(
                        //color: Color.fromARGB(255, 250, 250, 250),
                        borderRadius: _alarmBorder),
                    padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                    child: FutureBuilder<AlarmData>(
                        future: alarmProvider.getAlarmById(_id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switchCont.switchBoolMap[_id] =
                                snapshot.data!.alarmState;
                            return Column(
                              children: [
                                Transform.scale(
                                    scale: 0.8,
                                    child: GetBuilder<AlarmSwitchController>(
                                        builder: (_) {
                                      return CupertinoSwitch(
                                        value: _.switchBoolMap[_id]!,
                                        onChanged: (value) {
                                          _.setSwitchBool(_id);
                                        },
                                        activeColor: ColorValue.activeSwitch,
                                        trackColor: Color(0xffC8C2BC),
                                      );
                                    })),

                                Spacer(),

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
                          return Center(
                            child: Text(
                              'Loading..',
                              style: TextStyle(color: Colors.white),
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
