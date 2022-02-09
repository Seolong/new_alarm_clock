import 'package:flutter/material.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/add_alarm/controller/time_spinner_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/one_alarm_container.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_tab_bar.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

import 'controller/repeat_mode_controller.dart';

class ChoiceDayPage extends StatelessWidget {
  String appBarBackButtonName = 'appBar';
  String systemBackButtonName = 'system';


  Future<bool> _onTouchSystemBackButton() async {
    return await Get.dialog(
        AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            content: Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('저장하지 않고 나가시겠습니까?'),
                  Container(height: 10,),
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
                      Container(width: 1, height: 15, color: Colors.grey,),
                      TextButton(
                        child: Text('예'),
                        onPressed: () {
                          Get.find<RepeatModeController>().setRepeatModeOff();
                          print(Get.find<RepeatModeController>().getRepeatMode());
                          Get.back(result: true);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
        )
    );
  }

  Future<bool> _onTouchAppBarBackButton() async {
    return await Get.dialog(
        AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            content: Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('저장하지 않고 나가시겠습니까?'),
                  Container(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: Text('아니오'),
                        onPressed: () {
                          Get.back();
                        },
                        // ** result: returns this value up the call stack **
                      ),
                      Container(width: 1, height: 15, color: Colors.grey,),
                      TextButton(
                        child: Text('예'),
                        onPressed: () {
                          Get.find<RepeatModeController>().setRepeatModeOff();
                          print(Get.find<RepeatModeController>().getRepeatMode());
                          Get.back();
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final repeatModeController = Get.put(RepeatModeController());
    return WillPopScope(
      onWillPop: _onTouchSystemBackButton,
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
              resizeToAvoidBottomInset : false,
              appBar: AppBar(
                foregroundColor: ColorValue.appbarText,
                backgroundColor: ColorValue.appbar,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  onPressed: _onTouchAppBarBackButton,
                ),
                title: Text(
                  '날짜 선택'
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: TextButton(
                          onPressed: (){
                            Get.back();
                          },
                          child: Text(
                              '저장',
                            style: TextStyle(
                                fontSize: 1000,
                              color: ColorValue.appbarText,
                              fontWeight: FontWeight.bold,
                              fontFamily: MyFontFamily.mainFontFamily
                            ),
                          )
                      ),
                    ),
                  )
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    TabBar(
                      isScrollable: true,
                      indicatorWeight: 5,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: ColorValue.tabBarIndicator,
                      tabs: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          width: Get.width / 6,
                          alignment: Alignment.center,
                          child: Text(
                              '선택',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontFamily: MyFontFamily.mainFontFamily,
                                fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          width: Get.width / 6,
                          alignment: Alignment.center,
                          child: Text('반복',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                              fontFamily: MyFontFamily.mainFontFamily,
                                fontWeight: FontWeight.bold,
                            ),),
                        ),
                    ]),
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