import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import '../../../../../data/database/alarm_provider.dart';
import '../../../../../data/model/alarm_data.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../../utils/values/my_font_family.dart';
import '../../../../global/color_controller.dart';

class NextAlarmContainer extends StatelessWidget {
  final AlarmProvider _alarmProvider = AlarmProvider();
  String nextAlarmTimeDifferenceText = LocaleKeys.allAlarmsAreOff.tr();
  String nextAlarmTimeText = '';
  String? nextAlarmTitle;
  final double nextAlarmContainerHeight = 70.0;

  NextAlarmContainer({Key? key}) : super(key: key);

  Future<DateTime?> nextAlarm() async {
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

    return result?.alarmDateTime;
  }

  void differenceTimeNowAndNextAlarm() async {
    DateTime? nextAlarmTime = await nextAlarm();
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
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: nextAlarmContainerHeight * 2.0 - 30,
        color: Colors.transparent,
      ),
      Container(
        height: nextAlarmContainerHeight - 20,
        decoration: BoxDecoration(
            color: Get.find<ColorController>().colorSet.mainColor,
            border: Border.all(
                color: Get.find<ColorController>().colorSet.mainColor)),
      ),
      Positioned(
        top: nextAlarmContainerHeight / 2.0 - 20,
        left: 10.0,
        right: 10.0,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Get.find<ColorController>().colorSet.appBarContentColor,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(blurRadius: 4.0, color: Colors.grey[400]!)
              ]),
          height: nextAlarmContainerHeight,
          child: StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              differenceTimeNowAndNextAlarm();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6.0, 0.0, 12.0, 0.0),
                      child: Icon(
                        Icons.event_note_rounded,
                        color: Colors.grey,
                      ),
                    ),
                    VerticalDivider(
                      thickness: 1.0,
                      width: 0.0,
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nextAlarmTimeDifferenceText,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: MyFontFamily.mainFontFamily,
                              color: Colors.grey[800]!,
                              //letterSpacing: 0
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 1.0,
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          Text(
                            nextAlarmTitle ?? '',
                            style: TextStyle(
                                fontSize: nextAlarmTitle != '' ? 14 : 0,
                                fontFamily: MyFontFamily.mainFontFamily,
                                color: Colors.grey[600]!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 1.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    ]);
  }
}
