import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_tab_bar_view.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

class RepeatTabBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
          children:[
            TabBar(
              labelStyle: TextStyle(
                fontFamily: MyFontFamily.mainFontFamily,
                  fontWeight: FontWeight.bold,
              ),
              indicatorColor: Colors.teal,
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.black54,
              isScrollable: true,
              tabs: <Widget>[
                Tab(
                  text: "일",
                ),
                Tab(
                  text: "주",
                ),
                Tab(
                  text: "월",
                ),
                Tab(
                  text: "Four",
                ),
                Tab(
                  text: "Five",
                ),
              ],
            ),
            Container(
              height: Get.height * 0.70,
              margin: EdgeInsets.only(left: 16.0, right: 16.0),
              child: RepeatTabBarView()
            )
          ]
      ),
    );
  }
}
