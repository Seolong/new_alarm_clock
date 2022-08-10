import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart' hide Trans;
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:table_calendar/table_calendar.dart';

class OneAlarmContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(StartEndDayController());
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            height: 500,
            width: 400,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Get.find<ColorController>().colorSet.backgroundColor,
              borderRadius: BorderRadius.circular(7.5),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(175, 175, 175, 100),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: Offset(0, 5), // changes position of shadow
                )
              ],
            ),
            child: GetBuilder<StartEndDayController>(builder: (_) {
              int lastYear = 2045;
              void showDatePicker(context) {
                DateTime result =
                    _.start[_.dateTime];
                showCupertinoModalPopup(
                    context: context,
                    builder: (__) => Container(
                          height: 250,
                          color: Get.find<ColorController>().colorSet.backgroundColor,
                          child: Column(
                            children: [
                              // 확인 취소 만들기
                              Container(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // 확인 취소 만들기
                                    CupertinoButton(
                                      child: Text(
                                        LocaleKeys.cancel.tr(),
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                    CupertinoButton(
                                      child: Text(LocaleKeys.move.tr()),
                                      onPressed: () {
                                        _.setStart(result);
                                        Get.back();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 200,
                                child: CupertinoDatePicker(
                                    initialDateTime: result,
                                    minimumYear: DateTime.now().year,
                                    maximumYear: lastYear,
                                    mode: CupertinoDatePickerMode.date,
                                    onDateTimeChanged: (val) {
                                      result = val;
                                    }),
                              ),
                            ],
                          ),
                        ));
              }

              return TableCalendar(
                focusedDay: DateTime.now()
                        .isAfter(_.start['dateTime'])
                    ? DateTime.now()
                    : _.start['dateTime'],
                currentDay: DateTime.now()
                        .isAfter(_.start['dateTime'])
                    ? DateTime.now()
                    : _.start['dateTime'],
                firstDay: DateTime.now(),
                lastDay: DateTime(lastYear, 12, 31),
                //onHeaderTapped: _onHeaderTapped,
                headerStyle: HeaderStyle(
                  headerMargin:
                      EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                  titleCentered: true,
                  formatButtonVisible: false,
                  leftChevronIcon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          //stops: [0.1, 0.4, 1.0],
                          colors: [
                            Get.find<ColorController>().colorSet.deepMainColor,
                            Get.find<ColorController>().colorSet.mainColor,
                            Get.find<ColorController>().colorSet.lightMainColor
                          ]),
                    ),
                    height: 30,
                    width: 30,
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: ButtonSize.small,
                    ),
                  ),
                  rightChevronIcon: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            //stops: [0.1, 0.4, 1.0],
                            colors: [
                              Get.find<ColorController>()
                                  .colorSet
                                  .lightMainColor,
                              Get.find<ColorController>().colorSet.mainColor,
                              Get.find<ColorController>()
                                  .colorSet
                                  .deepMainColor,
                            ])),
                    height: 30,
                    width: 30,
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                      size: ButtonSize.small,
                    ),
                  ),
                  titleTextStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Get.find<ColorController>().colorSet.calendarTitleColor),
                ),
                onHeaderTapped: (DateTime focusedDay) {
                  showDatePicker(context);
                },
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                        color: Get.find<ColorController>().colorSet.mainColor,
                        fontWeight: FontWeight.bold),
                    weekendStyle: TextStyle(
                        color: Get.find<ColorController>().colorSet.mainColor,
                        fontWeight: FontWeight.bold)),
                daysOfWeekHeight: 52,
                calendarStyle: CalendarStyle(
                    //selectedDecoration:
                    todayDecoration: BoxDecoration(
                  color: Get.find<ColorController>().colorSet.mainColor,
                  shape: BoxShape.circle,
                  //borderRadius: BorderRadius.circular(100)
                )),
                locale: context.locale.toString(),
                onDaySelected: (selectedDay, focusedDay) {
                  _.setStart(selectedDay);
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
