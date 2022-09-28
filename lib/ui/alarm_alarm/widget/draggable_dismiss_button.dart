import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/shared_preferences/app_state_shared_preferences.dart';
import 'package:new_alarm_clock/data/shared_preferences/id_shared_preferences.dart';
import 'package:new_alarm_clock/data/shared_preferences/repeat_count_shared_preferences.dart';
import 'package:new_alarm_clock/service/alarm_scheduler.dart';
import 'package:new_alarm_clock/service/music_handler.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:io' show Platform;

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
  final RepeatCountSharedPreferences _repeatCountSharedPreferences =
      RepeatCountSharedPreferences();
  Color buttonColor = Get.find<ColorController>().colorSet.mainColor;
  Color buttonOutsideColor =
      Colors.transparent;
  int alarmId = -1;
  final AlarmProvider _alarmProvider = AlarmProvider();
  final MusicHandler _musicHandler = MusicHandler();
  bool isDismissed = false; // 드래그나 꾹 눌렀으면 true
  bool isLongPressOrDrag = false;
  AlarmScheduler alarmScheduler = AlarmScheduler();

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
    Timer(const Duration(minutes: 1), offAlarm);
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

    const spring = SpringDescription(mass: 30, stiffness: 1, damping: 1);

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  //삭제가 아닌 state를 off
  Future<void> offAlarm() async {
    //드래그하면 자꾸 중복호출돼서 만든 궁여지책
    if (isDismissed == false) {
      isDismissed = true;
      alarmId = await _idSharedPreferences.getAlarmedId();
      AlarmData alarmData = await _alarmProvider.getAlarmById(alarmId);

      if (isLongPressOrDrag == false) {
        //1분 지나서 꺼졌을 경우
        if (alarmData.repeatBool == false) {
          await _repeatCountSharedPreferences.resetRepeatCount();
          await alarmScheduler.updateToNextAlarm(alarmData);
        } else {
          await _repeatCountSharedPreferences.setRepeatCount();
          int repeatCount =
              await _repeatCountSharedPreferences.getRepeatCount();
          int repeatInterval = alarmData.repeatInterval;
          int repeatNum = alarmData.repeatNum;
          if (repeatCount < repeatNum) {
            DateTime nextAlarmTime = alarmData.alarmDateTime
                .add(Duration(minutes: (repeatCount * repeatInterval)));
            alarmScheduler.newShot(nextAlarmTime, alarmData.id);
          } else {
            await _repeatCountSharedPreferences.resetRepeatCount();
            await alarmScheduler.updateToNextAlarm(alarmData);
          }
        }
      } else {
        //버튼 드래그, 롱프레스로 알람을 껐을 경우
        await _repeatCountSharedPreferences.resetRepeatCount();
        await alarmScheduler.updateToNextAlarm(alarmData);
      }

      await _appStateSharedPreferences.setAppStateToMain();
      await Vibration.cancel();
      await _musicHandler.stopMusic();
      await Wakelock.disable();

      //SystemNavigator.pop()하니까 안 될 때가 있더라
      if (Platform.isAndroid) {
        await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      } else if (Platform.isIOS) {}
    }
  }

  void changeButtonColor(bool isPressedOrDragged) {
    if (isPressedOrDragged) {
      buttonColor = Colors.grey;
      buttonOutsideColor = Colors.white12;
    } else {
      buttonColor = Get.find<ColorController>().colorSet.mainColor;
      buttonOutsideColor = Get.find<ColorController>().colorSet.backgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 250,
        height: 250,
        padding: const EdgeInsets.all(50),
        decoration: BoxDecoration(
          color: buttonOutsideColor,
          borderRadius: const BorderRadius.all(Radius.circular(250)),
        ),
      ),
      GestureDetector(
        onPanDown: (details) {
          //_controller.stop();
          changeButtonColor(true);
        },
        onPanUpdate: (details) async {
          if (details.localPosition.dx < 130 ||
              details.localPosition.dx > 270 ||
              details.localPosition.dy < 30 ||
              details.localPosition.dy > 300) {
            isLongPressOrDrag = true;
            await offAlarm();
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
            changeButtonColor(false);
          });
        },
        onLongPress: () async {
          isLongPressOrDrag = true;
          await offAlarm();
        },
        onTapDown: (details) {
          setState(() {
            changeButtonColor(true);
          });
        },
        onTapUp: (details) {
          setState(() {
            changeButtonColor(false);
          });
        },
        child: Align(
          alignment: _dragAlignment,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              boxShadow: const [
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
          bottom: 25,
          child: Text(
            '버튼을 꾹 누르거나 드래그 해서 알람 끄기',
            style: TextStyle(
                color: Get.find<ColorController>().colorSet.mainTextColor,
                fontWeight: FontWeight.bold,
                fontFamily: MyFontFamily.mainFontFamily),
          ))
    ]);
  }
}
