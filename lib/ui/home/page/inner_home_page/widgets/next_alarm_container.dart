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
  final double nextAlarmContainerHeight = 60.0;

  NextAlarmContainer({Key? key}) : super(key: key);

  Future<DateTime?> nextAlarm() async{
    List<AlarmData> alarmList = await _alarmProvider.getAllAlarms();
    AlarmData? result;
    int firstTrueStateIndex = 0;

    for(int i=0; i<alarmList.length; i++){
      if(alarmList[i].alarmState == true){
        result = alarmList[i];
        nextAlarmTitle = result.title;
        nextAlarmTimeText = result.alarmDateTime.toString();
        firstTrueStateIndex = i;
      }
    }

    for(int i=firstTrueStateIndex+1; i<alarmList.length; i++){
      if(alarmList[i].alarmState == true && alarmList[i].alarmDateTime.isBefore(result!.alarmDateTime)){
        result = alarmList[i];
        nextAlarmTitle = result.title;
        nextAlarmTimeText = result.alarmDateTime.toString();
      }
    }

    return result?.alarmDateTime;
  }

  void differenceTimeNowAndNextAlarm() async{
    DateTime? nextAlarmTime = await nextAlarm();
    String result;
    if(nextAlarmTime == null){
      result = LocaleKeys.allAlarmsAreOff.tr();
    } else {
      Duration difference = nextAlarmTime.difference(DateTime.now());
      if(difference.inDays < 1){
        result = '${difference.inHours}시간 ${difference.inMinutes % 60}분 후';
      }else{
        result = '${difference.inDays}일 후';
      }
    }
    nextAlarmTimeDifferenceText = result;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(height: nextAlarmContainerHeight * 2.0, color: Colors.transparent,),
          Container(
            height: nextAlarmContainerHeight,
            decoration: BoxDecoration(
                color: Get.find<ColorController>().colorSet.mainColor,
                border: Border.all(color: Get.find<ColorController>().colorSet.mainColor)
            ),
          ),
          Positioned(
            top: nextAlarmContainerHeight / 2.0,
            left: 10.0,
            right: 10.0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Get.find<ColorController>().colorSet.appBarContentColor,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2.0,
                        color: Colors.grey[400]!
                    )
                  ]
              ),
              height: nextAlarmContainerHeight,
              child: StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  differenceTimeNowAndNextAlarm();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nextAlarmTimeDifferenceText + '에 알람이 울립니다.',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: MyFontFamily.mainFontFamily,
                              color: Colors.grey[600]!
                          ),
                        ),
                        Text(
                          nextAlarmTitle ?? '',
                          style: TextStyle(
                              fontSize: nextAlarmTitle != null? 12: 0,
                              fontFamily: MyFontFamily.mainFontFamily,
                              color: Colors.grey[600]!
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ]
    );
  }
}
