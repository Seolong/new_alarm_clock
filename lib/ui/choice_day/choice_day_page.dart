import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/one_alarm_container.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_tab_bar.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

class ChoiceDayPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          foregroundColor: ColorValue.appbarText,
          backgroundColor: ColorValue.appbar,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Get.back();
            },
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
      ),
    );
  }
}