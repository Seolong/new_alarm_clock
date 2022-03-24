import 'package:flutter/material.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

class AutoSizeText extends StatelessWidget {
  String text;
  bool bold;
  String? fontFamily;

  AutoSizeText(this.text, {this.bold = false, this.fontFamily});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 1, minHeight: 1),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 1000,
            fontWeight: bold ? FontWeight.bold: FontWeight.normal,
            fontFamily: fontFamily == null ? MyFontFamily.mainFontFamily : fontFamily,
          ),
        ),
      ),
    );
  }
}
