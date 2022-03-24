import 'package:flutter/material.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';

class AlarmItemText extends StatelessWidget {
  String itemText;
  Color? textColor;

  AlarmItemText({required this.itemText, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth:1,minHeight: 1),
            child: Text(
              itemText,
              style: TextStyle(
                  color: textColor == null ? ColorValue.alarmText: textColor,
                  fontSize: SizeValue.alarmItemTextSize,
                fontFamily: MyFontFamily.mainFontFamily
              ),),
          ),
        ),
      ),
    );
  }
}
