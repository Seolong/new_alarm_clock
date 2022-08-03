import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
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
            thumbColor: [
              Get.find<ColorController>().colorSet.lightMainColor,
              Get.find<ColorController>().colorSet.mainColor,
              Get.find<ColorController>().colorSet.deepMainColor,
            ],
            activeColor: Get.find<ColorController>().colorSet.switchTrackColor,
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
              AnimatedContainer(
              padding: EdgeInsets.all(0.5),
              width: 45.0,
              height: SizeValue.switchHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                // I commented here.
                color: widget.value
                    ? widget.activeColor
                    : Colors.black12,
              ),
              duration: Duration(milliseconds: 200),
              child: Align(
                  alignment: _circleAnimation.value,
                  child: Material(
                    elevation: 2,
                    shape: CircleBorder(),
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
                ),
            ),]
          ),
        );
      },
    );
  }
}