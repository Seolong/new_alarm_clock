import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_alarm_clock/data/shared_preferences/id_shared_preferences.dart';
import 'package:new_alarm_clock/data/shared_preferences/settings_shared_preferences.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/service/music_handler.dart';
import 'package:new_alarm_clock/ui/global/alarm_item/controller/selected_alarm_controller.dart';
import 'package:new_alarm_clock/ui/global/convenience_method.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_list_controller.dart';
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
  final SettingsSharedPreferences _settingsSharedPreferences = SettingsSharedPreferences();
  MusicHandler _musicHandler = MusicHandler();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: ColorValue.mainBackground,
    ));
    _musicHandler.initOriginalVolume();
    Get.put(TabPageController());
    Get.put(SelectedAlarmController());
    var folderListController = Get.put(FolderListController());
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
                Get.closeAllSnackbars();
                Get.find<SelectedAlarmController>().isSelectedMode = false;
                int newId = await idSharedPreferences.getId();
                Map<String, dynamic> argToNextPage = ConvenienceMethod().getArgToNextPage(
                    StringValue.addMode,
                    newId,
                    folderListController.currentFolderName
                );
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
                      selectedItemColor: Color(0xff753422),
                      unselectedItemColor: ColorValue.tabBarIcon,
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(
                              Icons.home_rounded,
                            ),
                            label: "홈"
                        ),
                        BottomNavigationBarItem(
                            icon: Icon(
                              Icons.folder,
                            ),
                            label: "폴더"
                        ),
                        BottomNavigationBarItem(//더미
                            icon: Icon(null),
                            label: "홈"
                        ),
                        BottomNavigationBarItem(
                            icon: Icon(
                              Icons.volunteer_activism_rounded,
                            ),
                            label: "후원"
                        ),
                        BottomNavigationBarItem(
                            icon: Icon(
                                Icons.more_horiz,
                            ),
                            label: "더보기"
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
        ),
    );
  }
}
