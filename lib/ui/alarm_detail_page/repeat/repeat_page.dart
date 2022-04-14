import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/controller/repeat_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/widget_all/app_bar_title.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/global/divider/rounded_divider.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';

class RepeatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(RepeatRadioListController());
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorValue.appbarText,
        title: AppBarTitle('반복'),
        backgroundColor: ColorValue.appbar,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
              child: GetBuilder<RepeatRadioListController>(
                builder: (_) => SwitchListTile(
                  title: Container(
                    alignment: Alignment.bottomLeft,
                    height: SizeValue.detailPowerTextHeight,
                    child: AutoSizeText(_.power ? '사용' : '사용 안 함',
                        bold: true,
                        color: _.power ? ColorValue.activeSwitch : Colors.grey),
                  ),
                  value: _.power,
                  onChanged: (value) {
                    if (_.power) {
                      _.listTextColor = _.textColor['inactive']!;
                    } else {
                      _.listTextColor = _.textColor['active']!;
                    }

                    _.power = value;
                  },
                  activeColor: ColorValue.activeSwitch,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: RoundedDivider(ColorValue.appbar, 7.5),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 5, 0, 0),
              child: Container(
                alignment: Alignment.bottomLeft,
                height: 30,
                child: AutoSizeText('주기', bold: true, color: Colors.grey),
              ),
            ),

            //주기 리스트
            Wrap(children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: AlarmInterval.values.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GetBuilder<RepeatRadioListController>(
                        builder: (_) => RadioListTile(
                          title: Container(
                            alignment: Alignment.bottomLeft,
                            height: 30,
                            child: AutoSizeText(
                                _.getIntervalAsString(AlarmInterval.values[index]),
                                color: _.power
                                    ? _.textColor['active']
                                    : _.textColor['inactive']),
                          ),
                          value: AlarmInterval.values[index],
                          groupValue: _.alarmInterval,
                          //초기값
                          onChanged: (AlarmInterval? value) {
                            if (_.power == false) {
                            } else {
                              _.alarmInterval = value!;
                            }
                          },
                          activeColor: ColorValue.activeSwitch,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: RoundedDivider(ColorValue.appbar, 7.5),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 5, 0, 0),
              child: Container(
                alignment: Alignment.bottomLeft,
                height: 30,
                child: AutoSizeText('반복 횟수', bold: true, color: Colors.grey),
              ),
            ),
            //반복횟수 리스트
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: RepeatNum.values.length,
                itemBuilder: (BuildContext context, int index) {
                  return GetBuilder<RepeatRadioListController>(
                    builder: (_) => RadioListTile(
                      title: Container(
                        alignment: Alignment.bottomLeft,
                        height: 30,
                        child: AutoSizeText(
                            _.getRepeatNumAsString(RepeatNum.values[index]),
                            color: _.power
                                ? _.textColor['active']
                                : _.textColor['inactive']),
                      ),
                      value: RepeatNum.values[index],
                      groupValue: _.repeatNum,
                      //초기값
                      onChanged: (RepeatNum? value) {
                        if (_.power == false) {
                        } else {
                          _.repeatNum = value!;
                        }
                      },
                      activeColor: ColorValue.activeSwitch,
                    ),
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
