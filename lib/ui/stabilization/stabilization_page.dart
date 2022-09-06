import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/stabilization/controller/permission_controller.dart';
import 'package:new_alarm_clock/ui/stabilization/widget/stabilization_container.dart';

import '../../generated/locale_keys.g.dart';

class StabilizationPage extends StatelessWidget {
  StabilizationPage({Key? key, this.beforePage}) : super(key: key);

  String? beforePage;
  final String setting = 'setting';

  @override
  Widget build(BuildContext context) {
    var colorController = Get.find<ColorController>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorController.colorSet.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              beforePage == setting
                  ? const SizedBox.shrink()
                  : OutlinedButton(
                      onPressed: () {
                        Get.find<PermissionController>()
                            .warningSharedPreference
                            .setIsIgnoreValue(true);
                        Get.find<PermissionController>().update();
                        Get.back();
                      },
                style: OutlinedButton.styleFrom(side: BorderSide(
                  color: colorController.colorSet.mainTextColor.withAlpha(175),
                  style: BorderStyle.solid,
                ),),
                      child: Text(
                        LocaleKeys.ignoreThisWarning.tr(),
                        style: TextStyle(color: colorController.colorSet.mainTextColor.withAlpha(175)),
                      ),
                    ),
              const SizedBox(
                height: 16,
              ),
              StabilizationContainer(
                code: Get.find<PermissionController>().displayOver,
                title: LocaleKeys.displayOverOtherApps.tr(),
                content: LocaleKeys.displayOverRequest.tr(),
              ),
              StabilizationContainer(
                code: Get.find<PermissionController>().batteryOptimization,
                title: LocaleKeys.batteryOptimization.tr(),
                content: LocaleKeys.batteryOptimizationIsOn.tr(),
              ),
              StabilizationContainer(
                code: Get.find<PermissionController>().doNotDisturb,
                title: LocaleKeys.doNotDisturbMode.tr(),
                content: LocaleKeys.doNotDisturbModeRequest.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
