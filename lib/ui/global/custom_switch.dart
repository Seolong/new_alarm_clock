import 'package:flutter/material.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final List<Color> thumbColor;

  const CustomSwitch(
      {
        required this.value,
        required this.onChanged,
        required this.activeColor,
        required this.thumbColor,
        this.inactiveColor = Colors.black12,
      });

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late Animation _circleAnimation;
  late AnimationController _animationController;
  late Animation<Color?> _color;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 240));
    _circleAnimation = AlignmentTween(
        begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
        parent: _animationController, curve: Curves.linear));
    _color =
        ColorTween(
          begin: widget.value? widget.activeColor: widget.activeColor.withAlpha(100),
          end: widget.value? widget.activeColor.withAlpha(100): widget.activeColor,)
            .animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: 45,height: 70,),
                Container(
                  width: 45.0,
                  height: SizeValue.switchHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    // I commented here.
                    color: _color.value,
                  ),
                  child: Align(
                    alignment: _circleAnimation.value,
                    child: Container(
                      width: SizeValue.switchHeight,
                      height: SizeValue.switchHeight,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.value
                            ? null
                            : Colors.black12,
                        gradient: widget.value
                            ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // You can set your own colors in here!
                          colors: widget.thumbColor,
                        )
                            : null,
                      ),
                    ),
                  ),
                ),]
          ),
        );
      },
    );
  }
}