import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/model/alarm_week_repeat_data.dart';
import 'package:new_alarm_clock/data/shared_preferences/app_state_shared_preferences.dart';
import 'package:new_alarm_clock/data/shared_preferences/id_shared_preferences.dart';
import 'package:new_alarm_clock/service/date_time_calculator.dart';
import 'package:new_alarm_clock/service/music_handler.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

class DraggableDismissButton extends StatefulWidget {
  const DraggableDismissButton({Key? key, required this.child})
      : super(key: key);
  final Widget child;

  @override
  _DraggableDismissButtonState createState() => _DraggableDismissButtonState();
}

class _DraggableDismissButtonState extends State<DraggableDismissButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation;
  Alignment _dragAlignment = Alignment.center;
  final AppStateSharedPreferences _appStateSharedPreferences =
      AppStateSharedPreferences();
  final IdSharedPreferences _idSharedPreferences = IdSharedPreferences();
  Color buttonColor = ColorValue.dismissAlarmButton;
  Color buttonOutsideColor = ColorValue.mainBackground;
  int alarmId = -1;
  AlarmProvider _alarmProvider = AlarmProvider();
  MusicHandler _musicHandler = MusicHandler();
  bool isDismissed = false; // 드래그나 꾹 눌렀으면 true

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _runAnimation(Offset pixelsperSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );

    final unitsPerSecondX = pixelsperSecond.dx / size.width;
    final unitsPerSecondY = pixelsperSecond.dx / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    final spring = SpringDescription(mass: 30, stiffness: 1, damping: 1);

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  //삭제가 아닌 state를 off
  void offAlarm() async {
    //드래그하면 자꾸 중복호출돼서 만든 궁여지책
    if(isDismissed == false){
      isDismissed = true;
      alarmId = await _idSharedPreferences.getAlarmedId();
      AlarmData alarmData = await _alarmProvider.getAlarmById(alarmId);

      //알람 타입이 반복일 때
      if (alarmData.alarmType != RepeatMode.single &&
          alarmData.alarmType != RepeatMode.off) {
        DateTimeCalculator dateTimeCalculator = DateTimeCalculator();

        //말일이면 lastDay 변수 추가해서 처리
        //week이면 weekBool 변수 추가해서 처리
        List<bool> weekBool = [];
        bool lastDay = false;
        if(alarmData.alarmType == RepeatMode.week){
          AlarmWeekRepeatData? alarmWeekRepeatData = await _alarmProvider.getAlarmWeekDataById(alarmId);
          weekBool.add(alarmWeekRepeatData!.sunday);
          weekBool.add(alarmWeekRepeatData.monday);
          weekBool.add(alarmWeekRepeatData.tuesday);
          weekBool.add(alarmWeekRepeatData.wednesday);
          weekBool.add(alarmWeekRepeatData.thursday);
          weekBool.add(alarmWeekRepeatData.friday);
          weekBool.add(alarmWeekRepeatData.saturday);
        }
        else if(alarmData.alarmType == RepeatMode.month){
          if(alarmData.monthRepeatDay == 29){
            lastDay = true;
          }
        }


        alarmData.alarmDateTime = dateTimeCalculator.addDateTime(
            alarmData.alarmType,
            alarmData.alarmDateTime,
            alarmData.alarmInterval,
            weekBool : alarmData.alarmType == RepeatMode.week? weekBool: null,
            lastDay: lastDay
        );
        print('print ${alarmData.alarmInterval}');
        print(alarmData.alarmDateTime);
      }
      else{
        alarmData.alarmState = false;
      }

      await _alarmProvider.updateAlarm(alarmData);
      await _appStateSharedPreferences.setAppStateToMain();
      await Vibration.cancel();
      await _musicHandler.stopMusic();
      await Wakelock.disable();
      SystemChannels.platform.invokeMethod('SystemNavigator.pop'); //SystemNavigator.pop()하니까 안 될 때가 있더라
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 250,
        height: 250,
        padding: EdgeInsets.all(50),
        decoration: BoxDecoration(
          color: buttonOutsideColor,
          borderRadius: BorderRadius.all(Radius.circular(250)),
        ),
      ),
      GestureDetector(
        onPanDown: (details) {
          _controller.stop();
        },
        onPanUpdate: (details) {
          if (details.localPosition.dx < 130 ||
              details.localPosition.dx > 270 ||
              details.localPosition.dy < 30 ||
              details.localPosition.dy > 300) {
            offAlarm();
          }
          setState(() {
            _dragAlignment += Alignment(
              details.delta.dx / (size.width / 2),
              details.delta.dy / (size.height / 2),
            );
          });
        },
        onPanEnd: (details) {
          _runAnimation(details.velocity.pixelsPerSecond, size);
          setState(() {
            buttonColor = ColorValue.dismissAlarmButton;
            buttonOutsideColor = ColorValue.mainBackground;
          });
        },
        onLongPress: () {
          offAlarm();
        },
        onTapDown: (details) {
          setState(() {
            buttonColor = Colors.grey;
            buttonOutsideColor = Colors.white12;
          });
        },
        onTapUp: (details) {
          setState(() {
            buttonColor = ColorValue.dismissAlarmButton;
            buttonOutsideColor = ColorValue.mainBackground;
          });
        },
        child: Align(
          alignment: _dragAlignment,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 0.5,
                  blurRadius: 1.5,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
      Positioned(
          bottom: 50,
          child: Text(
            '버튼을 꾹 누르거나 드래그 해서 알람 끄기',
            style: TextStyle(
                color: ColorValue.alarmText,
                fontWeight: FontWeight.bold,
                fontFamily: MyFontFamily.mainFontFamily),
          ))
    ]);
  }
}
