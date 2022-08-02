import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/data/shared_preferences/app_state_shared_preferences.dart';
import 'package:new_alarm_clock/routes/app_pages.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/service/life_cycle_listener.dart';
import 'package:new_alarm_clock/service/notification_controller.dart';
import 'package:new_alarm_clock/ui/alarm_alarm/alarm_alarm_page.dart';
import 'package:new_alarm_clock/ui/global/color_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/ui/home/home_page.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

final AppStateSharedPreferences _appStateSharedPreferences =
    AppStateSharedPreferences();
String appState = 'main';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsBinding.instance.addObserver(LifeCycleListener());

  await EasyLocalization.ensureInitialized();
  await AndroidAlarmManager.initialize();
  appState = await _appStateSharedPreferences.getAppState();

  await AwesomeNotifications().initialize(
      'resource://drawable/res_round_alarm_24',
      //null,
      [            // notification icon
        NotificationChannel(
          channelGroupKey: 'basic_test',
          channelKey: StringValue.notificationChannelKey,
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          channelShowBadge: true,
          importance: NotificationImportance.High,
          enableVibration: true,
        ),

      ]
  );

  runApp(
      EasyLocalization(
          supportedLocales: [Locale('ko'), Locale('en')],
          path: 'assets/translations', // <-- change the path of the translation files
          fallbackLocale: Locale('ko'),
          startLocale: Locale('ko'),
          child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    Get.put(AlarmListController());
    Get.put(ColorController());
    //context.setLocale(Locale('en')); //이거 한번만 하면 뭐 shared 이런 거 할 필요없이 클릭 한번에 끝
    try {
      AwesomeNotifications().setListeners(
          onActionReceivedMethod: NotificationController.onActionReceivedMethod
      );
    } catch (e) {
      print('Say! eeeeee $e');
    }

    return GetMaterialApp(
      navigatorKey: MyApp.navigatorKey,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Get.find<ColorController>().colorSet.mainColor,
          ),
          textTheme: TextTheme(
            headline1: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
            headline2: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
            headline3: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
            headline4: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
            headline5: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
            headline6: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
            subtitle1: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
            subtitle2: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
            bodyText1: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
            bodyText2: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
            caption: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
            button: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
            overline: TextStyle(fontFamily: MyFontFamily.mainFontFamily),
          )),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: appState == 'alarm' ?
      AlarmAlarmPage()
          : Home(),
    );
  }
}
