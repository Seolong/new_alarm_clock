import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:new_alarm_clock/ui/stabilization/controller/permission_controller.dart';
import '../../../generated/locale_keys.g.dart';

class StabilizationContainer extends StatelessWidget {
  StabilizationContainer(
      {Key? key,
      required this.title,
      required this.content,
      required this.onSetPressed})
      : super(key: key);

  String title;
  String content;
  final VoidCallback? onSetPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            content,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GetBuilder<PermissionController>(
                builder: (_) {
                  return MaterialButton(
                    onPressed: onSetPressed,
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(LocaleKeys.set.tr()),
                  );
                }
              ),
            ],
          )
        ],
      ),
    );
  }
}
