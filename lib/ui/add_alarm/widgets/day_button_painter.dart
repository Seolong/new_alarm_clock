import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

class DayButtonPainter extends CustomPainter {
  double textScaleFactor = 0.5;
  Color circleColor = ColorValue.addAlarmPageBackground;
  Color textColor = Colors.black;
  DayWeek name;
  DayOfWeekController controller;


  DayButtonPainter(this.name, this.controller);

  String? convertName(DayWeek dayName){
    switch(dayName){
      case DayWeek.Sun:
        return '일';
      case DayWeek.Mon:
        return '월';
      case DayWeek.Tue:
        return '화';
      case DayWeek.Wed:
        return '수';
      case DayWeek.Thu:
        return '목';
      case DayWeek.Fri:
        return '금';
      case DayWeek.Sat:
        return '토';
      default:
        assert(false, 'convertName Error in DayButtonPainter Class');
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    circleColor = controller.getButtonStateColor(controller.dayButtonStateMap[name]!);

    Paint paint = Paint() // 화면에 그릴 때 쓸 Paint를 정의합니다.
      ..color = circleColor
      ..strokeWidth = 3 // 선의 두께를 정합니다.
      ..style =
          PaintingStyle.stroke // 선의 스타일을 정합니다. stroke면 외곽선만 그리고, fill이면 다 채웁니다.
      ..strokeCap =
          StrokeCap.round; // stroke의 스타일을 정합니다. round를 고르면 stroke의 끝이 둥글게 됩니다.
    double radius = min(
        size.width / 2 - paint.strokeWidth / 2,
        size.height / 2 -
            paint.strokeWidth / 2); // 원의 반지름을 구함. 선의 굵기에 영향을 받지 않게 보정함.
    Offset center =
    Offset(size.width / 2, size.height / 2); // 원이 위젯의 가운데에 그려지게 좌표를 정함.
    canvas.drawCircle(center, radius, paint); // 원을 그림.
    drawText(canvas, size, convertName(name)!); // 텍스트를 화면에 표시함.
  }

  // 원의 중앙에 텍스트를 적음.
  void drawText(Canvas canvas, Size size, String text) {
    textColor = controller.getButtonTextColor(controller.dayButtonStateMap[name]!);
    double fontSize = getFontSize(size, text);
    TextSpan sp = TextSpan(
        style: TextStyle(
            fontSize: fontSize,
            color: textColor,
          fontFamily: MyFontFamily.mainFontFamily,),
        text: text); // TextSpan은 Text위젯과 거의 동일하다.
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);
    tp.layout(); // 필수! 텍스트 페인터에 그려질 텍스트의 크기와 방향를 정함.
    double dx = size.width / 2 - tp.width / 2;
    double dy = size.height / 2 - tp.height / 2;
    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
  }

  // 화면 크기에 비례하도록 텍스트 폰트 크기를 정함.
  double getFontSize(Size size, String text) {
    return size.width / text.length * textScaleFactor;
  }

  @override
  bool shouldRepaint(DayButtonPainter old) {
    return old.circleColor != circleColor;
  }
}
