import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/generated/locale_keys.g.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_page_factory.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/controller/repeat_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/controller/vibration_radio_list_controller.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:get/get.dart' hide Trans;
import 'package:new_alarm_clock/utils/values/string_value.dart';

class AlarmDetailListTile extends StatelessWidget {
  Text tileTitle =
      Text('', style: TextStyle(fontFamily: MyFontFamily.mainFontFamily));
  dynamic tileSubTitle;
  dynamic stateSwitch = Switch(value: true, onChanged: null);
  final AlarmDetailPageFactory alarmDetailPageFactory = AlarmDetailPageFactory();
  dynamic currentListTileController;

  @override
  Widget build(BuildContext context) {
    if(tileTitle.data! == LocaleKeys.ringtone.tr()){
      currentListTileController = Get.put(RingRadioListController());
    }else if(tileTitle.data! == StringValue.vibration){
      currentListTileController = Get.put(VibrationRadioListController());
    }else if(tileTitle.data! == StringValue.repeat){
      currentListTileController = Get.put(RepeatRadioListController());
    }else{
      assert(false, 'error in currentListTileController of AlarmDetailListTile');
    }

    return Container(
      height: 77.5,
      child: InkWell(
        onTap: () {
          ////////리스트타일 터치해서 해당 페이지로 넘어가는 메소드.
          /////factory메소드 패턴으로 만든 그거 활용

          alarmDetailPageFactory.getAlarmDetailPage(tileTitle.data!);
        },
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 7.5, 0, 7.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //tileTitle
                          Expanded(
                            flex: 5,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minWidth: 1, minHeight: 1),
                                  child: tileTitle),
                            ),
                          ),

                          //tileSubTitle
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(2.5, 0, 0, 0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minWidth: 1, minHeight: 1),
                                    child: tileSubTitle),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //스위치
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: stateSwitch,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }
}
