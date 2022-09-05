import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/ui/stabilization/stabilization_page.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import '../../../../global/color_controller.dart';

class StabilizationButton extends StatelessWidget {
  final double buttonHeight = 37.5;
  final double buttonPadding = 7.5;
  final double radioRadius = 7.5;
  late final double borderRadius = radioRadius + 7.5;
  final double borderWidth = 2;
  final Color activeColor = Get.find<ColorController>().colorSet.mainColor;

  StabilizationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      onTap: () async {
        Get.to(StabilizationPage(beforePage: 'setting'));
      },
      child: ListTile(
        leading: Icon(
          Icons.memory_rounded,
          size: ButtonSize.medium,
          color: Get.find<ColorController>().colorSet.mainTextColor,
        ),
        title: Text(
          LocaleKeys.stabilizeTheAlarm.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
