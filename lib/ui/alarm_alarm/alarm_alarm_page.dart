import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/shared_preferences/id_shared_preferences.dart';
import 'package:new_alarm_clock/service/music_handler.dart';
import 'package:new_alarm_clock/ui/alarm_alarm/controller/alarm_alarm_controller.dart';
import 'package:new_alarm_clock/ui/alarm_alarm/widget/dismiss_button.dart';
import 'package:new_alarm_clock/ui/alarm_alarm/widget/ripple_animation.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:intl/intl.dart';
import 'package:new_alarm_clock/utils/values/vibration_pack.dart';
import 'package:wakelock/wakelock.dart';

class AlarmAlarmPage extends StatelessWidget {
  int alarmId = -1;
  Future<AlarmData>? alarmData;
  final AlarmProvider _alarmProvider = AlarmProvider();
  final IdSharedPreferences _idSharedPreferences = IdSharedPreferences();
  final VibrationPack _vibrationPack = VibrationPack();
  final MusicHandler _musicHandler = MusicHandler();
  final AlarmAlarmController _alarmAlarmController = AlarmAlarmController();

  AlarmAlarmPage({Key? key}) : super(key: key) {
    Timer(const Duration(minutes: 1), _alarmAlarmController.offAlarmWithTimer);
  }

  Future<AlarmData> getAlarmData() async {
    alarmId = await _idSharedPreferences.getAlarmedId();
    if (kDebugMode) {
      print('alarming alarm id = $alarmId');
    }
    // return AlarmData(
    //   id: 10000,
    //   title: 'Hi!',
    //   alarmType: RepeatMode.day,
    //   alarmDateTime: DateTime.now(),
    //   endDay: null,
    //   alarmState: true,
    //   alarmOrder: 10000,
    //   folderId: 10000,
    //   alarmInterval: 1,
    //   monthRepeatDay: 1,
    //   musicBool: false,
    //   musicPath: '',
    //   musicVolume: 0,
    //   vibrationBool: true,
    //   vibrationName: VibrationName.heartBeat,
    //   repeatBool: false,
    //   repeatInterval: 5,
    //   repeatNum: 3,
    // );
    return _alarmProvider.getAlarmById(alarmId);
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    Get.put(ColorController());
    alarmData = getAlarmData();
    return Scaffold(
      backgroundColor: Get.find<ColorController>().colorSet.backgroundColor,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 200,
          ),
          SizedBox(
            height: 200,
            child: UnconstrainedBox(
              child: RipplesAnimation(
                size: 200,
                color: Get.find<ColorController>().colorSet.mainColor,
                child: FutureBuilder<AlarmData>(
                    future: alarmData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.musicBool == true) {
                          _musicHandler.initOriginalVolume();
                          _musicHandler.playMusic(snapshot.data!.musicVolume,
                              snapshot.data!.musicPath);
                        }
                        if (snapshot.data!.vibrationBool == true) {
                          _vibrationPack.vibrateByVibrationName(
                              snapshot.data!.vibrationName);
                        }
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('HH:mm')
                                  .format((snapshot.data)!.alarmDateTime),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Get.find<ColorController>()
                                      .colorSet
                                      .appBarContentColor,
                                  fontSize: 70,
                                  fontFamily: MyFontFamily.mainFontFamily),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
              ),
            ),
          ),
          const SizedBox(height: 50,),
          Container(
              width: 300,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: Get.find<ColorController>().colorSet.backgroundColor,
                border: Border.all(
                  color: Get.find<ColorController>().colorSet.mainColor,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 20.5,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<AlarmData>(
                      future: alarmData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 5,),
                              Text(
                                Jiffy(snapshot.data!.alarmDateTime).MMMEd,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Get.find<ColorController>()
                                        .colorSet
                                        .mainColor,
                                    fontSize: 24,
                                    fontFamily: MyFontFamily.mainFontFamily),
                              ),
                              const SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  snapshot.data!.title ?? '',
                                  style: TextStyle(
                                      color: Get.find<ColorController>()
                                          .colorSet
                                          .mainTextColor,
                                      fontSize: 24,
                                      fontFamily: MyFontFamily.mainFontFamily),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 20,),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                  DismissButton(),
                ],
              )),
        ],
      ),
    );
  }
}
