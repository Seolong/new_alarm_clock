import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class OneAlarmContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var startEndDayController = Get.put(StartEndDayController());
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            height: 500,
            width: 400,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
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
            child: GetBuilder<StartEndDayController>(builder: (context) {
              return TableCalendar(
                focusedDay: DateTime.now()
                        .isAfter(startEndDayController.start['dateTime'])
                    ? DateTime.now()
                    : startEndDayController.start['dateTime'],
                currentDay: DateTime.now()
                        .isAfter(startEndDayController.start['dateTime'])
                    ? DateTime.now()
                    : startEndDayController.start['dateTime'],
                firstDay: DateTime.now(),
                lastDay: DateTime(2050, 12, 31),
                //onHeaderTapped: _onHeaderTapped,
                headerStyle: HeaderStyle(
                  headerMargin:
                      EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                  titleCentered: true,
                  formatButtonVisible: false,
                  leftChevronIcon: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle),
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
                        color: Colors.green,
                        shape: BoxShape.circle),
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
                onHeaderTapped: (DateTime focusedDay) {},
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold
                  ),
                  weekendStyle: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold
                  )
                ),
                daysOfWeekHeight: 52,
                calendarStyle: CalendarStyle(
                    //selectedDecoration:
                  todayDecoration: BoxDecoration(
                    color: Color.fromRGBO(62, 196, 143, 100),
                    shape: BoxShape.circle,
                    //borderRadius: BorderRadius.circular(100)
                  )
                    ),
                locale: 'ko-KR',
                //events: _events,
                //holidays: _holidays,
                //availableCalendarFormats: _availableCalendarFormats,
                //calendarController: _calendarController,
                //builders: calendarBuilder(),
                onDaySelected: (selectedDay, focusedDay) {
                  startEndDayController.setStart(selectedDay);
                },
                //pageJumpingEnabled: true,
                // onVisibleDaysChanged: _onVisibleDaysChanged,
                // onCalendarCreated: _onCalendarCreated,
              );
            }),
          ),
        ),
      ],
    );
  }
}
