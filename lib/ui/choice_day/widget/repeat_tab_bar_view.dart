import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_container_factory.dart';
import 'package:new_alarm_clock/utils/enum.dart';

class RepeatTabBarView extends StatelessWidget {
  RepeatContainerFactory _repeatContainerFactory = RepeatContainerFactory();

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        _repeatContainerFactory.getRepeatContainer(RepeatMode.day)!,
        _repeatContainerFactory.getRepeatContainer(RepeatMode.week)!,
        _repeatContainerFactory.getRepeatContainer(RepeatMode.month)!,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.indigoAccent,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }
}
