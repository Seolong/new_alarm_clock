import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';

class GoingBackDialog extends StatelessWidget {
  String buttonName;
  String system = 'system';
  String appBar = 'appBar';

  GoingBackDialog(this.buttonName);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        content: Container(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('저장하지 않고 나가시겠습니까?'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text('아니오',
                    style: TextStyle(color:Colors.grey),),
                    onPressed: () {
                      Get.back(result: false);
                    },
                    // ** result: returns this value up the call stack **
                  ),
                  Container(
                    width: 1,
                    height: 15,
                    color: Colors.grey,
                  ),
                  TextButton(
                    child: Text('예'),
                    onPressed: () {
                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
                          statusBarColor: ColorValue.mainBackground,
                        ));
                      if (buttonName == system) {
                        Get.back(result: true);
                      } else if (buttonName == appBar) {
                        Get.back(result: true);
                        Get.back(result: true);
                      } else {
                        assert(false, 'buttonName error in GoingBackDialog');
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
