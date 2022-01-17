import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/controller/repeat_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/global/divider/rounded_divider.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';

class RepeatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(RepeatRadioListController());
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
              child: GetBuilder<RepeatRadioListController>(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 5, 0, 0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '주기',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  )),
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
                            title: Text(
                              _.convertInterval(AlarmInterval.values[index]),
                              style: TextStyle(
                                  fontSize: 25,
                                  color: _.power
                                      ? _.textColor['active']
                                      : _.textColor['inactive']),
                            ),
                            value: AlarmInterval.values[index],
                            groupValue: _.alarmInterval, //초기값
                            onChanged: (AlarmInterval? value) {
                              if (_.power == false) {
                              } else {
                                _.alarmInterval = value!;
                              }
                            }),
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
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '반복 횟수',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  )),
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
                        title: Text(
                          _.convertRepeatNum(RepeatNum.values[index]),
                          style: TextStyle(
                              fontSize: 25,
                              color: _.power
                                  ? _.textColor['active']
                                  : _.textColor['inactive']),
                        ),
                        value: RepeatNum.values[index],
                        groupValue: _.repeatNum, //초기값
                        onChanged: (RepeatNum? value) {
                          if (_.power == false) {
                          } else {
                            _.repeatNum = value!;
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
