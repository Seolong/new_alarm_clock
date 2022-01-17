import 'package:flutter/material.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';

class MainDivider extends StatelessWidget {
  Color color;
  MainDivider(this.color);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: this.color,
      height: SizeValue.dividerHeight,
      thickness: SizeValue.dividerThickness,
      indent: SizeValue.dividerIndent,
      endIndent: SizeValue.dividerEndIndent,
    );
  }
}
