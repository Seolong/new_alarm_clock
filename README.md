# new_alarm_clock

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Run below code before localization
flutter pub run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart

If you use GetX and Easy_localization, you must import like below.
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

기본음이랑 기본진동은 DB에 넣어지는 놈들이라 국제화 안 했음