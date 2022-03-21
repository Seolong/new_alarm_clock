import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/year_repeat_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/widget_all/calendar_dialog.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart';

class YearRepeatContainer extends RepeatContainer {
  late IconButton startDayButton;
  late Text startDayText;
  late Text intervalType;

  YearRepeatContainer(){
    final yearRepeatDayController = Get.put(YearRepeatDayController());
    intervalType = Text(
      '년마다',
      style: TextStyle(
          fontSize: SizeValue.intervalTypeTextSize
      ),
    );
    bottomColumn = Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: GetBuilder<YearRepeatDayController>(
              builder: (_) {
                return Text('${_.getYearRepeatDay_monthDay()}',
                  style: TextStyle(fontSize: SizeValue.yearRepeatDayText),);
              }
          ),
        ),
        Container(height: 75,),
        GetBuilder<YearRepeatDayController>(
          builder: (_) {
            return InkWell(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                onTap: () async {
                  var dateTime = await Get.dialog(AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      content: CalendarDialog()));
                  _.yearRepeatDay = dateTime;
                },
                child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.today,
                      size: ButtonSize.large,
                      color: ColorValue.tabBarIndicator,
                    )));
          }
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 7.5, 0, 7.5),
          height: ButtonSize.medium + 4,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: ConstrainedBox(
              constraints:
              BoxConstraints(minWidth: 1, minHeight: 1),
              child: Text(
                '반복 날짜(월, 일) 선택',
                style: TextStyle(
                    color: Colors.black87, fontSize: 1000),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
