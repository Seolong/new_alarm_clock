import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container/widget_all/calendar_dialog.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RepeatContainer extends StatelessWidget {
  late IconButton startDayButton;
  late Text startDayText;
  late Text intervalType;
  late Column bottomColumn;

  RepeatContainer() {
    startDayButton = IconButton(onPressed: () {}, icon: Icon(Icons.today));
    startDayText = Text('시작일');
  }

  @override
  Widget build(BuildContext context) {
    Get.put(StartEndDayController());
    return Container(
        child: Column(
      children: [
        Divider(
          height: 0.5,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: GetBuilder<StartEndDayController>(
                    builder: (_) => Column(
                      children: [
                        InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            onTap: () async {
                              var dateTime = await Get.dialog(AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: CalendarDialog()));
                              _.setStart(dateTime!);
                            },
                            child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.today,
                                  size: ButtonSize.large,
                                  color: ColorValue.calendarIcon,
                                ))),
                        Container(
                          height: ButtonSize.small,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: ConstrainedBox(
                                constraints:
                                    BoxConstraints(minHeight: 1, minWidth: 1),
                                child: Text(
                                  _.start['monthDay'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 1000,),
                                )),
                          ),
                        ),
                        Container(
                          height: ButtonSize.small - 4,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: ConstrainedBox(
                                constraints:
                                    BoxConstraints(minHeight: 1, minWidth: 1),
                                child: Text(
                                  _.start['year'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 1000),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  width: 3,
                  thickness: 1,
                ),
                Expanded(
                  child: GetBuilder<StartEndDayController>(
                    builder: (_) => Column(
                      children: [
                        InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            onTap: () async {
                              var dateTime = await Get.dialog(AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: CalendarDialog()));
                              _.setEnd(dateTime!);
                            },
                            child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.event,
                                  size: ButtonSize.large,
                                  color: ColorValue.calendarIcon,
                                ))),
                        Container(
                          height: ButtonSize.small,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: ConstrainedBox(
                                constraints:
                                    BoxConstraints(minHeight: 1, minWidth: 1),
                                child: Text(
                                  _.end['year'] == ''
                                      ? '종료일'
                                      : _.end['monthDay'],
                                  style: TextStyle(fontSize: 1000),
                                )),
                          ),
                        ),
                        Container(
                          height: ButtonSize.small - 4,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: ConstrainedBox(
                                constraints:
                                    BoxConstraints(minHeight: 1, minWidth: 1),
                                child: Text(
                                  _.end['year'] == '' ? '설정 안함' : _.end['year'],
                                  style: TextStyle(fontSize: 1000),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 1,
        ),
        Padding(
          //더 깔쌈한 배치로
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: SizeValue.repeatTextFieldSize,
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    //아래에 글자 수 제한도 안보이고 공간도 차지 안하게
                    LengthLimitingTextInputFormatter(5),
                    FilteringTextInputFormatter.digitsOnly //숫자만 입력
                  ],
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: SizeValue.repeatTextFieldTextSize),
                ),
              ),
              intervalType,
            ],
          ),
        ),
        bottomColumn
      ],
    ));
  }
}
