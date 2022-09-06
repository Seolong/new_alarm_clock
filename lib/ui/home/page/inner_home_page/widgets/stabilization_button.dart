import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/stabilization/controller/permission_controller.dart';

class StabilizationButton extends StatelessWidget {
  const StabilizationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PermissionController>(builder: (_) {
      if(_.isAllTrue){
        return const SizedBox.shrink();
      }
      return FutureBuilder(
          future: _.warningSharedPreference.getIsIgnoreValue(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            } else if (snapshot.data == true) {
              return const SizedBox.shrink();
            }
            return Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.yellow, width: 5),
                  borderRadius: BorderRadius.circular(5)),
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.stabilizationPage);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_rounded,
                        color: Colors.yellow,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        LocaleKeys.stabilizeTheAlarm.tr(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(Icons.chevron_right_rounded)
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }
}
