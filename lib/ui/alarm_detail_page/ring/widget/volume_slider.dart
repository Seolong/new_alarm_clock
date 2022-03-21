import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';

class VolumeSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RingRadioListController>(
      builder: (_) {
        return Slider(
            value: _.volume, //초기값
            onChanged: (value) {
              if(_.power == true){
                _.volume = value;
              }
            },
          activeColor: _.power ? ColorValue.activeSwitch : Colors.grey,
        );
      }
    );
  }
}
