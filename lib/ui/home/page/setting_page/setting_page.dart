import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/widgets/align_button.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/widgets/reset_button.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/widgets/set_home_folder_button.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';

class SettingPage extends StatelessWidget {
  AlarmProvider _alarmProvider = AlarmProvider();
  String nextAlarmTimeDifferenceText = LocaleKeys.allAlarmsAreOff.tr();
  String nextAlarmTimeText = '';
  String? nextAlarmTitle;

  List<Widget> settingButtons = [
    SetHomeFolderButton(),
    AlignButton(),
    ResetButton(),
  ];

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
    int? folderCrossAxisCount = Get.width ~/ 100;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                differenceTimeNowAndNextAlarm();
                return Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 50,
                        child: AutoSizeText(
                            nextAlarmTimeText
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 100,
                        child: AutoSizeText(
                          nextAlarmTimeDifferenceText
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 100,
                        child: AutoSizeText(
                            nextAlarmTitle ?? ''
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              height: 150,
              alignment: Alignment.center,
              child: Text(
                LocaleKeys.moreOptions.tr(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: MyFontFamily.mainFontFamily),
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: settingButtons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: folderCrossAxisCount != 0
                        ? folderCrossAxisCount
                        : 1, //1 개의 행에 보여줄 item 개수
                    mainAxisSpacing: 10, //수평 Padding
                    crossAxisSpacing: 10, //수직 Padding
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return settingButtons[index];
                  }),
            )
          ],
        ),
      ),
    );
  }
}
