import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_alarm_clock/data/shared_preferences/settings_shared_preferences.dart';
import 'package:new_alarm_clock/service/call_native_service.dart';
import 'package:new_alarm_clock/service/music_handler.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/tab_page_controller.dart';
import 'package:new_alarm_clock/ui/home/page/book_page/book_page.dart';
import 'package:new_alarm_clock/ui/home/page/folder_page/folder_page.dart';
import 'package:new_alarm_clock/ui/home/page/inner_home_page/inner_home_page.dart';
import 'package:new_alarm_clock/ui/home/page/inner_home_page/widgets/alarm_item/controller/selected_alarm_controller.dart';
import 'package:new_alarm_clock/ui/home/page/setting_page/setting_page.dart';
import 'package:new_alarm_clock/ui/home/widgets/battery_optimization_dialog.dart';
import 'package:new_alarm_clock/ui/home/widgets/home_bottom_navigation_bar.dart';
import 'package:new_alarm_clock/ui/home/widgets/home_fab.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wekker',
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
  final DialogStateSharedPreference dialogStateSharedPreference = DialogStateSharedPreference();
  final MusicHandler _musicHandler = MusicHandler();

  Future<bool> checkBatteryOptimizations()async{
    return await CallNativeService().checkBatteryOptimizations();
  }

  Future<void> setBatteryOptimizations()async{
    if((await checkBatteryOptimizations())==false){
      bool isDontAsk = await dialogStateSharedPreference.getIsDontAskValue();
      if(isDontAsk){
        return;
      }

      bool isOpen = await dialogStateSharedPreference.getIsOpenValue();
      if(isOpen){
        return;
      }
      await dialogStateSharedPreference.setIsOpenValue(true);

      bool? isSet = await Get.dialog(BatteryOptimizationDialog(dialogStateSharedPreference));
      await dialogStateSharedPreference.setIsOpenValue(false);
      if(isSet == true){
        CallNativeService().setBatteryOptimizations();
      }
    }
  }

  HomePage(){
    setBatteryOptimizations();
  }

  @override
  Widget build(BuildContext context) {
    _musicHandler.initOriginalVolume();
    Get.put(TabPageController());
    Get.put(SelectedAlarmController());
    _settingsSharedPreferences.init();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Get.find<ColorController>().colorSet.mainColor));
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
                //setBatteryOptimizations();
                return IndexedStack(
                  index: controller.pageIndex,
                  children: [
                    InnerHomePage(),
                    FolderPage(),
                    FolderPage(),
                    BookPage(),
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

class DialogStateSharedPreference{
  static final DialogStateSharedPreference _instance = DialogStateSharedPreference._internal();
  late SharedPreferences sharedPreferences;
  final String isOpen = 'isOpen';
  final String isDontAsk = 'dontAsk';

  factory DialogStateSharedPreference() {
    return _instance;
  }

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();

    bool? isOpenValue = sharedPreferences.getBool(isOpen);
    if(isOpenValue == null){
      sharedPreferences.setBool(isOpen, false);
    }
    bool? isDontAskValue = sharedPreferences.getBool(isDontAsk);
    if(isDontAskValue == null){
      sharedPreferences.setBool(isDontAsk, false);
    }
  }

  DialogStateSharedPreference._internal();

  Future<bool> getIsOpenValue() async{
    await init();
    return sharedPreferences.getBool(isOpen)!;
  }
  Future<void> setIsOpenValue(bool isOpenValue)async {
    await init();
    sharedPreferences.setBool(isOpen, isOpenValue);
  }

  Future<bool> getIsDontAskValue() async{
    await init();
    return sharedPreferences.getBool(isDontAsk)!;
  }
  Future<void> setIsDontAskValue(bool isDontAskValue)async {
    await init();
    sharedPreferences.setBool(isDontAsk, isDontAskValue);
  }
}