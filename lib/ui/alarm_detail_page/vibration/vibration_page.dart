import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/controller/vibration_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/global/divider/rounded_divider.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/vibration_pack.dart';
import 'package:vibration/vibration.dart';

class VibrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VibrationRadioListController vibrationRadioListController =
        Get.put(VibrationRadioListController());
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorValue.appbarText,
        title: Text('진동'),
        backgroundColor: ColorValue.appbar,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
              child: GetBuilder<VibrationRadioListController>(
                builder: (_) => SwitchListTile(
                    title: Text(
                      _.power ? '사용' : '사용 안 함',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: _.power ? ColorValue.alarm : Colors.grey),
                    ),
                    value: _.power,
                    onChanged: (value) {
                      if (_.power) {
                        _.listTextColor = _.textColor['inactive']!;
                        Vibration.cancel();
                      } else {
                        _.listTextColor = _.textColor['active']!;
                      }

                      _.power = value;
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: RoundedDivider(ColorValue.appbar, 7.5),
            ),

            //진동 리스트
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: VibrationName.values.length,
                itemBuilder: (BuildContext context, int index) {
                  return GetBuilder<VibrationRadioListController>(
                    builder: (_) => RadioListTile(
                        title: Text(
                          VibrationPack().convertVibrationNameToRadioName(
                              VibrationName.values[index])!,
                          style: TextStyle(
                              fontSize: 25,
                              color: _.power
                                  ? _.textColor['active']
                                  : _.textColor['inactive']),
                        ),
                        value: VibrationName.values[index],
                        groupValue: _.selectedVibration, //초기값
                        onChanged: (VibrationName? value) {
                          if (_.power == false) {
                          } else {
                            _.selectedVibration = value!;
                          }
                        }),
                  );
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}
