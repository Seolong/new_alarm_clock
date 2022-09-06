import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/global/custom_radio_list_tile.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

import '../../../../utils/enum.dart';
import '../../../global/auto_size_text.dart';
import '../../../global/color_controller.dart';
import '../controller/repeat_radio_list_controller.dart';

class RepeatContainer extends StatelessWidget {
  final String repeatInterval = '반복 주기';
  final String repeatNum = '반복 횟수';
  String containerId = '';
  String containerName = '';

  RepeatContainer(this.containerId, this.containerName, {Key? key})
      : super(key: key);

  Widget getRadioListTile(BuildContext context, int index) {
    if (containerId == repeatInterval) {
      return GetBuilder<RepeatRadioListController>(
        builder: (_) => CustomRadioListTile(
          value: AlarmInterval.values[index],
          groupValue: _.alarmInterval,
          onChanged: (AlarmInterval? value) {
            if (_.power == true) {
              _.alarmInterval = value!;
            }
          },
          title: _.getIntervalAsString(AlarmInterval.values[index]),
          activeColor: _.power
              ? Get.find<ColorController>().colorSet.accentColor
              : Colors.grey,
          titleTextStyle: TextStyle(
              color:
                  _.power ? _.textColor['active']! : _.textColor['inactive']!,
              fontSize: 18,
              fontFamily: MyFontFamily.mainFontFamily),
        ),
      );
    } else if (containerId == repeatNum) {
      return GetBuilder<RepeatRadioListController>(
        builder: (_) => CustomRadioListTile(
          value: RepeatNum.values[index],
          groupValue: _.repeatNum,
          onChanged: (RepeatNum? value) {
            if (_.power == true) {
              _.repeatNum = value!;
            }
          },
          title: _.getRepeatNumAsString(RepeatNum.values[index]),
          activeColor: _.power
              ? Get.find<ColorController>().colorSet.accentColor
              : Colors.grey,
          titleTextStyle: TextStyle(
              color:
                  _.power ? _.textColor['active']! : _.textColor['inactive']!,
              fontSize: 18,
              fontFamily: MyFontFamily.mainFontFamily),
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
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      height: 250,
      decoration: BoxDecoration(
          border: Border.all(
            color: Get.find<ColorController>().colorSet.mainColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(7.5))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 0, 15),
            child: Row(
              children: [
                SizedBox(
                  height: 30,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: 1, minHeight: 1),
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
                const SizedBox(
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
          SizedBox(
            height: 150,
            child: ListView.builder(
              //shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: AlarmInterval.values.length,
              itemBuilder: (BuildContext context, int index) {
                return getRadioListTile(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
