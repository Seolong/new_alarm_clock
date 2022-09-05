import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:new_alarm_clock/ui/stabilization/controller/permission_controller.dart';
import 'package:new_alarm_clock/ui/stabilization/widget/stabilization_container.dart';

import '../../generated/locale_keys.g.dart';

class StabilizationPage extends StatelessWidget {
  const StabilizationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PermissionController());
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 16,),
           OutlinedButton(
              onPressed: () {},
              child: Text(
                '경고 무시하기',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16,),
            StabilizationContainer(
                title: '다른 앱 위에 표시',
                content: '앱이 꺼져있을 때에도 알람 시간이 되면 알람을 울리기 위해, '
                    '\'다른 앱 위에 표시\' 권한을 허용해야 합니다. \'설정하기\' 버튼을 누르고'
                    ' 권한을 허용해주세요.',
                onSetPressed: () {}),
            StabilizationContainer(
                title: LocaleKeys.batteryOptimization.tr(),
                content: LocaleKeys.batteryOptimizationIsOn.tr(),
                onSetPressed: () {}),
            StabilizationContainer(
                title: '방해 금지 모드',
                content: '라라라라재라ㅐㅐㅔㄹ잘데ㅐ',
                onSetPressed: () {}),
          ],
        ),
      ),
    );
  }
}
