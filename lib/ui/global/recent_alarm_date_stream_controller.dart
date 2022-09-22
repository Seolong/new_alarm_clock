import 'dart:async';
import 'package:get/get.dart' hide Trans;
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import '../../data/model/alarm_data.dart';
import '../../generated/locale_keys.g.dart';

class RecentAlarmDateStreamController extends GetxController {
  final AlarmProvider _alarmProvider = AlarmProvider();
  String nextAlarmTimeText = '';
  String? nextAlarmTitle;
  String nextAlarmTimeDifferenceText = LocaleKeys.allAlarmsAreOff.tr();
  AlarmData alarm = AlarmData(
      id: -1,
      alarmType: RepeatMode.day,
      alarmDateTime: DateTime(1),
      endDay: null,
      alarmState: false,
      alarmOrder: -1,
      folderId: 0,
      alarmInterval: 1,
      monthRepeatDay: 0,
      musicBool: false,
      musicPath: '',
      musicVolume: 1,
      vibrationBool: true,
      vibrationName: VibrationName.heartBeat,
      repeatBool: false,
      repeatInterval: 1,
      repeatNum: 1);
  late Stream<AlarmData> dateStream;
  late StreamController<AlarmData> dateStreamController;
  late StreamSubscription<AlarmData> dateStreamSubscription;

  @override
  void onInit() {
    super.onInit();

    dateStream =
        Stream<AlarmData>.periodic(const Duration(seconds: 1), (_) => (alarm));
    dateStreamController = StreamController<AlarmData>(
      onCancel: () {},
      onPause: () {},
      onResume: () {},
    );
    dateStreamController.addStream(dateStream);
    dateStreamSubscription = dateStreamController.stream.listen((event) {
      differenceTimeNowAndNextAlarm();
    }, onError: (error) {}, onDone: () {});
    update();
  }

  Future<AlarmData?> nextAlarm() async {
    List<AlarmData> alarmList = await _alarmProvider.getAllAlarms();
    AlarmData? result;
    int firstTrueStateIndex = 0;
    nextAlarmTitle = '';

    for (int i = 0; i < alarmList.length; i++) {
      if (alarmList[i].alarmState == true) {
        result = alarmList[i];
        nextAlarmTitle = result.title;
        nextAlarmTimeText = result.alarmDateTime.toString();
        firstTrueStateIndex = i;
        break;
      }
    }

    for (int i = firstTrueStateIndex + 1; i < alarmList.length; i++) {
      if (alarmList[i].alarmState == true &&
          alarmList[i].alarmDateTime.isBefore(result!.alarmDateTime)) {
        result = alarmList[i];
        nextAlarmTitle = result.title;
        nextAlarmTimeText = result.alarmDateTime.toString();
      }
    }

    alarm = result ?? alarm;
    update();
    return result;
  }

  void differenceTimeNowAndNextAlarm() async {
    DateTime? nextAlarmTime = (await nextAlarm())?.alarmDateTime;
    String result;
    if (nextAlarmTime == null) {
      result = LocaleKeys.allAlarmsAreOff.tr();
      nextAlarmTitle = '';
      nextAlarmTimeDifferenceText = result;
      return;
    } else {
      Duration difference = nextAlarmTime.difference(DateTime.now());
      if (difference.inDays < 1) {
        if (difference.inHours >= 1) {
          result = '${difference.inHours}'
              '${plural(LocaleKeys.hour_args, difference.inHours)} '
              '${difference.inMinutes % 60}'
              '${plural(LocaleKeys.minute_args, difference.inMinutes % 60)}';
        } else {
          result = '${difference.inMinutes}'
              '${plural(LocaleKeys.minute_args, difference.inMinutes)}';
        }
      } else {
        if (plural(LocaleKeys.next_day_args, difference.inDays) == 'day' ||
            plural(LocaleKeys.next_day_args, difference.inDays) == 'days') {
          result = '${difference.inDays} '
              '${plural(LocaleKeys.next_day_args, difference.inDays)}';
        } else {
          result = '${difference.inDays}'
              '${plural(LocaleKeys.next_day_args, difference.inDays)}';
        }
      }
    }
    result =
        '${LocaleKeys.prefixAfter.tr()}$result${LocaleKeys.suffixAfter.tr()}';
    if (nextAlarmTitle == '') {
      nextAlarmTitle = LocaleKeys.nextAlarmWillGoOff.tr();
    }

    nextAlarmTimeDifferenceText = result;
    update();
  }
}
