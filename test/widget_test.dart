// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:async';

var log = [];

void main() {
  test('DateTimeCalculator test', overridePrint((){

    DateTime dateTime = DateTime.now().add(Duration(days: 5));
    DateTime dateTime2 = DateTime.now().add(Duration(days: 5));
    dateTime = Jiffy(dateTime).subtract(months: 1).dateTime;
    dateTime = Jiffy(dateTime).subtract(months: 1).dateTime;
    dateTime = Jiffy(dateTime).subtract(months: 1).dateTime;
    dateTime2 = Jiffy(dateTime2).subtract(months: 3).dateTime;

    expect(dateTime.day, dateTime2.day);
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