import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../../../../utils/enum.dart';
import '../../../../utils/values/color_value.dart';
import '../../../../utils/values/vibration_Pack.dart';
import '../../../global/auto_size_text.dart';
import '../controller/vibration_radio_list_controller.dart';

class VibrationListView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: VibrationName.values.length,
      itemBuilder: (BuildContext context, int index) {
        return GetBuilder<VibrationRadioListController>(
          builder: (_) => RadioListTile(
            title: Container(
              alignment: Alignment.bottomLeft,
              height: 30,
              child: AutoSizeText(
                  VibrationPack().convertVibrationNameToRadioName(
                      VibrationName.values[index])!,
                  color: _.power
                      ? _.textColor['active']
                      : _.textColor['inactive']),
            ),
            value: VibrationName.values[index],
            groupValue: _.selectedVibration,
            //초기값
            onChanged: (VibrationName? value) {
              if (_.power == false) {
              } else {
                _.selectedVibration = value!;
              }
            },
            activeColor: ColorValue.activeSwitch,
          ),
        );
      },
    );
  }
}
