import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final double touchAreaHeight;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final List<Color> thumbColor;
  final double switchHeight;

  const CustomSwitch(
      {
        this.touchAreaHeight = 70,
        required this.value,
        required this.onChanged,
        required this.activeColor,
        required this.thumbColor,
        this.inactiveColor = Colors.black12,
        this.switchHeight = 22
      });

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  double _start = 0.0;
  double _end = 1.0;
  late Animation _circleAnimation;
  late AnimationController _animationController;
  late Animation<Color?> _trackColor;
  late double animationTarget;

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
    _trackColor =
        ColorTween(
          begin: widget.value? widget.activeColor: widget.activeColor.withAlpha(100),
          end: widget.value? widget.activeColor.withAlpha(100): widget.activeColor,)
            .animate(_animationController);
    animationTarget = _start;
  }

  @override
  void didUpdateWidget(CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if(animationTarget==_start){
        animationTarget=_end;
      }else if(animationTarget==_end){
        animationTarget=_start;
      }else{
        assert(false, "CustomSwitch error: didUpdateWidget");
      }
      _animationController.animateTo(animationTarget);
    }
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
                SizedBox(width: 45, height: widget.touchAreaHeight,),
                Container(
                  width: 45.0,
                  height: widget.switchHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: _trackColor.value,
                  ),
                  child: Align(
                    alignment: _circleAnimation.value,
                    child: Container(
                      width: widget.switchHeight,
                      height: widget.switchHeight,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.value
                            ? null
                            : Colors.black12,
                        gradient: widget.value
                            ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
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