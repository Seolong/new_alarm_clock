import 'package:flutter/material.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';

class AlarmItemText extends StatelessWidget {
  int flex;
  String itemText;

  AlarmItemText({required this.flex, required this.itemText});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: this.flex,
      child: Container(
        child: Align(
          alignment: Alignment(-0.875, 0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth:1,minHeight: 1),
              child: Text(
                itemText,
                style: TextStyle(
                    color: ColorValue.alarmText,
                    fontSize: SizeValue.alarmItemTextSize,
                  fontFamily: MyFontFamily.mainFontFamily
                ),),
            ),
          ),
        ),
      ),
    );
  }
}
