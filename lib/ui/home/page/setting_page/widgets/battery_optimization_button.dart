import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import '../../../../../service/call_native_service.dart';
import '../../../../global/auto_size_text.dart';
import '../../../../global/color_controller.dart';
import '../../../home_page.dart';
import '../../../widgets/battery_optimization_dialog.dart';

class BatteryOptimizationButton extends StatelessWidget {
  final DialogStateSharedPreference dialogStateSharedPreference =
      DialogStateSharedPreference();

  Future<bool> checkBatteryOptimizations() async {
    return await CallNativeService().checkBatteryOptimizations();
  }

  Future<void> setBatteryOptimizations() async {
    if ((await checkBatteryOptimizations()) == false) {
      bool? isSet = await Get.dialog(BatteryOptimizationDialog(
        dialogStateSharedPreference,
        isFromButton: true,
      ));
      if (isSet == true) {
        CallNativeService().setBatteryOptimizations();
      }
    }else {
      Get.dialog(AlertDialog(content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sentiment_satisfied_outlined),
          SizedBox(width: 10,),
          Text('최적화가 꺼져 있습니다.'),
        ],
      ),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      onTap: () async {
        setBatteryOptimizations();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.battery_saver_rounded,
            size: 50,
            color: Colors.green,
          ),
          Container(
              height: 20,
              child: AutoSizeText(
                '배터리 최적화\n끄기',
                bold: true,
                color: Get.find<ColorController>().colorSet.mainTextColor,
              )),
        ],
      ),
    );
  }
}
