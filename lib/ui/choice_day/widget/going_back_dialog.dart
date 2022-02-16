import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';

class GoingBackDialog extends StatelessWidget {
  String buttonName;
  String pageName;
  String system = 'system';
  String appBar = 'appBar';
  String choiceDay = 'ChoiceDay';
  String addAlarm = 'AddAlarm';

  GoingBackDialog(this.pageName, this.buttonName);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        content: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('저장하지 않고 나가시겠습니까?'),
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text('아니오'),
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
                      if(pageName == choiceDay){
                        Get.find<RepeatModeController>().setRepeatModeOff();
                        print(Get.find<RepeatModeController>().getRepeatMode());
                      } else if(pageName == addAlarm){
                        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
                          statusBarColor: ColorValue.mainBackground,
                        ));
                      } else{
                        assert(false, 'pageName error in GoingBackDialog');
                      }
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
