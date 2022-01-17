import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 250,
            color: Colors.grey[300],
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_rounded),
                        Text('출근 준비',
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: MyFontFamily.mainFontFamily),)
                      ],
                    ),
                    Text('첫 출근 알람',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: MyFontFamily.mainFontFamily),),
                    Text('0일 14시간 12분 남음',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: MyFontFamily.mainFontFamily),),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 15,
          ),
          DrawerItem(
            onTap: () {},
            iconData: Icons.color_lens,
            text: '테마',
          ),
          DrawerItem(
            onTap: () {},
            iconData: Icons.subject_rounded,
            text: '정렬',
          ),
          DrawerItem(
            onTap: () {},
            iconData: Icons.format_size_rounded,
            text: '글자 크기',
          ),
          DrawerItem(
            onTap: () {},
            iconData: Icons.folder_special_rounded,
            text: '홈 화면 폴더',
          ),
          DrawerItem(
            onTap: () {},
            iconData: Icons.volunteer_activism_rounded,
            text: '후원',
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  void Function()? onTap;
  IconData iconData;
  String text;

//color넣기
  DrawerItem({
    required this.onTap,
    required this.iconData,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: ButtonSize.medium + 16,
      child: InkWell(
        onTap: this.onTap,
        splashColor: Colors.grey,
        //간격 좀더 보기 좋게..?
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                iconData,
                size: ButtonSize.medium,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      this.text,
                      style: TextStyle(
                          fontSize: 1000,
                          fontFamily: MyFontFamily.mainFontFamily),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
