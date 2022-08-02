import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../utils/values/size_value.dart';
import '../../../../global/color_controller.dart';

class SelectedDayController extends GetxController{
  DateTime _selectedDay = DateTime.now();

  set selectedDay(DateTime date) {
    _selectedDay = date;
    update();
  }
  DateTime get selectedDay => _selectedDay;
}

class CalendarContainer extends StatelessWidget {
  DateTime initialDate;

  CalendarContainer(this.initialDate){
    Get.put(SelectedDayController());
    Get.find<SelectedDayController>().selectedDay = initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 485,
      child: GetBuilder<SelectedDayController>(builder: (_) {
        int lastYear = 2045;
        //_.selectedDay = initialDate;
        void showDatePicker(context) {
          showCupertinoModalPopup(
              context: context,
              builder: (__) => Container(
                height: 250,
                color: const Color.fromARGB(255, 255, 255, 255),
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
                              _.selectedDay = initialDate;
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: CupertinoDatePicker(
                          initialDateTime: _.selectedDay,
                          minimumYear: DateTime.now().year,
                          maximumYear: lastYear,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (val) {
                            initialDate = val;
                          }),
                    ),
                  ],
                ),
              ));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TableCalendar(
                focusedDay: _.selectedDay.isAfter(DateTime.now())
                    ? _.selectedDay
                    : DateTime.now().add(Duration(minutes: 15)),
                currentDay: _.selectedDay.isAfter(DateTime.now())
                    ? _.selectedDay
                    : DateTime.now().add(Duration(minutes: 15)),
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
                  titleTextStyle: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent),
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
                daysOfWeekHeight: 40,
                calendarStyle: CalendarStyle(
                  //selectedDecoration:
                    todayDecoration: BoxDecoration(
                      color: Get.find<ColorController>().colorSet.mainColor,
                      shape: BoxShape.circle,
                      //borderRadius: BorderRadius.circular(100)
                    )),
                locale: context.locale.toString(),
                onDaySelected: (selectedDay, focusedDay) {
                  _.selectedDay = selectedDay;
                  print(selectedDay);
                  print(focusedDay);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: (){
                      Get.back();
                    },
                    child: Text(LocaleKeys.cancel.tr(),
                    style: TextStyle(color: Colors.grey),)),
                TextButton(
                    onPressed: (){
                      print(_.selectedDay);
                      Get.back(result: _.selectedDay);
                    },
                    child: Text(LocaleKeys.done.tr())),
              ],
            )
          ],
        );
      }),
    );
  }
}
