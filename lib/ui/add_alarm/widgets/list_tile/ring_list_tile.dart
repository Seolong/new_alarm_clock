import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../../utils/values/string_value.dart';

class RingListTile extends AlarmDetailListTile{
  RingListTile(){
    tileTitle = Text(
      LocaleKeys.sound.tr(),
      textAlign: TextAlign.start,
      style: TextStyle(
        color: ColorValue.listTileTitleText,
        fontFamily: MyFontFamily.mainFontFamily,
        fontSize: 1000
      ),
    );
    tileSubTitle = GetBuilder<RingRadioListController>(
        builder: (_) {
          return Text(_.getNameOfSong(_.selectedMusicPath), //알람음 설정
            style: TextStyle(
                color: Get.find<ColorController>().colorSet.mainColor,
                fontFamily: MyFontFamily.mainFontFamily,
                fontSize: 1000),
          );
        }
    );
    stateSwitch = GetBuilder<RingRadioListController>(
        builder: (_) {
          return CustomSwitch(
              value: _.power,
              onChanged: (value) {
                if (_.power) {
                  _.listTextColor = _.textColor[StringValue.inactive]!;
                } else {
                  _.listTextColor = _.textColor[StringValue.active]!;
                }

                _.power = value;
              },
            activeColor: Get.find<ColorController>().colorSet.mainColor,
          );
        }
    );
  }
}



class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final String activeText;
  final String inactiveText;
  final Color activeTextColor;
  final Color inactiveTextColor;

  const CustomSwitch(
      {
        required this.value,
        required this.onChanged,
        required this.activeColor,
        this.inactiveColor = Colors.grey,
        this.activeText = '',
        this.inactiveText = '',
        this.activeTextColor = Colors.white70,
        this.inactiveTextColor = Colors.white70});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late Animation _circleAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
        begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
        parent: _animationController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
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
          child: Container(
            width: 40.0,
            height: 20.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              // I commented here.
              // color: _circleAnimation.value == Alignment.centerLeft
              //     ? widget.inactiveColor
              //     : widget.activeColor,

              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                // You can set your own colors in here!
                colors: [
                  Colors.blue,
                  Colors.red,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 4.0, bottom: 4.0, right: 0.0, left: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _circleAnimation.value == Alignment.centerRight
                      ? Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 0),
                    child: Text(
                      widget.activeText,
                      style: TextStyle(
                          color: widget.activeTextColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0),
                    ),
                  )
                      : Container(),
                  Align(
                    alignment: _circleAnimation.value,
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                    ),
                  ),
                  _circleAnimation.value == Alignment.centerLeft
                      ? Padding(
                    padding: const EdgeInsets.only(left: 0, right: 16.0),
                    child: Text(
                      widget.inactiveText,
                      style: TextStyle(
                          color: widget.inactiveTextColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0),
                    ),
                  )
                      : Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}