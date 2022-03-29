import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/shared_preferences/id_shared_preferences.dart';
import 'package:new_alarm_clock/service/music_handler.dart';
import 'package:new_alarm_clock/ui/alarm_alarm/widget/draggable_dismiss_button.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:intl/intl.dart';
import 'package:new_alarm_clock/utils/values/vibration_pack.dart';
import 'package:wakelock/wakelock.dart';

class AlarmAlarmPage extends StatefulWidget {
  @override
  State<AlarmAlarmPage> createState() => _AlarmAlarmPageState();
}

class _AlarmAlarmPageState extends State<AlarmAlarmPage> {
  int alarmId = -1;
  Future<AlarmData>? alarmData = null;
  AlarmProvider _alarmProvider = AlarmProvider();
  final IdSharedPreferences _idSharedPreferences = IdSharedPreferences();
  VibrationPack _vibrationPack = VibrationPack();
  MusicHandler _musicHandler = MusicHandler();

  Future<AlarmData> getAlarmData() async {
    alarmId = await _idSharedPreferences.getAlarmedId();
    //alarmId = 0;
    print('alarming alarm id = $alarmId');
    return _alarmProvider.getAlarmById(alarmId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Wakelock.enable();
    alarmData = getAlarmData();
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return Scaffold(
      backgroundColor: ColorValue.mainBackground,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<AlarmData>(
                future: alarmData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.data!.musicBool == true){
                      _musicHandler.initOriginalVolume();
                      _musicHandler.playMusic(snapshot.data!.musicVolume, snapshot.data!.musicPath);
                    }
                    if(snapshot.data!.vibrationBool == true){
                      _vibrationPack.vibrateByVibrationName(snapshot.data!.vibrationName);
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(height: 100,),
                        Text(
                          DateFormat('HH:mm')
                              .format((snapshot.data)!.alarmDateTime)
                              .toLowerCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorValue.alarmText,
                              fontSize: 70,
                              fontFamily: MyFontFamily.mainFontFamily),
                        ),
                        Text(
                          snapshot.data!.title ?? '',
                          style: TextStyle(
                              color: ColorValue.alarmText,
                              fontSize: 50,
                              fontFamily: MyFontFamily.mainFontFamily),
                        )
                      ],
                    );
                  }
                  return Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(ColorValue.fab),
                      ),
                    ),
                  );
                }),
          ),
          Flexible(
            child: DraggableDismissButton(
              child: Icon(
                Icons.alarm_off_rounded,
                size: ButtonSize.doubleXlarge,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
