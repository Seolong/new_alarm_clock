// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'package:new_alarm_clock/service/date_time_calculator.dart';
import 'package:new_alarm_clock/utils/enum.dart';

var log = [];

void main() {
  test('DateTimeCalculator test', overridePrint((){
    DateTimeCalculator _dateTimeCalculator = DateTimeCalculator();

    DateTime dateTime = DateTime(2022, 3, 19);

    var result = _dateTimeCalculator.addDateTime(
        RepeatMode.week,
        dateTime,
        2,
      weekBool: [false, true, false, true, false, false, true]
    );

    expect(result.day, 28);
  }));


}
void Function() overridePrint(void testFn()) => () {
  var spec = new ZoneSpecification(
      print: (_, __, ___, String msg) {
        // Add to log instead of printing to stdout
        log.add(msg);
      }
  );
  return Zone.current.fork(specification: spec).run<void>(testFn);
};