import 'package:flutter/material.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';

class RoundedVerticalDivider extends StatelessWidget {
  Color color;
  double width;

  RoundedVerticalDivider(this.color, this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          SizeValue.alarmItemVerticalDividerPadding,
          SizeValue.alarmItemVerticalDividerPadding,
          SizeValue.alarmItemVerticalDividerPadding,
          SizeValue.alarmItemVerticalDividerPadding),
      child: Container(
          width: this.width,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(
                  Radius.circular(5)
              )
          )
      ),
    );
  }
}
