// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'dart:async';

var log = [];

enum ABC{ a }

void main() {
  test('DateTimeCalculator test', overridePrint((){

    String a = ABC.a.toString().split('.')[1];

    expect(a, 'a1');
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