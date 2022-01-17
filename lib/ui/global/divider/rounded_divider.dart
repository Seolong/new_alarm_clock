import 'package:flutter/material.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';

class RoundedDivider extends StatelessWidget {
  Color color;
  double height;

  RoundedDivider(this.color, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeValue.alarmItemDividerPadding),
        child: Container(
            height: this.height,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(
                    Radius.circular(15)
                )
            )
        ),
    );
  }
}
