import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_alarm_clock/data/shared_preferences/id_shared_preferences.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/home/controller/tab_page_controller.dart';
import 'package:new_alarm_clock/ui/home/page/folder_page/folder_page.dart';
import 'package:new_alarm_clock/ui/home/page/inner_home_page/inner_home_page.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/setting_page.dart';
import 'package:new_alarm_clock/ui/home/widgets/home_drawer.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

class Home extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '알람시계',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: ColorValue.appbar,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final IdSharedPreferences idSharedPreferences = IdSharedPreferences();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: ColorValue.mainBackground,
    ));
    Get.put(TabPageController());
    return Scaffold(
        drawer: HomeDrawer(),
        extendBody: true, //FAB 배경이 투명해지기 위함
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width: ButtonSize.xlarge,
          height: ButtonSize.xlarge,
          child: FloatingActionButton( // addAlarmButton
            //폴더 탭일 때 다른 색, 메뉴 탭일 땐 disable임을 나타내기 위해 회색
            backgroundColor: ColorValue.fab,
            child: FittedBox(
              child: Icon(
                Icons.add_rounded,
                size: 1000,
              ),
            ),
            onPressed: () async{
              int newId = await idSharedPreferences.getId();
              Map<String, dynamic> argToNextPage = {StringValue.mode : StringValue.addMode,
                StringValue.alarmId : newId};
              idSharedPreferences.setId(++newId);
              Get.toNamed(AppRoutes.addAlarmPage, arguments: argToNextPage);
            },
          ),
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(
            canvasColor: ColorValue.mainBackground,
            //중간 더미 BottomNavigationBarItem 터치 효과가 안 보이게 하기 위함
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomAppBar(
              shape: CircularNotchedRectangle(),
              notchMargin: 5,
              clipBehavior: Clip.antiAlias,
              child: GetBuilder<TabPageController>(
                builder:(controller) {
                  return BottomNavigationBar(
                    currentIndex: controller.pageIndex,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    selectedFontSize: 0,
                    unselectedFontSize: 0,
                    iconSize: ButtonSize.medium,
                    onTap: controller.setPageIndex,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                          icon: Icon(
                            Icons.home_rounded,
                            color: ColorValue.tabBarIcon,
                          ),
                          title: Text("홈")
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(
                            Icons.folder,
                            color: ColorValue.tabBarIcon,
                          ),
                          title: Text("폴더")
                      ),
                      BottomNavigationBarItem(//더미
                          icon: Icon(null),
                          title: Text("홈")
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(
                            Icons.volunteer_activism_rounded,
                            color: ColorValue.tabBarIcon,
                          ),
                          title: Text("후원")
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(
                              Icons.more_horiz,
                              color: ColorValue.tabBarIcon
                          ),
                          title: Text("더보기")
                      ),
                    ],
                  );}
              ),
              ),
        ),
        body: SafeArea(
          bottom: false,
          child: GetBuilder<TabPageController>(
            builder: (controller) {
              return IndexedStack(
                index: controller.pageIndex,
                children: [
                  InnerHomePage(),
                  FolderPage(),
                  FolderPage(),
                  FolderPage(),
                  SettingPage(),
                ],
              );
            }
          ),
        ),
      );
  }
}
