import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:new_alarm_clock/ui/stabilization/controller/permission_controller.dart';
import '../../../generated/locale_keys.g.dart';
import '../../global/color_controller.dart';

class StabilizationContainer extends StatelessWidget {
  StabilizationContainer(
      {Key? key,
      required this.code,
      required this.title,
      required this.content})
      : super(key: key);

  String code;
  String title;
  String content;

  @override
  Widget build(BuildContext context) {
    var colorController = Get.find<ColorController>();
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 20, color: colorController.colorSet.mainTextColor),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            content,
            style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: colorController.colorSet.mainTextColor),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GetBuilder<PermissionController>(builder: (_) {
                return MaterialButton(
                  onPressed: _.getOnSetPressedByName(code),
                  color: colorController.colorSet.lightMainColor,
                  disabledColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    _.getBoolByName(code) == false
                        ? LocaleKeys.set.tr()
                        : LocaleKeys.resolved.tr(),
                    style: const TextStyle(
                        color: Colors.black),
                  ),
                );
              }),
            ],
          )
        ],
      ),
    );
  }
}
