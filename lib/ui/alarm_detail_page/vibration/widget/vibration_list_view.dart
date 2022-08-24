import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/global/custom_radio_list_tile.dart';
import '../../../../utils/enum.dart';
import '../../../../utils/values/my_font_family.dart';
import '../../../../utils/values/vibration_Pack.dart';
import '../controller/vibration_radio_list_controller.dart';

class VibrationListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: VibrationName.values.length,
      itemBuilder: (BuildContext context, int index) {
        return GetBuilder<VibrationRadioListController>(
            builder: (_) => CustomRadioListTile(
                  value: VibrationName.values[index],
                  groupValue: _.selectedVibration,
                  onChanged: (VibrationName? value) {
                    if (_.power == false) {
                    } else {
                      _.selectedVibration = value!;
                    }
                  },
                  title: VibrationPack().convertVibrationNameToRadioName(
                      VibrationName.values[index])!,
                  activeColor: _.power
                      ? Get.find<ColorController>().colorSet.accentColor
                      : Colors.grey,
                  titleTextStyle: TextStyle(
                      color: _.power
                          ? _.textColor['active']!
                          : _.textColor['inactive']!,
                      fontSize: 18,
                      fontFamily: MyFontFamily.mainFontFamily),
                ));
      },
    );
  }
}
