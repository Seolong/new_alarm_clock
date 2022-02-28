import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/shared_preferences/app_state_shared_preferences.dart';
import 'package:new_alarm_clock/data/shared_preferences/id_shared_preferences.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:vibration/vibration.dart';

class DraggableDismissButton extends StatefulWidget {
  const DraggableDismissButton({Key? key, required this.child}) : super(key: key);
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
  void offAlarm() async{
    alarmId = await _idSharedPreferences.getAlarmedId();
    AlarmData alarmData = await _alarmProvider.getAlarmById(alarmId)
      ..alarmState = false;
    await _alarmProvider.updateAlarm(alarmData);
    _appStateSharedPreferences.setAppStateToMain();
    Vibration.cancel();
    SystemNavigator.pop();
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
          setState(() {
            _dragAlignment += Alignment(
              details.delta.dx / (size.width / 2),
              details.delta.dy / (size.height / 2),
            );
          });
          //print('${details.localPosition}');
          if (details.localPosition.dx < 130 ||
              details.localPosition.dx > 270 ||
              details.localPosition.dy < 30 ||
              details.localPosition.dy > 300) {
            offAlarm();
          }
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
      Positioned(bottom: 50,
          child: Text('버튼을 꾹 누르거나 드래그 해서 알람 끄기',
            style: TextStyle(
                color: ColorValue.alarmText,
                fontWeight: FontWeight.bold,
                fontFamily: MyFontFamily.mainFontFamily),))
    ]);
  }
}
