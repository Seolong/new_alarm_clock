import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/global/custom_radio_list_tile.dart';

import '../../../../utils/enum.dart';
import '../../../global/auto_size_text.dart';
import '../../../global/color_controller.dart';
import '../controller/repeat_radio_list_controller.dart';

class RepeatContainer extends StatelessWidget {
  final String repeatInterval = '반복 주기';
  final String repeatNum = '반복 횟수';
  String containerId = '';
  String containerName = '';

  RepeatContainer(this.containerId, this.containerName);

  Widget getRadioListTile(BuildContext context, int index) {
    if (containerId == repeatInterval) {
      return GetBuilder<RepeatRadioListController>(
        builder: (_) => CustomRadioListTile(
            radioValue: AlarmInterval.values[index],
            radioGroupValue: _.alarmInterval,
            onPressed: (AlarmInterval? value) {
              if (_.power == true) {
                _.alarmInterval = value!;
              }
            },
            title: _.getIntervalAsString(AlarmInterval.values[index]),
            activeColor: _.power? Get.find<ColorController>().colorSet.accentColor: Colors.grey,
            textColor: _.power
                ? _.textColor['active']!
                : _.textColor['inactive']!
        ),
      );
    } else if (containerId == repeatNum) {
      return GetBuilder<RepeatRadioListController>(
        builder: (_) => CustomRadioListTile(
            radioValue: RepeatNum.values[index],
            radioGroupValue: _.repeatNum,
            onPressed: (RepeatNum? value) {
              if (_.power == true) {
                _.repeatNum = value!;
              }
            },
            title: _.getRepeatNumAsString(RepeatNum.values[index]),
            activeColor: _.power? Get.find<ColorController>().colorSet.accentColor: Colors.grey,
            textColor: _.power
                ? _.textColor['active']!
                : _.textColor['inactive']!
        ),
      );
    } else {
      assert(false, 'RepeatContainer: getRadioList error');
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      decoration: BoxDecoration(
          border: Border.all(
            color: Get.find<ColorController>().colorSet.mainColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(7.5))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 0, 15),
            child: Row(
              children: [
                Container(
                  height: 30,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 1, minHeight: 1),
                      child:
                          GetBuilder<RepeatRadioListController>(builder: (_) {
                        return Icon(
                          Icons.alarm_rounded,
                          size: 1150,
                          color: _.power == true
                              ? Get.find<ColorController>().colorSet.mainColor
                              : Colors.grey,
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  height: 30,
                  child: GetBuilder<RepeatRadioListController>(builder: (_) {
                    return AutoSizeText(containerName,
                        bold: true,
                        color: _.power
                            ? Get.find<ColorController>().colorSet.mainColor
                            : Colors.grey);
                  }),
                ),
              ],
            ),
          ),

          //주기 리스트
          ListView.builder(
            shrinkWrap: true,
            itemCount: AlarmInterval.values.length,
            itemBuilder: (BuildContext context, int index) {
              return getRadioListTile(context, index);
            },
          ),
        ],
      ),
    );
  }
}