import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';

import '../../../utils/values/color_value.dart';
import '../../global/color_controller.dart';
import '../../global/gradient_icon.dart';

class ChooseActionDialog extends StatelessWidget {
  const ChooseActionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        backgroundColor:
            Get.find<ColorController>().colorSet.topBackgroundColor,
        contentPadding: const EdgeInsets.fromLTRB(12.5, 0, 12.5, 0),
        content: SizedBox(
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Get.back(result: true);
                },
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientIcon(
                        icon: Icons.edit_rounded,
                        size: ButtonSize.large,
                        gradient: LinearGradient(
                          colors: <Color>[
                            Get.find<ColorController>().colorSet.lightMainColor,
                            Get.find<ColorController>().colorSet.deepMainColor,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(LocaleKeys.edit.tr(),
                          style: const TextStyle(color: ColorValue.black87)),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(),
              InkWell(
                onTap: () {
                  Get.back(result: false);
                },
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientIcon(
                        icon: Icons.delete_rounded,
                        size: ButtonSize.large,
                        gradient: LinearGradient(
                          colors: <Color>[
                            Get.find<ColorController>().colorSet.lightMainColor,
                            Get.find<ColorController>().colorSet.deepMainColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(LocaleKeys.delete.tr(),
                          style: const TextStyle(color: ColorValue.black87)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
