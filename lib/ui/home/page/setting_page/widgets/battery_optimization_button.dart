import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import '../../../../../service/call_native_service.dart';
import '../../../../global/color_controller.dart';
import '../../../home_page.dart';
import '../../../widgets/battery_optimization_dialog.dart';

class BatteryOptimizationButton extends StatelessWidget {
  final DialogStateSharedPreference dialogStateSharedPreference =
      DialogStateSharedPreference();

  BatteryOptimizationButton({Key? key}) : super(key: key);

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
    } else {
      Get.dialog(AlertDialog(
        backgroundColor:
            Get.find<ColorController>().colorSet.topBackgroundColor,
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sentiment_satisfied_outlined,
              color: Get.find<ColorController>().colorSet.mainTextColor,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: Text(
              LocaleKeys.batteryOptimizationIsTurnedOff.tr(),
            )),
          ],
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      onTap: () async {
        setBatteryOptimizations();
      },
      child: ListTile(
        leading: Icon(
          Icons.battery_saver_rounded,
          size: ButtonSize.medium,
          color: Colors.green,
        ),
        title: Text(
          LocaleKeys.batteryOptimization.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
