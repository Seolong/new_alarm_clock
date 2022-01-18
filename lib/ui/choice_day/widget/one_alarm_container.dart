import 'package:flutter/material.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OneAlarmContainer extends StatefulWidget {
  const OneAlarmContainer({Key? key}) : super(key: key);

  @override
  _OneAlarmContainerState createState() => _OneAlarmContainerState();
}

class _OneAlarmContainerState extends State<OneAlarmContainer> {
  String start = '';
  String end = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //나중에 builder 이용해서 cell들 세부 조작
        Container(
          height: Get.height * 3 / 4,
          child: SfDateRangePicker(
            headerHeight: SizeValue.oneAlarmCalendarTitleHeight,
            minDate: DateTime(2000),
            maxDate: DateTime(2100),
            enablePastDates: false,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              setState(() {
                if (args.value is PickerDateRange) {
                  start = args.value.startDate.toString().substring(0, 10);

                  end = args.value.endDate != null
                      ? args.value.endDate.toString().substring(0, 10)
                      : start;
                } else if (args.value is DateTime) {
                  final DateTime selectedDate = args.value;
                  //start = selectedDate.day.toString();
                } else if (args.value is List<DateTime>) {
                  final List<DateTime> selectedDates = args.value;
                  List<String> displayedDates = [];
                  for (var date in selectedDates) {
                    displayedDates
                        .add(DateFormat('yyyy년 MM월 dd일').format(date));
                  }
                  start = displayedDates.toString(); //좀더 보기좋게 하자
                }
              });
            },
            selectionMode: DateRangePickerSelectionMode.multiple,
            monthCellStyle: DateRangePickerMonthCellStyle(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: MyFontFamily.mainFontFamily,
                  fontSize: SizeValue.oneAlarmCalendarCellTextSize,
                  //fontWeight: FontWeight.bold
              ),
              todayTextStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: MyFontFamily.mainFontFamily,
                  fontSize: SizeValue.oneAlarmCalendarCellTextSize,
                  //fontWeight: FontWeight.bold
              ),
            ),
            startRangeSelectionColor: Colors.white,
            endRangeSelectionColor: Colors.white,
            rangeSelectionColor: Colors.white,
            selectionTextStyle: TextStyle(
                color: Colors.white,
                fontFamily: MyFontFamily.mainFontFamily,
                fontSize: SizeValue.oneAlarmCalendarCellTextSize,
                fontWeight: FontWeight.bold),
            todayHighlightColor: ColorValue.todayColor,
            selectionColor: ColorValue.calendarSelection,
            // backgroundColor: Colors.deepPurple,
            //allowViewNavigation: false,
            // view:  DateRangePickerView.month,
            //11월 2021  이 부분
            headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: ColorValue.calendarTitleBar,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: SizeValue.oneAlarmCalendarTitleTextSize,
                  letterSpacing: 2,
                  fontFamily: MyFontFamily.mainFontFamily,
                  fontWeight: FontWeight.bold
                )),
            monthViewSettings: DateRangePickerMonthViewSettings(
                enableSwipeSelection: false,
                //일 월 화 수 목 금 토  이 부분
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: TextStyle(
                        fontFamily: MyFontFamily.mainFontFamily,
                        color: Colors.black,
                        fontSize: SizeValue.oneAlarmCalendarCellTextSize - 4))),
          ),
        ),
        Divider(
          color: Colors.grey,
          thickness: 5,
        ),
        Text('$start ~ $end'),
      ],
    );
  }
}
