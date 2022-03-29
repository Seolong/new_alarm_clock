import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/day_of_week_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/interval_text_field_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/one_alarm_container.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_tab_bar.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';

import 'controller/repeat_mode_controller.dart';

class ChoiceDayPage extends StatelessWidget {
  String appBarBackButtonName = 'appBar';
  String systemBackButtonName = 'system';
  final repeatModeController = Get.put(RepeatModeController());


  Future<bool> _onTouchBackButton() async {
    if(repeatModeController.repeatMode != RepeatMode.week){
      Get.find<DayOfWeekController>().resetAllDayButtonStateToFalse();
    }
    else{ // RepeatMode.week
      if(Get.find<DayOfWeekController>().dayButtonStateMap.containsValue(true) == false){
        repeatModeController.repeatMode = RepeatMode.off;
        print(repeatModeController.repeatMode);
      }
    }
    if(repeatModeController.repeatMode == RepeatMode.single){
      Get.back();
      return Future.value(false);
    }
    Get.find<StartEndDayController>().setStartDayWithButton(
        repeatModeController.repeatMode);
    if(Get.find<IntervalTextFieldController>().textEditingController.text == ''){
      Get.find<IntervalTextFieldController>().textEditingController.text = '1';
    }
    Get.back();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onTouchBackButton,
      child: DefaultTabController(
        length: 2,
        //뭐 builder로 감싸서 싸바싸바 아이샤바
        //탭하면 repeatmode가 defualt인지 day, week, month 아무튼 뭔지 기록
        //일단 지금 생각은 getxcontroller로 제어할까..
        //DefaultTabController.of(context).addListener(() { })
        child: Builder(
            builder: (context) {
              final tabController = DefaultTabController.of(context)!;
              repeatModeController.setRepeatMode(0, 0);
              print(repeatModeController.getRepeatMode());
              tabController.addListener(() {
                repeatModeController.setRepeatMode(tabController.index, 0);
                print(repeatModeController.getRepeatMode());
              });
              return Scaffold(
                backgroundColor: ColorValue.addAlarmPageBackground,
                resizeToAvoidBottomInset : false,
                appBar: AppBar(
                  foregroundColor: ColorValue.appbarText,
                  backgroundColor: ColorValue.appbar,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: _onTouchBackButton,
                  ),
                  title: Text(
                      '날짜 선택'
                  ),
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: TabBar(
                            isScrollable: true,
                            indicatorWeight: 5,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: ColorValue.tabBarIndicator,
                            unselectedLabelColor: Colors.grey,
                            labelColor: Colors.black,
                            tabs: [
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                height: 37.5,
                                width: 60,
                                alignment: Alignment.center,
                                child: AutoSizeText('선택', bold: true, color: null,),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                height: 37.5,
                                width: 60,
                                alignment: Alignment.center,
                                child: AutoSizeText('반복', bold: true, color: null,),
                              ),
                            ]),
                      ),
                      Divider(
                        height: 5,
                        color: ColorValue.defaultBackground,
                      ),
                      Flexible(
                        flex: 1,
                        child: TabBarView(children: [
                          OneAlarmContainer(),
                          RepeatTabBar(),
                        ]),
                      )
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}