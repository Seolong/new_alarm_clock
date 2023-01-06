import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../global/color_controller.dart';

class SelectedDayController extends GetxController {
  DateTime _selectedDay = DateTime.now();

  set selectedDay(DateTime date) {
    _selectedDay = date;
    update();
  }

  DateTime get selectedDay => _selectedDay;
}

class CalendarContainer extends StatelessWidget {
  DateTime initialDate;
  static const double arrowIconSize = 25;
  double? cellFontSize;

  CalendarContainer(this.initialDate, {Key? key}) : super(key: key) {
    Get.put(SelectedDayController());
    Get.find<SelectedDayController>().selectedDay = initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520,
      child: GetBuilder<SelectedDayController>(builder: (_) {
        int lastYear = 2045;
        //_.selectedDay = initialDate;
        void showDatePicker(context) {
          showCupertinoModalPopup(
              context: context,
              builder: (__) => Container(
                    height: 300,
                    color: Get.find<ColorController>().colorSet.backgroundColor,
                    child: Column(
                      children: [
                        // 확인 취소 만들기
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 확인 취소 만들기
                            CupertinoButton(
                              child: Text(
                                LocaleKeys.cancel.tr(),
                                style: const TextStyle(color: Colors.grey),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                    child: TableCalendar(
                      focusedDay: _.selectedDay.isAfter(DateTime.now())
                          ? _.selectedDay
                          : DateTime.now().add(const Duration(minutes: 15)),
                      currentDay: _.selectedDay.isAfter(DateTime.now())
                          ? _.selectedDay
                          : DateTime.now().add(const Duration(minutes: 15)),
                      firstDay: DateTime.now(),
                      lastDay: DateTime(lastYear, 12, 31),
                      //onHeaderTapped: _onHeaderTapped,
                      headerStyle: HeaderStyle(
                        headerMargin: const EdgeInsets.only(top: 5, bottom: 5),
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
                          height: arrowIconSize,
                          width: arrowIconSize,
                          child: const Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                            size: arrowIconSize,
                          ),
                        ),
                        rightChevronIcon: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Get.find<ColorController>()
                                        .colorSet
                                        .lightMainColor,
                                    Get.find<ColorController>().colorSet.mainColor,
                                    Get.find<ColorController>()
                                        .colorSet
                                        .deepMainColor,
                                  ])),
                          height: arrowIconSize,
                          width: arrowIconSize,
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                            size: arrowIconSize,
                          ),
                        ),
                        titleTextStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Get.find<ColorController>()
                                .colorSet
                                .calendarTitleColor),
                      ),
                      onHeaderTapped: (DateTime focusedDay) {
                        showDatePicker(context);
                      },
                      daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                              color: Get.find<ColorController>().colorSet.mainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: cellFontSize),
                          weekendStyle: TextStyle(
                              color: Get.find<ColorController>().colorSet.mainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: cellFontSize)),
                      daysOfWeekHeight: 40,
                      calendarStyle: CalendarStyle(
                          disabledTextStyle:
                              TextStyle(fontSize: cellFontSize, color: Colors.grey),
                          outsideTextStyle:
                              TextStyle(fontSize: cellFontSize, color: Colors.grey),
                          todayTextStyle: TextStyle(
                              fontSize: cellFontSize,
                              color: Get.find<ColorController>()
                                  .colorSet
                                  .appBarContentColor),
                          weekendTextStyle: TextStyle(
                              fontSize: cellFontSize,
                              color:
                                  Get.find<ColorController>().colorSet.mainTextColor),
                          defaultTextStyle: TextStyle(
                              fontSize: cellFontSize,
                              color:
                                  Get.find<ColorController>().colorSet.mainTextColor),
                          todayDecoration: BoxDecoration(
                            color: Get.find<ColorController>().colorSet.mainColor,
                            shape: BoxShape.circle,
                          )),
                      locale: context.locale.toString(),
                      onDaySelected: (selectedDay, focusedDay) {
                        _.selectedDay = selectedDay;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox.shrink(),
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          LocaleKeys.cancel.tr(),
                          textScaleFactor: 1,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              //fontWeight: FontWeight.bold,
                              fontFamily: MyFontFamily.mainFontFamily),
                        )),
                    const VerticalDivider(
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    TextButton(
                        onPressed: () {
                          Get.back(result: _.selectedDay);
                        },
                        child: Text(
                          LocaleKeys.done.tr(),
                          textScaleFactor: 1,
                          style: const TextStyle(
                            fontSize: 16,
                            //fontWeight: FontWeight.bold,
                            fontFamily: MyFontFamily.mainFontFamily,
                          ),
                        )),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
