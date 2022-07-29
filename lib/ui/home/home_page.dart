import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_alarm_clock/data/shared_preferences/settings_shared_preferences.dart';
import 'package:new_alarm_clock/service/music_handler.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/tab_page_controller.dart';
import 'package:new_alarm_clock/ui/home/page/folder_page/folder_page.dart';
import 'package:new_alarm_clock/ui/home/page/inner_home_page/inner_home_page.dart';
import 'package:new_alarm_clock/ui/home/page/inner_home_page/widgets/alarm_item/controller/selected_alarm_controller.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/setting_page.dart';
import 'package:new_alarm_clock/ui/home/widgets/home_bottom_navigation_bar.dart';
import 'package:new_alarm_clock/ui/home/widgets/home_fab.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '알람시계',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Get.find<ColorController>().colorSet.mainColor,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final SettingsSharedPreferences _settingsSharedPreferences = SettingsSharedPreferences();
  final MusicHandler _musicHandler = MusicHandler();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Get.find<ColorController>().colorSet.mainColor,
    ));
    _musicHandler.initOriginalVolume();
    Get.put(TabPageController());
    Get.put(SelectedAlarmController());
    _settingsSharedPreferences.init();
    return WillPopScope(
      onWillPop: () {
        //selectedMode면 selectedMode를 해제하고
        if(Get.find<SelectedAlarmController>().isSelectedMode){
          Get.find<SelectedAlarmController>().isSelectedMode = false;
          Get.closeAllSnackbars();
          return Future.value(false);
        }
        //아니면 앱을 끈다.
        else{
          return Future.value(true);
        }
      },
      child: Scaffold(
        extendBody: true, //FAB 배경이 투명해지기 위함
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: HomeFAB(),
        bottomNavigationBar: HomeBottomNavigationBar(),
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
      ),
    );
  }
}
